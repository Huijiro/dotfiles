/**
 * Conversation Mode Extension
 *
 * Read-only exploration mode for safe code analysis.
 * When enabled, only read-only tools are available.
 *
 * Features:
 * - /conversation command or Tab to toggle
 * - Bash restricted to allowlisted read-only commands
 * - Extracts numbered plan steps from "Plan:" sections
 * - [DONE:n] markers to complete steps during execution
 * - Progress tracking via the todo extension's event bus
 * - Use /todos to view plan progress
 */

import type { AgentMessage } from "@mariozechner/pi-agent-core";
import type { AssistantMessage, TextContent } from "@mariozechner/pi-ai";
import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";
import { Key } from "@mariozechner/pi-tui";
import { extractTodoItems, isSafeCommand, type TodoItem } from "./utils.js";

// Tools
const CONVERSATION_MODE_TOOLS = ["read", "bash", "grep", "find", "ls", "questionnaire"];
const NORMAL_MODE_TOOLS = ["read", "bash", "edit", "write"];

// Todo item shape from the todo extension
interface Todo {
	id: number;
	text: string;
	done: boolean;
}

// Type guard for assistant messages
function isAssistantMessage(m: AgentMessage): m is AssistantMessage {
	return m.role === "assistant" && Array.isArray(m.content);
}

// Extract text content from an assistant message
function getTextContent(message: AssistantMessage): string {
	return message.content
		.filter((block): block is TextContent => block.type === "text")
		.map((block) => block.text)
		.join("\n");
}

/** Query todos from the todo extension via event bus */
function getTodos(pi: ExtensionAPI): { todos: Todo[]; nextId: number } {
	let result = { todos: [] as Todo[], nextId: 1 };
	pi.events.emit("todo:get", {
		callback: (state: { todos: Todo[]; nextId: number }) => {
			result = state;
		},
	});
	return result;
}

/** Extract [DONE:n] step numbers from message text */
function extractDoneSteps(message: string): number[] {
	const steps: number[] = [];
	for (const match of message.matchAll(/\[DONE:(\d+)\]/gi)) {
		const step = Number(match[1]);
		if (Number.isFinite(step)) steps.push(step);
	}
	return steps;
}

export default function conversationModeExtension(pi: ExtensionAPI): void {
	let conversationModeEnabled = false;
	let executionMode = false;

	// Map from plan step number → todo id in the todo extension
	let stepToTodoId: Map<number, number> = new Map();

	pi.registerFlag("conversation", {
		description: "Start in conversation mode (read-only exploration)",
		type: "boolean",
		default: false,
	});

	function updateStatus(ctx: ExtensionContext): void {
		const { todos } = getTodos(pi);

		// Footer status
		if (executionMode && todos.length > 0) {
			const completed = todos.filter((t) => t.done).length;
			ctx.ui.setStatus("conversation-mode", ctx.ui.theme.fg("accent", `📋 ${completed}/${todos.length}`));
		} else if (conversationModeEnabled) {
			ctx.ui.setStatus("conversation-mode", ctx.ui.theme.fg("warning", "⏸ conversation"));
		} else {
			ctx.ui.setStatus("conversation-mode", undefined);
		}

		// Widget showing todo list
		if (executionMode && todos.length > 0) {
			const lines = todos.map((item) => {
				if (item.done) {
					return (
						ctx.ui.theme.fg("success", "☑ ") + ctx.ui.theme.fg("muted", ctx.ui.theme.strikethrough(item.text))
					);
				}
				return `${ctx.ui.theme.fg("muted", "☐ ")}${item.text}`;
			});
			ctx.ui.setWidget("conversation-todos", lines);
		} else {
			ctx.ui.setWidget("conversation-todos", undefined);
		}
	}

	function toggleConversationMode(ctx: ExtensionContext): void {
		conversationModeEnabled = !conversationModeEnabled;
		executionMode = false;
		stepToTodoId = new Map();

		if (conversationModeEnabled) {
			pi.setActiveTools(CONVERSATION_MODE_TOOLS);
			ctx.ui.notify(`Conversation mode enabled. Tools: ${CONVERSATION_MODE_TOOLS.join(", ")}`);
		} else {
			pi.setActiveTools(NORMAL_MODE_TOOLS);
			ctx.ui.notify("Conversation mode disabled. Full access restored.");
		}
		updateStatus(ctx);
	}

	function persistState(): void {
		pi.appendEntry("conversation-mode", {
			enabled: conversationModeEnabled,
			executing: executionMode,
			stepToTodoId: Array.from(stepToTodoId.entries()),
		});
	}

	/** Import extracted plan steps into the todo extension */
	function importPlanSteps(items: TodoItem[]): void {
		// Clear existing todos and import new plan steps
		pi.events.emit("todo:clear");

		pi.events.emit("todo:import", {
			items: items.map((item) => ({ text: item.text })),
			clear: false,
		});

		// Build step→id mapping (todos are assigned sequential ids starting from 1 after clear)
		stepToTodoId = new Map();
		const { todos } = getTodos(pi);
		for (let i = 0; i < items.length && i < todos.length; i++) {
			stepToTodoId.set(items[i].step, todos[i].id);
		}
	}

	/** Mark plan steps as completed via the todo extension */
	function completeSteps(stepNumbers: number[]): number {
		let completed = 0;
		for (const step of stepNumbers) {
			const todoId = stepToTodoId.get(step);
			if (todoId !== undefined) {
				pi.events.emit("todo:complete", { id: todoId });
				completed++;
			}
		}
		return completed;
	}

	// Listen for todo changes to update our widget
	pi.events.on("todo:changed", () => {
		// We can't easily get ctx here, but the next updateStatus call will refresh
		// The widget updates are driven by turn_end/agent_end which call updateStatus
	});

	pi.registerCommand("conversation", {
		description: "Toggle conversation mode (read-only exploration)",
		handler: async (_args, ctx) => toggleConversationMode(ctx),
	});

	pi.registerShortcut(Key.tab, {
		description: "Toggle conversation mode",
		handler: async (ctx) => toggleConversationMode(ctx),
	});

	// Block destructive bash commands in conversation mode
	pi.on("tool_call", async (event) => {
		if (!conversationModeEnabled || event.toolName !== "bash") return;

		const command = event.input.command as string;
		if (!isSafeCommand(command)) {
			return {
				block: true,
				reason: `Conversation mode: command blocked (not allowlisted). Use /conversation to disable conversation mode first.\nCommand: ${command}`,
			};
		}
	});

	// Filter out stale conversation mode context when not in conversation mode
	pi.on("context", async (event) => {
		if (conversationModeEnabled) return;

		return {
			messages: event.messages.filter((m) => {
				const msg = m as AgentMessage & { customType?: string };
				if (msg.customType === "conversation-mode-context") return false;
				if (msg.role !== "user") return true;

				const content = msg.content;
				if (typeof content === "string") {
					return !content.includes("[CONVERSATION MODE ACTIVE]");
				}
				if (Array.isArray(content)) {
					return !content.some(
						(c) => c.type === "text" && (c as TextContent).text?.includes("[CONVERSATION MODE ACTIVE]"),
					);
				}
				return true;
			}),
		};
	});

	// Inject conversation/execution context before agent starts
	pi.on("before_agent_start", async () => {
		if (conversationModeEnabled) {
			return {
				message: {
					customType: "conversation-mode-context",
					content: `[CONVERSATION MODE ACTIVE]
You are in conversation mode - a read-only exploration mode for safe code analysis.

Restrictions:
- You can only use: read, bash, grep, find, ls, questionnaire
- You CANNOT use: edit, write (file modifications are disabled)
- Bash is restricted to an allowlist of read-only commands

Ask clarifying questions using the questionnaire tool.

Create a detailed numbered plan under a "Plan:" header:

Plan:
1. First step description
2. Second step description
...

Do NOT attempt to make changes - just describe what you would do.`,
					display: false,
				},
			};
		}

		if (executionMode) {
			const { todos } = getTodos(pi);
			const remaining = todos.filter((t) => !t.done);
			if (remaining.length > 0) {
				// Find the step number for each remaining todo
				const todoList = remaining
					.map((t) => {
						// Reverse lookup step number from todo id
						for (const [step, id] of stepToTodoId) {
							if (id === t.id) return `${step}. ${t.text}`;
						}
						return `- ${t.text}`;
					})
					.join("\n");

				return {
					message: {
						customType: "conversation-execution-context",
						content: `[EXECUTING PLAN - Full tool access enabled]

Remaining steps:
${todoList}

Execute each step in order.
After completing a step, include a [DONE:n] tag in your response.`,
						display: false,
					},
				};
			}
		}
	});

	// Track progress after each turn
	pi.on("turn_end", async (event, ctx) => {
		if (!executionMode) return;

		const { todos } = getTodos(pi);
		if (todos.length === 0) return;

		if (!isAssistantMessage(event.message)) return;

		const text = getTextContent(event.message);
		const doneSteps = extractDoneSteps(text);
		if (doneSteps.length > 0) {
			completeSteps(doneSteps);
			updateStatus(ctx);
		}
		persistState();
	});

	// Handle plan completion and conversation mode UI
	pi.on("agent_end", async (event, ctx) => {
		// Check if execution is complete
		if (executionMode) {
			const { todos } = getTodos(pi);
			if (todos.length > 0 && todos.every((t) => t.done)) {
				const completedList = todos.map((t) => `~~${t.text}~~`).join("\n");
				pi.sendMessage(
					{ customType: "conversation-complete", content: `**Plan Complete!** ✓\n\n${completedList}`, display: true },
					{ triggerTurn: false },
				);
				executionMode = false;
				stepToTodoId = new Map();
				pi.setActiveTools(NORMAL_MODE_TOOLS);
				updateStatus(ctx);
				persistState();
			}
			return;
		}

		if (!conversationModeEnabled || !ctx.hasUI) return;

		// Extract todos from last assistant message
		const lastAssistant = [...event.messages].reverse().find(isAssistantMessage);
		let extractedItems: TodoItem[] = [];
		if (lastAssistant) {
			extractedItems = extractTodoItems(getTextContent(lastAssistant));
			if (extractedItems.length > 0) {
				importPlanSteps(extractedItems);
			}
		}

		const hasPlan = extractedItems.length > 0;

		// Show plan steps and prompt for next action
		if (hasPlan) {
			const { todos } = getTodos(pi);
			const todoListText = todos.map((t, i) => `${i + 1}. ☐ ${t.text}`).join("\n");
			pi.sendMessage(
				{
					customType: "conversation-todo-list",
					content: `**Plan Steps (${todos.length}):**\n\n${todoListText}`,
					display: true,
				},
				{ triggerTurn: false },
			);
		}

		const choice = await ctx.ui.select("Conversation mode - what next?", [
			hasPlan ? "Execute the plan (track progress)" : "Execute the plan",
			"Stay in conversation mode",
			"Refine the plan",
		]);

		if (choice?.startsWith("Execute")) {
			conversationModeEnabled = false;
			executionMode = hasPlan;
			pi.setActiveTools(NORMAL_MODE_TOOLS);
			updateStatus(ctx);

			const { todos } = getTodos(pi);
			const firstTodo = todos.find((t) => !t.done);
			const execMessage = firstTodo
				? `Execute the plan. Start with: ${firstTodo.text}`
				: "Execute the plan you just created.";
			pi.sendMessage(
				{ customType: "conversation-mode-execute", content: execMessage, display: true },
				{ triggerTurn: true },
			);
		} else if (choice === "Refine the plan") {
			const refinement = await ctx.ui.editor("Refine the plan:", "");
			if (refinement?.trim()) {
				pi.sendUserMessage(refinement.trim());
			}
		}
	});

	// Restore state on session start/resume
	pi.on("session_start", async (_event, ctx) => {
		if (pi.getFlag("conversation") === true) {
			conversationModeEnabled = true;
		}

		const entries = ctx.sessionManager.getEntries();

		// Restore persisted state
		const conversationModeEntry = entries
			.filter((e: { type: string; customType?: string }) => e.type === "custom" && e.customType === "conversation-mode")
			.pop() as { data?: { enabled: boolean; executing?: boolean; stepToTodoId?: [number, number][] } } | undefined;

		if (conversationModeEntry?.data) {
			conversationModeEnabled = conversationModeEntry.data.enabled ?? conversationModeEnabled;
			executionMode = conversationModeEntry.data.executing ?? executionMode;
			if (conversationModeEntry.data.stepToTodoId) {
				stepToTodoId = new Map(conversationModeEntry.data.stepToTodoId);
			}
		}

		if (conversationModeEnabled) {
			pi.setActiveTools(CONVERSATION_MODE_TOOLS);
		}
		updateStatus(ctx);
	});
}
