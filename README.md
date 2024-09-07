# Cloud Run で Next.js をデプロイするためのテンプレート

## 事前に必要なもの
- GCPのODICの設定
- プロジェクトに対して課金アカウントを設定する `gcloud beta billing projects describe <project_id>` で有効化どうか確認できます。

## ローカルで動作確認
```
docker build -t nextjs-cloudrun .
docker run -p 3000:3000 nextjs-cloudrun
```
`http://localhost:3000` にアクセスする。