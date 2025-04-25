import { createTool, Tool } from "@mastra/core";
import { z } from "zod";

const inputSchema = z.object({
  query: z.string().describe("検索クエリ"),
});

const outputSchema = z.object({
  sites: z.array(z.object({
    title: z.string().describe("サイトのタイトル"),
    url: z.string().describe("サイトのURL"),
    snippet: z.string().describe("サイトの概要"),
  })),
});

async function searchGoogle(query: string) {
  const apiKey = process.env.GOOGLE_CUSTOM_SEARCH_API_KEY;
  const engineId = process.env.GOOGLE_CUSTOM_SEARCH_ENGINE_ID;
  const response = await fetch(`https://www.googleapis.com/customsearch/v1?key=${apiKey}&cx=${engineId}&q=${encodeURIComponent(query)}`);
  const data: {
    items: {
      title: string;
      formattedUrl: string;
      snippet: string;
    }[];
  } = await response.json();

  console.log(data);

  return data.items.map((item) => ({
    title: item.title,
    url: item.formattedUrl,
    snippet: item.snippet,
  }));
}

export const googleSearchTool: Tool<typeof inputSchema, typeof outputSchema> =
  createTool({
    id: "google-search",
    description: "Googleで検索するツール",
    inputSchema,
    outputSchema,
    execute: async ({ context }) => {
      const result = await searchGoogle(context.query);
      return { sites: result };
    },
  });
