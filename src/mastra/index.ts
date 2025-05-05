import { webResearcherAgent } from "./agents/web-researcher";
import { Mastra } from "@mastra/core";
import { createLogger } from "@mastra/core/logger";
import { mokonyanAgent } from "./agents/mokonyan";
import { newsAgent } from "./agents/news";

export const mastra: Mastra<{
  mokonyanAgent: typeof mokonyanAgent;
}> = new Mastra({
  agents: {
    mokonyanAgent,
    webResearcherAgent,
    newsAgent,
  },
  logger: createLogger({ name: "mokonyan", level: "debug" }),
});
