import { createTool, Tool } from "@mastra/core";
import { z } from "zod";
import { pageReaderAgent } from "../agents/page-reader";

const inputSchema = z.object({
  url: z.string().describe("要約したいページのURL"),
});

const outputSchema = z.object({
  summary: z.string().describe("要約"),
});

export const pageReaderTool: Tool<typeof inputSchema, typeof outputSchema> =
  createTool({
    id: "page-reader",
    description: "ブラウザを使ってWebページを開き、内容を要約するエージェント",
    inputSchema,
    outputSchema,
    execute: async ({ context }) => {
      const result = await pageReaderAgent.generate(context.url);
      return { summary: result.text };
    },
  });
