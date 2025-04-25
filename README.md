# mokonyan

Mastra を使用した AI エージェントと Slack 連携のプロジェクトです。Slack 上で AI アシスタントとして動作し、ユーザーの質問に応答します。

## 技術スタック

- [Mastra](https://mastra.ai/) - AI エージェントフレームワーク
- [Slack Bolt](https://slack.dev/bolt-js/tutorial/getting-started) - Slack アプリケーションフレームワーク
- TypeScript - 型安全な開発環境
- [libsql](https://libsql.org/) - データベース（ローカル開発時はファイルベース、本番環境では TURSO を使用）
- [TURSO](https://turso.tech/) - 本番環境用データベース（libsql のクラウド版）

## プロジェクト構成

```
.
├── src/              # ソースコード
├── scripts/          # ビルドスクリプト
├── infra/           # インフラストラクチャ設定
├── dist/            # ビルド成果物
└── package.json     # プロジェクト設定
```

## セットアップ

1. 依存関係のインストール:

```bash
pnpm install
```

2. 環境変数の設定:

`.env` ファイルを作成し、以下の環境変数を設定します：

```env
# Slack 設定
SLACK_BOT_TOKEN=xoxb-...
SLACK_SIGNING_SECRET=...

# OpenAI 設定
OPENAI_API_KEY=sk-...

# データベース設定（本番環境でのみ必要）
TURSO_DATABASE_URL=https://your-database.turso.io
TURSO_DATABASE_AUTH_TOKEN=...
```

## 開発

開発サーバーを起動:

```bash
pnpm dev
```

ローカル開発時は、`file:local.db` にデータが保存されます。

## ビルド

プロジェクトをビルド:

```bash
pnpm build
```

## デプロイ

Cloudflare Workers へのデプロイ:

```bash
pnpm deploy
```

本番環境では、TURSO データベースに接続されます。

## ライセンス

ISC
