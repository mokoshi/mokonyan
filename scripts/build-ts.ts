import esbuild from "esbuild";

await esbuild.build({
  entryPoints: ["./src/mastra/index.ts", "./src/slack-gateway/index.ts"],
  outdir: "./dist",
  outExtension: {
    ".js": ".mjs",
  },
  bundle: true,
  platform: "node",
  format: "esm",
  external: ["@mastra/core", "@mastra/mcp", "@mastra/memory", "mastra"],
  banner: {
    js: 'import { createRequire as topLevelCreateRequire } from "module"; import url from "url"; const require = topLevelCreateRequire(import.meta.url); const __filename = url.fileURLToPath(import.meta.url); const __dirname = url.fileURLToPath(new URL(".", import.meta.url));',
  },
});
