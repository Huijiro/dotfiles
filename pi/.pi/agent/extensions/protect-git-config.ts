/**
 * Protect Git Config Extension
 *
 * Prevents the LLM from modifying any git configuration of a project.
 * Blocks:
 *   - write/edit to git config files (.gitconfig, .gitmodules, .gitattributes, .git/config, .git/hooks/*, etc.)
 *   - bash commands that run `git config` (set/unset/replace/add/rename/remove)
 *   - bash commands that modify git hooks, remotes, or submodules
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

  // Patterns for bash commands that modify git config
  const gitConfigCommandPatterns = [
    /\bgit\s+config\b(?!.*--(?:get|list|get-all|get-regexp))/,
    /\bgit\s+remote\s+(?:add|remove|rename|set-url|set-head|prune)\b/,
    /\bgit\s+submodule\s+(?:add|deinit|set-url|set-branch|sync)\b/,
    /\bgit\s+hook\b/,
  ];

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
        return { block: true, reason: `Modifying git config file "${path}" is not allowed` };
      }
    }

    // Block bash commands that modify git config
    if (isToolCallEventType("bash", event)) {
      const command: string = event.input.command;
      const matched = gitConfigCommandPatterns.find((p) => p.test(command));

      if (matched) {
        if (ctx.hasUI) {
          ctx.ui.notify(`Blocked git config command: ${command}`, "warning");
        }
        return { block: true, reason: `Modifying git configuration via bash is not allowed` };
      }
    }

    return undefined;
  });
}
