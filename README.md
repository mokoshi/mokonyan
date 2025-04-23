# mokonyan

Mastra を使用した AI エージェントと Slack 連携のプロジェクトです。

## プロジェクト構成

このプロジェクトは以下の2つの主要コンポーネントで構成されています：

- [mokonyan-agent](./mokonyan-agent/README.md): Mastra を使用した AI エージェントの実装
- [slack-gateway](./slack-gateway/README.md): mokonyan-agent と Slack を連携するためのゲートウェイ

各コンポーネントの詳細な説明、セットアップ手順、開発方法については、それぞれの README を参照してください。

## デプロイ

プロジェクト全体をビルドしてデプロイするには、ルートディレクトリで以下のコマンドを実行します：

```bash
pnpm deploy
```

このコマンドは以下の処理を実行します：

1. mokonyan-agent のビルド
2. slack-gateway の Cloudflare Workers へのデプロイ

## ライセンス

ISC
