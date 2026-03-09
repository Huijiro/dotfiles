/**
 * Protect Git Config Extension
 *
 * Prevents the LLM from modifying any git configuration of a project.
 * Blocks:
 *   - write/edit to git config files (.gitconfig, .gitmodules, .gitattributes, .git/config, .git/hooks/*, etc.)
 *   - bash commands that run `git config` (set/unset/replace/add/rename/remove)
 *   - bash commands that modify git hooks, remotes, or submodules
 *   - inline config overrides via `git -c key=value` that change security-sensitive settings
 *   - git flags that bypass signing or hooks (--no-gpg-sign, --no-verify, etc.)
 *   - environment variables that override git identity or signing (GIT_COMMITTER_*, GIT_AUTHOR_*, etc.)
 *
 * When blocked, the LLM is instructed to provide the user with the exact
 * command/steps to run manually so the user stays in control.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  const gitConfigFiles = [
    ".git/config",
    ".git/hooks/",
    ".git/info/",
    ".gitconfig",
    ".gitmodules",
    ".gitattributes",
    ".gitignore",
  ];

  // Patterns for bash commands that modify git config persistently
  const gitConfigCommandPatterns: { pattern: RegExp; label: string }[] = [
    {
      pattern: /\bgit\s+config\b(?!.*--(?:get|list|get-all|get-regexp))/,
      label: "git config modification",
    },
    {
      pattern: /\bgit\s+remote\s+(?:add|remove|rename|set-url|set-head|prune)\b/,
      label: "git remote modification",
    },
    {
      pattern: /\bgit\s+submodule\s+(?:add|deinit|set-url|set-branch|sync)\b/,
      label: "git submodule modification",
    },
    {
      pattern: /\bgit\s+hook\b/,
      label: "git hook modification",
    },
  ];

  // Inline config overrides: `git -c key=value ...`
  // Matches any `git -c` usage which can override any config setting at runtime
  const inlineConfigPatterns: { pattern: RegExp; label: string }[] = [
    {
      pattern: /\bgit\s+(?:.*\s)?-c\s+\S+=/,
      label: "inline git config override (-c key=value)",
    },
  ];

  // Git flags that bypass security features (signing, hooks, verification)
  const bypassFlagPatterns: { pattern: RegExp; label: string }[] = [
    {
      pattern: /\bgit\s+.*--no-gpg-sign\b/,
      label: "GPG signing bypass (--no-gpg-sign)",
    },
    {
      pattern: /\bgit\s+.*--no-verify\b/,
      label: "hook bypass (--no-verify)",
    },
    {
      pattern: /\bgit\s+.*-n\b(?=.*\b(?:commit|push|merge)\b)/,
      label: "hook bypass (-n shorthand)",
    },
  ];

  // Environment variables that override git identity or signing config
  const gitEnvOverridePatterns: { pattern: RegExp; label: string }[] = [
    {
      pattern: /\bGIT_COMMITTER_(?:NAME|EMAIL|DATE)\s*=/,
      label: "git committer identity override",
    },
    {
      pattern: /\bGIT_AUTHOR_(?:NAME|EMAIL|DATE)\s*=/,
      label: "git author identity override",
    },
    {
      pattern: /\bGIT_CONFIG_NOSYSTEM\s*=/,
      label: "git system config bypass",
    },
    {
      pattern: /\bGIT_CONFIG_GLOBAL\s*=/,
      label: "git global config override",
    },
    {
      pattern: /\bGIT_CONFIG_COUNT\s*=/,
      label: "git config injection via GIT_CONFIG_COUNT",
    },
    {
      pattern: /\bGIT_CONFIG_KEY_\d+\s*=/,
      label: "git config injection via GIT_CONFIG_KEY_*",
    },
    {
      pattern: /\bGIT_CONFIG_VALUE_\d+\s*=/,
      label: "git config injection via GIT_CONFIG_VALUE_*",
    },
  ];

  const allBashPatterns = [
    ...gitConfigCommandPatterns,
    ...inlineConfigPatterns,
    ...bypassFlagPatterns,
    ...gitEnvOverridePatterns,
  ];

  const manualInstructions =
    "Instead of running this command, provide the user with the exact command(s) " +
    "they need to run manually in their terminal. Format the instructions clearly " +
    "so the user can copy-paste and execute them themselves. Do NOT attempt to " +
    "re-run the command, work around the restriction, or use alternative flags/env " +
    "vars to achieve the same effect — all git config modifications are blocked.";

  pi.on("tool_call", async (event, ctx) => {
    // Block write/edit to git config files
    if (isToolCallEventType("write", event) || isToolCallEventType("edit", event)) {
      const path: string = event.input.path;
      const isGitConfig = gitConfigFiles.some(
        (p) => path.includes(p) || path.endsWith("/.gitconfig")
      );

      if (isGitConfig) {
        if (ctx.hasUI) {
          ctx.ui.notify(`Blocked modification to git config file: ${path}`, "warning");
        }
        return {
          block: true,
          reason:
            `Modifying git config file "${path}" is not allowed. ${manualInstructions}`,
        };
      }
    }

    // Block bash commands that modify git config (persistent, inline, bypass flags, or env overrides)
    if (isToolCallEventType("bash", event)) {
      const command: string = event.input.command;
      const matched = allBashPatterns.find((p) => p.pattern.test(command));

      if (matched) {
        if (ctx.hasUI) {
          ctx.ui.notify(`Blocked ${matched.label}: ${command}`, "warning");
        }
        return {
          block: true,
          reason:
            `Blocked: ${matched.label}. ${manualInstructions}`,
        };
      }
    }

    return undefined;
  });
}
