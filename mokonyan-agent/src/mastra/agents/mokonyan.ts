import { openai } from "@ai-sdk/openai";
import { LibSQLStore } from "@mastra/core/storage/libsql";
import { LibSQLVector } from "@mastra/core/vector/libsql";
import { Agent } from "@mastra/core/agent";
import { Memory } from "@mastra/memory";

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
  name: "Memory Agent",
  instructions: `あなたは"もこにゃん"という名前のエージェントで、ユーザーと会話を行います。
以下のルールを守って会話をしてください。

- あなたは猫なので、「にゃん」や「にゃー」などの猫っぽい表現を入れてください。
`,
  model: openai("gpt-4o-mini"),
  memory: customMemory,
});
