# mokonyan

Mastra を使用した AI エージェントと Slack 連携のプロジェクトです。Slack 上で AI アシスタントとして動作し、ユーザーの質問に応答します。

## 技術スタック

- [Mastra](https://mastra.ai/) - AI エージェントフレームワーク
- [Slack Bolt](https://slack.dev/bolt-js/tutorial/getting-started) - Slack アプリケーションフレームワーク
- TypeScript - 型安全な開発環境
- [libsql](https://libsql.org/) - データベース（ローカル開発時はファイルベース、本番環境では TURSO を使用）
- [TURSO](https://turso.tech/) - 本番環境用データベース（libsql のクラウド版）
- [Google Custom Search API](https://developers.google.com/custom-search/v1/overview) - ウェブ検索機能

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

# Google Custom Search 設定
GOOGLE_CUSTOM_SEARCH_API_KEY=...
GOOGLE_CUSTOM_SEARCH_ENGINE_ID=...
```

Google Custom Search API を使用するには、以下の手順が必要です：

1. [Google Cloud Console](https://console.cloud.google.com/) でプロジェクトを作成
2. Custom Search API を有効化
3. API キーを作成
4. [Programmable Search Engine](https://programmablesearchengine.google.com/) で検索エンジンを作成し、エンジン ID を取得

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

## Docker コマンド（デバッグ用）

Dockerを使用したデバッグ環境の構築と実行方法については、[docker-commands.md](./docker-commands.md)を参照してください。

このプロジェクトでは以下のDockerコマンドを使用して、コンテナ環境のデバッグや調査を行います：

1. **イメージのビルド**: デバッグ用のDockerイメージを作成します
2. **コンテナの実行**: ビルドしたイメージからデバッグ用コンテナを起動します
3. **コンテナへの接続**: 実行中のコンテナにシェルで接続して内部を調査します

各コマンドの詳細な説明と使用方法は、[docker-commands.md](./docker-commands.md)に記載されています。

## ライセンス

ISC
