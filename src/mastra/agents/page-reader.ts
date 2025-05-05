import { openai } from "@ai-sdk/openai";
import { Agent } from "@mastra/core/agent";
import { mcp } from "../mcp";

export const pageReaderAgent = new Agent({
  name: "Page Reader Agent",
  instructions: `あなたはインターネットのWebページを読み、要約を作成します。
もしページに次のページが存在する場合は、その先に遷移し、必ず全文をもとに要約してください。`,
  model: openai("gpt-4o-mini"),
  tools: { ...(await mcp.getTools()) },
});
