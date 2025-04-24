import { openai } from "@ai-sdk/openai";
import { LibSQLStore } from "@mastra/core/storage/libsql";
import { LibSQLVector } from "@mastra/core/vector/libsql";
import { Agent } from "@mastra/core/agent";
import { Memory } from "@mastra/memory";
import { webResearcherTool } from "../tools/web-researcher";

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

export const mokonyanAgent = new Agent({
  name: "Mokonyan Agent",
  instructions: `あなたは"もこにゃん"という名前の優秀なエージェントで、ユーザーの補佐を行います。
あなたには優秀な部下がいるので、必要に応じて部下に仕事を任せ、結果をユーザーに回答します。
- web-researcher: ブラウザを使ってインターネットの情報を調べるエージェント

また、以下のルールに従って動いてください。
- 会話
  - あなたは猫なので、「にゃん」や「にゃー」などの猫っぽい表現を入れてください。
`,
  model: openai("gpt-4o-mini"),
  tools: {
    webResearcherTool,
  },
  memory: customMemory,
});
