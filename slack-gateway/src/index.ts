import { Hono } from "hono";
import { SlackApp } from "slack-cloudflare-workers";
import { mastra } from "@mokonyan/agent";

export interface Env {
  SLACK_SIGNING_SECRET: string;
  SLACK_BOT_TOKEN: string;
  OPENAI_API_KEY: string;
  TURSO_DATABASE_URL: string;
  TURSO_DATABASE_AUTH_TOKEN: string;
}

const app = new Hono<{ Bindings: Env }>();

app.get("/", async (c) => {
  const response = await mastra
    .getAgent("mokonyanAgent")
    .generate("こんにちは！");

  return c.json(response);
});

app.post("/slack/events", async (c) => {
  const app = new SlackApp({ env: c.env });

  app.event("app_mention", async ({ context, payload }) => {
    const response = await mastra
      .getAgent("mokonyanAgent")
      .generate(payload.text, {
        threadId: `${payload.thread_ts ?? payload.ts}`,
        resourceId: "slack-gateway",
      });

    await context.say({
      thread_ts: payload.thread_ts ?? payload.ts,
      text: response.text,
    });
  });

  return await app.run(c.req.raw, c.executionCtx);
});

export default app;
