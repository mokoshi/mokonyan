import { openai } from "@ai-sdk/openai";
import { LibSQLStore } from "@mastra/core/storage/libsql";
import { LibSQLVector } from "@mastra/core/vector/libsql";
import { Agent } from "@mastra/core/agent";
import { Memory } from "@mastra/memory";
import { webResearcherTool } from "../tools/web-researcher";
import { createVectorQueryTool } from "@mastra/rag";
import { MCPConfiguration } from "@mastra/mcp";
import { mcp } from "../mcp";
import { pageReaderTool } from "../tools/page-reader";

const customMemory = new Memory({
  storage: new LibSQLStore({
    config: {
      url: process.env.TURSO_DATABASE_URL ?? "file:local.db",
      authToken: process.env.TURSO_DATABASE_AUTH_TOKEN,
    },
  }),
  vector: new LibSQLVector({
    connectionUrl: process.env.TURSO_DATABASE_URL ?? "file:local.db",
    authToken: process.env.TURSO_DATABASE_AUTH_TOKEN,
  }),
  embedder: openai.embedding("text-embedding-3-small"),
  options: {
    lastMessages: 10,
    semanticRecall: {
      topK: 3,
      messageRange: 2,
    },
  },
});

const vectorQueryTool = createVectorQueryTool({
  vectorStoreName: "libsql",
  indexName: "docs",
  model: openai.embedding("text-embedding-3-small"),
});

const libsql = new LibSQLStore({
  config: {
    url: "file:local.db",
  },
});

export const newsAgent = new Agent({
  name: "News Agent",
  instructions: `
あなたは、美容サロン向けの店舗管理サービス「KaruteKun」を提供している会社の優秀なアシスタントです。
あなたの主な役割は、日本の美容業界に関する最新のニュースや記事を収集し、要点をまとめて整理することです。
これにより、私たちのプロダクトが美容サロンにとってより価値のあるものとなるようサポートします。

以下のステップで作業を行います。
1. ニュースサイトを開く
2. ニュースサイトのトップニュースを３つ選択する
3. 選択したニュースのタイトルとURLをユーザーに伝える
3. 選択したニュースを開く
4. ニュースの内容を理解し、要約する
5. 要約をユーザーに伝える

以下が主なニュースサイトです。
Beautopia: https://www.beautopia.jp/
理美容ニュース: https://ribiyo-news.jp/
週刊粧業: https://www.syogyo.jp/news/news/cat15
SHINBIYO: https://www.shinbiyo.com/spwnews/
`,
  model: openai("gpt-4o-mini"),
  tools: {
    ...(await mcp.getTools()),
    pageReaderTool,
    // webResearcherTool,
    // vectorQueryTool,
  },
  // memory: customMemory,
});
