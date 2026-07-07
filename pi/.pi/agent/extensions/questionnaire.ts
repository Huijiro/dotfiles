/**
 * Questionnaire Tool - Unified tool for asking single or multiple questions
 *
 * Single question: simple options list
 * Multiple questions: tab bar navigation between questions
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import {
  Editor,
  type EditorTheme,
  Key,
  matchesKey,
  Text,
  truncateToWidth,
} from "@mariozechner/pi-tui";
import { Type } from "@sinclair/typebox";

// Types
interface QuestionOption {
  value: string;
  label: string;
  description?: string;
}

type RenderOption = QuestionOption & { isOther?: boolean };

interface Question {
  id: string;
  label: string;
  prompt: string;
  options: QuestionOption[];
  allowOther: boolean;
  multi: boolean;
}

interface AnswerSelection {
  value: string;
  label: string;
  wasCustom: boolean;
  index?: number;
}

interface Answer {
  id: string;
  multi: boolean;
  // For single-select, selections has exactly one entry. The top-level
  // value/label/wasCustom/index mirror it for backwards compatibility.
  value: string;
  label: string;
  wasCustom: boolean;
  index?: number;
  selections: AnswerSelection[];
}

interface QuestionnaireResult {
  questions: Question[];
  answers: Answer[];
  cancelled: boolean;
}

// Schema
const QuestionOptionSchema = Type.Object({
  value: Type.String({ description: "The value returned when selected" }),
  label: Type.String({ description: "Display label for the option" }),
  description: Type.Optional(
    Type.String({ description: "Optional description shown below label" }),
  ),
});

const QuestionSchema = Type.Object({
  id: Type.String({ description: "Unique identifier for this question" }),
  label: Type.Optional(
    Type.String({
      description:
        "Short contextual label for tab bar, e.g. 'Scope', 'Priority' (defaults to Q1, Q2)",
    }),
  ),
  prompt: Type.String({ description: "The full question text to display" }),
  options: Type.Array(QuestionOptionSchema, {
    description: "Available options to choose from",
  }),
  allowOther: Type.Optional(
    Type.Boolean({
      description: "Allow 'Type something' option (default: true)",
    }),
  ),
  multi: Type.Optional(
    Type.Boolean({
      description:
        "Allow selecting multiple options. Space toggles, Enter confirms (default: false)",
    }),
  ),
});

const QuestionnaireParams = Type.Object({
  questions: Type.Array(QuestionSchema, {
    description: "Questions to ask the user",
  }),
});

function errorResult(
  message: string,
  questions: Question[] = [],
): { content: { type: "text"; text: string }[]; details: QuestionnaireResult } {
  return {
    content: [{ type: "text", text: message }],
    details: { questions, answers: [], cancelled: true },
  };
}

export default function questionnaire(pi: ExtensionAPI) {
  pi.registerTool({
    name: "questionnaire",
    label: "Questionnaire",
    description:
      "Ask the user one or more questions. Use for clarifying requirements, getting preferences, or confirming decisions. For single questions, shows a simple option list. For multiple questions, shows a tab-based interface.",
    parameters: QuestionnaireParams,

    async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
      if (!ctx.hasUI) {
        return errorResult(
          "Error: UI not available (running in non-interactive mode)",
        );
      }
      if (params.questions.length === 0) {
        return errorResult("Error: No questions provided");
      }

      // Normalize questions with defaults
      const questions: Question[] = params.questions.map((q, i) => ({
        ...q,
        label: q.label || `Q${i + 1}`,
        allowOther: q.allowOther !== false,
        multi: q.multi === true,
      }));

      const isMulti = questions.length > 1;
      const totalTabs = questions.length + 1; // questions + Submit

      const result = await ctx.ui.custom<QuestionnaireResult>(
        (tui, theme, _kb, done) => {
          // State
          let currentTab = 0;
          let optionIndex = 0;
          let inputMode = false;
          let inputQuestionId: string | null = null;
          let cachedLines: string[] | undefined;
          const answers = new Map<string, Answer>();
          // Per-question pending selections for multi-select mode.
          // Keyed by question id; values are option indices into currentOptions().
          // Custom ("Type something") entries are tracked separately.
          const pendingSelections = new Map<string, Set<number>>();
          const pendingCustom = new Map<string, string>();

          // Editor for "Type something" option
          const editorTheme: EditorTheme = {
            borderColor: (s) => theme.fg("accent", s),
            selectList: {
              selectedPrefix: (t) => theme.fg("accent", t),
              selectedText: (t) => theme.fg("accent", t),
              description: (t) => theme.fg("muted", t),
              scrollInfo: (t) => theme.fg("dim", t),
              noMatch: (t) => theme.fg("warning", t),
            },
          };
          const editor = new Editor(tui, editorTheme);

          // Helpers
          function refresh() {
            cachedLines = undefined;
            tui.requestRender();
          }

          function submit(cancelled: boolean) {
            done({
              questions,
              answers: Array.from(answers.values()),
              cancelled,
            });
          }

          function currentQuestion(): Question | undefined {
            return questions[currentTab];
          }

          function currentOptions(): RenderOption[] {
            const q = currentQuestion();
            if (!q) return [];
            const opts: RenderOption[] = [...q.options];
            if (q.allowOther) {
              opts.push({
                value: "__other__",
                label: "Type something.",
                isOther: true,
              });
            }
            return opts;
          }

          function allAnswered(): boolean {
            return questions.every((q) => answers.has(q.id));
          }

          function advanceAfterAnswer() {
            if (!isMulti) {
              submit(false);
              return;
            }
            if (currentTab < questions.length - 1) {
              currentTab++;
            } else {
              currentTab = questions.length; // Submit tab
            }
            optionIndex = 0;
            refresh();
          }

          function saveAnswer(
            questionId: string,
            value: string,
            label: string,
            wasCustom: boolean,
            index?: number,
          ) {
            answers.set(questionId, {
              id: questionId,
              multi: false,
              value,
              label,
              wasCustom,
              index,
              selections: [{ value, label, wasCustom, index }],
            });
          }

          function getPending(questionId: string): Set<number> {
            let set = pendingSelections.get(questionId);
            if (!set) {
              set = new Set<number>();
              pendingSelections.set(questionId, set);
            }
            return set;
          }

          function confirmMulti(q: Question): boolean {
            const opts = q.options; // exclude "Type something" sentinel
            const set = pendingSelections.get(q.id) ?? new Set<number>();
            const custom = pendingCustom.get(q.id);
            const selections: AnswerSelection[] = [];
            // Preserve option order.
            for (let i = 0; i < opts.length; i++) {
              if (set.has(i)) {
                selections.push({
                  value: opts[i].value,
                  label: opts[i].label,
                  wasCustom: false,
                  index: i + 1,
                });
              }
            }
            if (custom) {
              selections.push({ value: custom, label: custom, wasCustom: true });
            }
            if (selections.length === 0) {
              return false;
            }
            const first = selections[0];
            answers.set(q.id, {
              id: q.id,
              multi: true,
              value: first.value,
              label: first.label,
              wasCustom: first.wasCustom,
              index: first.index,
              selections,
            });
            return true;
          }

          // Editor submit callback
          editor.onSubmit = (value) => {
            if (!inputQuestionId) return;
            const trimmed = value.trim() || "(no response)";
            const qId = inputQuestionId;
            const q = questions.find((x) => x.id === qId);
            inputMode = false;
            inputQuestionId = null;
            editor.setText("");
            if (q?.multi) {
              // Stash the custom entry; user confirms the whole set with Enter.
              pendingCustom.set(qId, trimmed);
              refresh();
              return;
            }
            saveAnswer(qId, trimmed, trimmed, true);
            advanceAfterAnswer();
          };

          function handleInput(data: string) {
            // Input mode: route to editor
            if (inputMode) {
              if (matchesKey(data, Key.escape)) {
                inputMode = false;
                inputQuestionId = null;
                editor.setText("");
                refresh();
                return;
              }
              editor.handleInput(data);
              refresh();
              return;
            }

            const q = currentQuestion();
            const opts = currentOptions();

            // Tab navigation (multi-question only)
            if (isMulti) {
              if (matchesKey(data, Key.tab) || matchesKey(data, Key.right) || matchesKey(data, "l")) {
                currentTab = (currentTab + 1) % totalTabs;
                optionIndex = 0;
                refresh();
                return;
              }
              if (
                matchesKey(data, Key.shift("tab")) ||
                matchesKey(data, Key.left) ||
                matchesKey(data, "h")
              ) {
                currentTab = (currentTab - 1 + totalTabs) % totalTabs;
                optionIndex = 0;
                refresh();
                return;
              }
            }

            // Submit tab
            if (currentTab === questions.length) {
              if (matchesKey(data, Key.enter) && allAnswered()) {
                submit(false);
              } else if (matchesKey(data, Key.escape)) {
                submit(true);
              }
              return;
            }

            // Option navigation
            if (matchesKey(data, Key.up) || matchesKey(data, "k")) {
              optionIndex = Math.max(0, optionIndex - 1);
              refresh();
              return;
            }
            if (matchesKey(data, Key.down) || matchesKey(data, "j")) {
              optionIndex = Math.min(opts.length - 1, optionIndex + 1);
              refresh();
              return;
            }

            // Toggle option (multi-select only)
            if (matchesKey(data, " ") && q && q.multi) {
              const opt = opts[optionIndex];
              if (opt.isOther) {
                // Space on "Type something" opens the editor too.
                inputMode = true;
                inputQuestionId = q.id;
                editor.setText(pendingCustom.get(q.id) ?? "");
                refresh();
                return;
              }
              const set = getPending(q.id);
              if (set.has(optionIndex)) {
                set.delete(optionIndex);
              } else {
                set.add(optionIndex);
              }
              refresh();
              return;
            }

            // Select option
            if (matchesKey(data, Key.enter) && q) {
              const opt = opts[optionIndex];
              if (opt.isOther) {
                inputMode = true;
                inputQuestionId = q.id;
                editor.setText(q.multi ? (pendingCustom.get(q.id) ?? "") : "");
                refresh();
                return;
              }
              if (q.multi) {
                // Enter on a regular option in multi mode: ensure it's
                // selected, then confirm the set.
                const set = getPending(q.id);
                set.add(optionIndex);
                if (confirmMulti(q)) {
                  advanceAfterAnswer();
                }
                return;
              }
              saveAnswer(q.id, opt.value, opt.label, false, optionIndex + 1);
              advanceAfterAnswer();
              return;
            }

            // Cancel
            if (matchesKey(data, Key.escape)) {
              submit(true);
            }
          }

          function render(width: number): string[] {
            if (cachedLines) return cachedLines;

            const lines: string[] = [];
            const q = currentQuestion();
            const opts = currentOptions();

            // Helper to add truncated line
            const add = (s: string) => lines.push(truncateToWidth(s, width));

            add(theme.fg("accent", "─".repeat(width)));

            // Tab bar (multi-question only)
            if (isMulti) {
              const tabs: string[] = ["← "];
              for (let i = 0; i < questions.length; i++) {
                const isActive = i === currentTab;
                const isAnswered = answers.has(questions[i].id);
                const lbl = questions[i].label;
                const box = isAnswered ? "■" : "□";
                const color = isAnswered ? "success" : "muted";
                const text = ` ${box} ${lbl} `;
                const styled = isActive
                  ? theme.bg("selectedBg", theme.fg("text", text))
                  : theme.fg(color, text);
                tabs.push(`${styled} `);
              }
              const canSubmit = allAnswered();
              const isSubmitTab = currentTab === questions.length;
              const submitText = " ✓ Submit ";
              const submitStyled = isSubmitTab
                ? theme.bg("selectedBg", theme.fg("text", submitText))
                : theme.fg(canSubmit ? "success" : "dim", submitText);
              tabs.push(`${submitStyled} →`);
              add(` ${tabs.join("")}`);
              lines.push("");
            }

            // Helper to render options list
            function renderOptions() {
              const isMultiQ = q?.multi === true;
              const pending = q ? pendingSelections.get(q.id) : undefined;
              const customEntry = q ? pendingCustom.get(q.id) : undefined;
              for (let i = 0; i < opts.length; i++) {
                const opt = opts[i];
                const cursorOn = i === optionIndex;
                const isOther = opt.isOther === true;
                const prefix = cursorOn ? theme.fg("accent", "> ") : "  ";
                const color = cursorOn ? "accent" : "text";
                let box = "";
                if (isMultiQ) {
                  const checked = isOther
                    ? !!customEntry
                    : !!pending?.has(i);
                  box = `${checked ? "[x]" : "[ ]"} `;
                }
                // Mark "Type something" differently when in input mode
                if (isOther && inputMode) {
                  add(prefix + theme.fg("accent", `${box}${i + 1}. ${opt.label} ✎`));
                } else if (isOther && isMultiQ && customEntry) {
                  add(
                    prefix +
                      theme.fg(color, `${box}${i + 1}. ${opt.label}: `) +
                      theme.fg("muted", customEntry),
                  );
                } else {
                  add(prefix + theme.fg(color, `${box}${i + 1}. ${opt.label}`));
                }
                if (opt.description) {
                  add(`     ${theme.fg("muted", opt.description)}`);
                }
              }
            }

            // Content
            if (inputMode && q) {
              add(theme.fg("text", ` ${q.prompt}`));
              lines.push("");
              // Show options for reference
              renderOptions();
              lines.push("");
              add(theme.fg("muted", " Your answer:"));
              for (const line of editor.render(width - 2)) {
                add(` ${line}`);
              }
              lines.push("");
              add(theme.fg("dim", " Enter to submit • Esc to cancel"));
            } else if (currentTab === questions.length) {
              add(theme.fg("accent", theme.bold(" Ready to submit")));
              lines.push("");
              for (const question of questions) {
                const answer = answers.get(question.id);
                if (answer) {
                  const rendered = answer.selections
                    .map((s) => (s.wasCustom ? `(wrote) ${s.label}` : s.label))
                    .join(", ");
                  add(
                    `${theme.fg("muted", ` ${question.label}: `)}${theme.fg("text", rendered)}`,
                  );
                }
              }
              lines.push("");
              if (allAnswered()) {
                add(theme.fg("success", " Press Enter to submit"));
              } else {
                const missing = questions
                  .filter((q) => !answers.has(q.id))
                  .map((q) => q.label)
                  .join(", ");
                add(theme.fg("warning", ` Unanswered: ${missing}`));
              }
            } else if (q) {
              add(theme.fg("text", ` ${q.prompt}`));
              lines.push("");
              renderOptions();
            }

            lines.push("");
            if (!inputMode) {
              const isMultiQ = q?.multi === true;
              const onSubmitTab = currentTab === questions.length;
              let help: string;
              if (onSubmitTab) {
                help = " Tab/hl navigate • Enter submit • Esc cancel";
              } else if (isMultiQ) {
                help = isMulti
                  ? " Tab/hl tabs • jk move • Space toggle • Enter confirm • Esc cancel"
                  : " jk move • Space toggle • Enter confirm • Esc cancel";
              } else {
                help = isMulti
                  ? " Tab/hl navigate • jk select • Enter confirm • Esc cancel"
                  : " jk navigate • Enter select • Esc cancel";
              }
              add(theme.fg("dim", help));
            }
            add(theme.fg("accent", "─".repeat(width)));

            cachedLines = lines;
            return lines;
          }

          return {
            render,
            invalidate: () => {
              cachedLines = undefined;
            },
            handleInput,
          };
        },
      );

      if (result.cancelled) {
        return {
          content: [{ type: "text", text: "User cancelled the questionnaire" }],
          details: result,
        };
      }

      const answerLines = result.answers.map((a) => {
        const qLabel = questions.find((q) => q.id === a.id)?.label || a.id;
        const parts = a.selections.map((s) => {
          if (s.wasCustom) {
            return `user wrote: ${s.label}`;
          }
          return `user selected: ${s.index}. ${s.label}`;
        });
        return `${qLabel}: ${parts.join("; ")}`;
      });

      return {
        content: [{ type: "text", text: answerLines.join("\n") }],
        details: result,
      };
    },

    renderCall(args, theme) {
      const qs = (args.questions as Question[]) || [];
      const count = qs.length;
      const labels = qs.map((q) => q.label || q.id).join(", ");
      let text = theme.fg("toolTitle", theme.bold("questionnaire "));
      text += theme.fg("muted", `${count} question${count !== 1 ? "s" : ""}`);
      if (labels) {
        text += theme.fg("dim", ` (${truncateToWidth(labels, 40)})`);
      }
      return new Text(text, 0, 0);
    },

    renderResult(result, _options, theme) {
      const details = result.details as QuestionnaireResult | undefined;
      if (!details) {
        const text = result.content[0];
        return new Text(text?.type === "text" ? text.text : "", 0, 0);
      }
      if (details.cancelled) {
        return new Text(theme.fg("warning", "Cancelled"), 0, 0);
      }
      const lines = details.answers.map((a) => {
        const rendered = a.selections
          .map((s) => {
            if (s.wasCustom) {
              return `${theme.fg("muted", "(wrote) ")}${s.label}`;
            }
            return s.index ? `${s.index}. ${s.label}` : s.label;
          })
          .join(theme.fg("muted", ", "));
        return `${theme.fg("success", "✓ ")}${theme.fg("accent", a.id)}: ${rendered}`;
      });
      return new Text(lines.join("\n"), 0, 0);
    },
  });
}
