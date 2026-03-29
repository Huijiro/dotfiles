/**
 * Fireworks.ai Custom Provider Extension
 *
 * Registers the GLM-5 model from Fireworks.ai using the OpenAI-compatible API.
 *
 * Setup:
 *   1. Get your API key from https://fireworks.ai/account/api-keys
 *   2. Set the environment variable:
 *        export FIREWORKS_API_KEY=fw_...
 *   3. Reload extensions with /reload or restart pi
 *
 * Usage:
 *   Use /model to switch to fireworks/glm-5
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerProvider("fireworks", {
    baseUrl: "https://api.fireworks.ai/inference/v1",
    apiKey: "FIREWORKS_API_KEY",
    api: "openai-completions",

    models: [
      {
        id: "accounts/fireworks/models/glm-5",
        name: "GLM-5",
        reasoning: false,
        input: ["text"],
        cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
        contextWindow: 202000,
        maxTokens: 25344,
        compat: {
          supportsDeveloperRole: false,
          maxTokensField: "max_tokens",
        },
      },
    ],
  });
}
