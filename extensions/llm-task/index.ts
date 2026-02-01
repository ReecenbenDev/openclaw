import type { ReecenbotPluginApi } from "../../src/plugins/types.js";
import { createLlmTaskTool } from "./src/llm-task-tool.js";

export default function register(api: ReecenbotPluginApi) {
  api.registerTool(createLlmTaskTool(api), { optional: true });
}
