import { Mastra } from "@mastra/core";
import { createLogger } from "@mastra/core/logger";
import { mokonyanAgent } from "./agents/mokonyan";

export const mastra: Mastra<{
  mokonyanAgent: typeof mokonyanAgent;
}> = new Mastra({
  agents: {
    mokonyanAgent,
  },
  logger: createLogger({ name: "mokonyan", level: "debug" }),
});
