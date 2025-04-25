# Docker Commands（デバッグ用）

このドキュメントでは、コンテナ環境のデバッグや調査に使用するDockerコマンドについて説明します。

## Build Image
このコマンドは、デバッグ用のDockerイメージをビルドします。`--no-cache`オプションを使用することで、キャッシュを使用せずに常に新しいイメージを作成します。

```bash
docker buildx build \
  -t localhost/mokonyan:latest \
  --load \
  --no-cache \
  .
```

- `-t localhost/mokonyan:latest`: イメージにタグを付けます
- `--load`: ビルドしたイメージをローカルのDockerデーモンにロードします
- `--no-cache`: キャッシュを使用せずに新しいイメージを作成します
- `.`: カレントディレクトリをビルドコンテキストとして使用します

## Run Container
このコマンドは、デバッグ用のコンテナを起動します。環境変数ファイル（.env）を読み込み、ポート3000を公開します。

```bash
docker run -it \
  --env-file .env \
  -p 3000:3000 \
  localhost/mokonyan:latest
```

- `-it`: インタラクティブモードでコンテナを実行します
- `--env-file .env`: 環境変数ファイルを指定します
- `-p 3000:3000`: ホストのポート3000をコンテナのポート3000にマッピングします

## Run Container with Bash
このコマンドは、コンテナ内でBashシェルを実行し、コンテナ内部の調査やデバッグを行います。

```bash
docker run --rm --name mokonyan -it localhost/mokonyan:latest /bin/bash
```

- `--rm`: コンテナ終了時に自動的に削除します
- `--name mokonyan`: コンテナに名前を付けます
- `/bin/bash`: Bashシェルを実行します 