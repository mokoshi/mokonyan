# mokonyan

Mastra を使用した AI エージェントと Slack 連携のプロジェクトです。

## プロジェクト構成

このプロジェクトは以下の2つの主要コンポーネントで構成されています：

### mokonyan-agent

Mastra を使用した AI エージェントの実装です。OpenAI の API を活用し、自然な会話とタスク実行が可能なエージェントを提供します。

詳細は [mokonyan-agent/README.md](./mokonyan-agent/README.md) を参照してください。

### slack-gateway

mokonyan-agent と Slack を連携するためのゲートウェイです。Cloudflare Workers 上で動作し、Slack のイベントを処理して mokonyan-agent と通信します。

詳細は [slack-gateway/README.md](./slack-gateway/README.md) を参照してください。

## 必要条件

- Node.js (v20 以上)
- pnpm
- Cloudflare アカウント
- Slack アプリの設定
- OpenAI API キー

## セットアップ

1. リポジトリをクローンします：

```bash
git clone [repository-url]
cd mokonyan
```

2. 依存関係をインストールします：

```bash
pnpm install
```

3. 各コンポーネントの環境変数を設定します：

- mokonyan-agent: `.env.development` ファイルを設定
- slack-gateway: `.dev.vars` ファイルを設定

## 開発

### ローカルでの実行

各コンポーネントのディレクトリで以下のコマンドを実行します：

```bash
# mokonyan-agent の開発サーバー起動
cd mokonyan-agent
pnpm dev

# slack-gateway の開発サーバー起動
cd slack-gateway
pnpm dev
```

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
