# slack-gateway

mokonyan-agent と Slack を連携するためのゲートウェイです。Cloudflare Workers 上で動作し、Slack のイベントを処理して mokonyan-agent と通信します。

## アーキテクチャ

このプロジェクトは以下のような構成になっています：

```
[Slack] <-> [slack-gateway (Cloudflare Workers)] <-> [mokonyan-agent]
```

重要なポイント：

- slack-gateway と mokonyan-agent は同じプロセス内で動作します
- mokonyan-agent は slack-gateway の依存関係として組み込まれています
- 両者は直接通信するのではなく、同じプロセス内でメモリを共有します
- OpenAI API は mokonyan-agent が使用するため、slack-gateway でも API キーの設定が必要です

## 概要

このプロジェクトは、Slack のメッセージやイベントを mokonyan-agent に中継し、エージェントの応答を Slack に返すためのゲートウェイとして機能します。Cloudflare Workers を使用して構築されており、スケーラブルで高速なレスポンスを実現しています。

## 必要条件

- Node.js (v20 以上)
- pnpm
- Cloudflare アカウント
- Slack アプリの設定（以下が必要）
  - Bot User OAuth Token
  - Signing Secret
  - イベントサブスクリプションの設定

## セットアップ

1. リポジトリをクローンし、プロジェクトディレクトリに移動します：

```bash
git clone [repository-url]
cd slack-gateway
```

2. 依存関係をインストールします：

```bash
pnpm install
```

3. 環境変数を設定します：
   `.dev.vars` ファイルに以下の環境変数を設定してください：

```
# ローカル開発用の必須設定
OPENAI_API_KEY=your-openai-api-key
SLACK_BOT_TOKEN=your-bot-token
SLACK_SIGNING_SECRET=your-signing-secret

# 本番環境用の追加設定（ローカル開発時は不要）
TURSO_DATABASE_URL=your-turso-database-url
TURSO_DATABASE_AUTH_TOKEN=your-turso-auth-token
```

ローカル開発時は、データベースとしてローカルのファイルを使用します。本番環境にデプロイする場合は、Turso データベースの設定が必要です。

## 開発サーバーの起動

開発サーバーを起動するには、以下のコマンドを実行します：

```bash
pnpm dev
```

## デプロイ

Cloudflare Workers にデプロイするには、以下のコマンドを実行します：

```bash
pnpm deploy
```

## 使用している主なパッケージ

- @mokonyan/agent
- hono
- slack-cloudflare-workers
- wrangler

## ライセンス

ISC
