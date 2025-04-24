import { createTool, Tool } from "@mastra/core";
import { z } from "zod";
import { webResearcherAgent } from "../agents/web-researcher";

const inputSchema = z.object({
  question: z.string().describe("調査したい内容"),
});

const outputSchema = z.object({
  answer: z.string().describe("回答内容"),
});

export const webResearcherTool: Tool<typeof inputSchema, typeof outputSchema> =
  createTool({
    id: "web-researcher",
    description: "ブラウザを使ってインターネットの情報を調べるエージェント",
    inputSchema,
    outputSchema,
    execute: async ({ context }) => {
      const result = await webResearcherAgent.generate(context.question);
      return { answer: result.text };
    },
  });
