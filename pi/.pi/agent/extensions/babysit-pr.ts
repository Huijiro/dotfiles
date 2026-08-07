/**
 * CI/PR babysitter for pi-babysit.
 *
 * Usage:
 *   /babysit-pr              Monitor the current branch's PR.
 *   /babysit-pr fix          Monitor CI and fix failures, when safe.
 *   /babysit-pr status       Inspect the current PR without starting a watcher.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const STATUS_PROMPT = `Act as a GitHub PR CI monitor.

Use the pi-babysit tools, not the direct bash tool:
1. Run 'gh pr view --json number,url,title,headRefName,baseRefName,state,isDraft,statusCheckRollup' with babysit_run foreground.
2. Report the PR identity and the current check states.
3. Do not modify files, commit, push, rerun, or cancel workflows.
4. If checks are still running, wait with babysit_run foreground using 'gh pr checks --watch'.
5. When complete, summarize every failed, cancelled, or skipped check and include targeted log paths or output. Do not dump entire logs.
`;

const MONITOR_PROMPT = `Act as a GitHub PR CI babysitter for the current branch.

Use pi-babysit's babysit_run, babysit_wait, babysit_check, and babysit_send tools. Do not use the direct bash tool.

Workflow:
1. Identify the current PR with 'gh pr view --json number,url,title,headRefName,baseRefName,state,isDraft,statusCheckRollup'.
2. If there is no PR, stop and report that clearly.
3. Start 'gh pr checks --watch' as a background babysit process with a descriptive name, then collect it with babysit_wait. Do not repeatedly poll with unbounded log output.
4. When the checks finish, inspect only failed/cancelled checks. Use 'gh run list --branch <head branch> --limit 10 --json databaseId,status,conclusion,name,url' and targeted 'gh run view <run-id> --log-failed' calls through babysit tools.
5. Summarize the failure with the check name, likely cause, and the smallest useful log excerpt.
6. Never force-push, rewrite history, or modify repository files unless explicitly authorized by the user.
7. If a failure is clearly caused by code and the user authorized fixing, make the smallest fix, run the relevant local check, commit with a focused message, and push normally.
8. After a push, repeat from step 3 until CI is green, the PR is merged/closed, or human intervention is required.
9. Stop on permission errors, flaky/infra failures after one retry, destructive remediation, or ambiguous failures and ask the user.

Keep updates concise. Always include the PR URL, final check state, and any commit pushed.
`;

export default function (pi: ExtensionAPI) {
  pi.registerCommand("babysit-pr", {
    description: "Monitor the current GitHub PR's CI, optionally fixing safe failures",
    handler: async (args, ctx) => {
      const mode = args.trim().toLowerCase();
      if (mode === "help") {
        ctx.ui.notify("Usage: /babysit-pr [status|fix]", "info");
        return;
      }

      const prompt = mode === "status" ? STATUS_PROMPT : MONITOR_PROMPT +
        (mode === "fix"
          ? "\nThe user explicitly authorized safe code fixes for this babysitting run.\n"
          : "\nMonitoring only: if a fix is needed, stop and ask for authorization.\n");

      pi.sendUserMessage(prompt, { deliverAs: "followUp" });
      ctx.ui.notify(
        mode === "status"
          ? "PR CI status check queued"
          : mode === "fix"
            ? "PR CI babysitter queued with fix authorization"
            : "PR CI babysitter queued in monitor-only mode",
        "info",
      );
    },
  });
}
