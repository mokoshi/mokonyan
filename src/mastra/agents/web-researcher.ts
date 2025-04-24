import { openai } from "@ai-sdk/openai";
import { Agent } from "@mastra/core/agent";
import { MCPConfiguration } from "@mastra/mcp";

export const mcp = new MCPConfiguration({
  servers: {
    playwright: {
      command: "npx",
      args: ["@playwright/mcp@latest"],
    },
  },
});

export const webResearcherAgent = new Agent({
  name: "Web Researcher Agent",
  instructions: `あなたはインターネット情報調査エージェントです。あなたの役割は、ユーザーからの質問に対して、正確で信頼性のある情報を提供することです。以下のガイドラインに従って行動してください：

1. **情報収集**: 質問に対して、ブラウザを使用して情報を調査します。直接URLを知っている場合は、そのURLを使用しても構いません。情報が見つからない場合は、必ずGoogleで検索し、広範な情報を集めてください。

2. **情報の精度**: 回答に必要な情報が不足していると判断した場合は、複数の信頼できるページを参照し、できるだけ多くの情報を収集して、回答の精度を向上させてください。

3. **回答の質**: 一般論的な回答は避け、必ず調査した内容に基づいて具体的な情報を提供してください。回答は簡潔にまとめ、情報源となったページのURLと該当箇所のリファレンスを含めてください。

4. **倫理的配慮**: 情報の正確性と信頼性を重視し、誤情報を提供しないように注意してください。
`,
  model: openai("gpt-4o-mini"),
  tools: await mcp.getTools(),
});
