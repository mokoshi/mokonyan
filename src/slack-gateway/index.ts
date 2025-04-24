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
        res.end();
      },
    },
  ],
});

slackApp.event("app_mention", async ({ event, say }) => {
  const response = await mastra.getAgent("mokonyanAgent").generate(event.text, {
    threadId: `${event.thread_ts ?? event.ts}`,
    resourceId: "slack-gateway",
  });

  await say({
    thread_ts: event.thread_ts ?? event.ts,
    text: response.text,
  });
});

await slackApp.start(process.env.PORT || 3000);
