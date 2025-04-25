import Bolt from "@slack/bolt";
import { mastra } from "../mastra";

const slackApp = new Bolt.App({
  token: process.env.SLACK_BOT_TOKEN,
  signingSecret: process.env.SLACK_SIGNING_SECRET!,
  customRoutes: [
    {
      path: "/health",
      method: "GET",
      handler: (_req, res) => {
        res.writeHead(200);
        res.write("ok");
        res.end();
      },
    },
    {
      path: "/test",
      method: "GET",
      handler: async (_req, res) => {
        res.writeHead(200);
        let responseText: string;
        try {
          const response = await mastra
            .getAgent("mokonyanAgent")
            .generate("nintendo switch 2 の発売日は？");
          responseText = response.text;
        } catch (error) {
          console.error("Failed to generate response:", error);
          responseText = "エラーが発生しちゃったにゃん。。。";
        }
        res.write(responseText);
      }
    }
  ],
});

slackApp.event("app_mention", async ({ event, say }) => {
  let responseText: string;
  try {
    const response = await mastra
      .getAgent("mokonyanAgent")
      .generate(event.text, {
        threadId: `${event.thread_ts ?? event.ts}`,
        resourceId: "slack-gateway",
      });
    responseText = response.text;
  } catch (error) {
    console.error("Failed to generate response:", error);
    responseText = "エラーが発生しちゃったにゃん。。。";
  }

  await say({
    thread_ts: event.thread_ts ?? event.ts,
    text: responseText,
  });
});

try {
  console.log("Starting Slack app...");
  await slackApp.start(process.env.PORT || 3000);
  console.log(`Slack app started on port ${process.env.PORT || 3000}`);
} catch (error) {
  console.error("Failed to start Slack app:", error);
  process.exit(1);
}
