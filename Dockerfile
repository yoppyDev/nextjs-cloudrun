# ベースイメージとしてNode.jsのAlpineバージョンを使用
FROM node:22-alpine AS base

# 依存関係のインストールのみを行うステージ
FROM base AS deps
# 互換性のためにlibc6-compatをインストール
RUN apk add --no-cache libc6-compat
WORKDIR /app

# パッケージマネージャに応じて依存関係をインストール
COPY app/package.json app/yarn.lock* app/package-lock.json* app/pnpm-lock.yaml* ./
RUN \
    if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
    elif [ -f package-lock.json ]; then npm ci; \
    elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm i --frozen-lockfile; \
    else echo "Lockfile not found." && exit 1; \
    fi

# ソースコードを再ビルドするステージ
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY app/ .

# Next.jsのビルドプロセスを実行
RUN \
    if [ -f yarn.lock ]; then yarn run build; \
    elif [ -f package-lock.json ]; then npm run build; \
    elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm run build; \
    else echo "Lockfile not found." && exit 1; \
    fi

# プロダクション環境用の軽量イメージを作成するステージ
FROM base AS runner
WORKDIR /app

# プロダクション環境設定
ENV NODE_ENV production

# セキュリティのためのユーザーとグループの作成
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# ビルド済みの公開ディレクトリとNext.jsのスタンドアロンファイルをコピー
COPY --from=builder /app/public ./public
RUN mkdir .next
RUN chown nextjs:nodejs .next

# スタンドアロンモードでビルドされたファイルをコピー
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# nextjsユーザーでアプリケーションを実行
USER nextjs

# アプリケーションがリッスンするポート
EXPOSE 3000
ENV PORT=3000

# サーバーの起動
CMD HOSTNAME="0.0.0.0" node server.js
