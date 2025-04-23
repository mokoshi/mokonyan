# mokonyan-agent

Mastra を使用した AI エージェントプロジェクトです。

## 概要

このプロジェクトは Mastra フレームワークを使用して構築された AI エージェントです。OpenAI の API を活用し、自然な会話とタスク実行が可能なエージェントを実装しています。

## 必要条件

- Node.js (v20 以上)
- pnpm
- OpenAI API キー

## セットアップ

1. リポジトリをクローンし、プロジェクトディレクトリに移動します：

```bash
git clone [repository-url]
cd mokonyan-agent
```

2. 依存関係をインストールします：

```bash
pnpm install
```

3. 環境変数を設定します：
   `.env.development` ファイルに以下の環境変数を設定してください：

```
OPENAI_API_KEY=your-api-key
```

## 開発サーバーの起動

開発サーバーを起動するには、以下のコマンドを実行します：

```bash
pnpm dev
```

## ビルド

プロジェクトをビルドするには、以下のコマンドを実行します：

```bash
pnpm build
```

## 使用している主なパッケージ

- @mastra/core
- @mastra/mcp
- @mastra/memory
- @ai-sdk/openai
- zod

## ライセンス

ISC
