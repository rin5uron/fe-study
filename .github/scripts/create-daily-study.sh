#!/bin/bash

# 毎日の勉強記録Issueを自動作成するスクリプト
# 使い方: ./create-daily-study.sh [日付] [ユーザー名]
# 例: ./create-daily-study.sh 2026-01-21 rin5uron

# 日付の取得（引数がない場合は今日）
DATE=${1:-$(date +%Y-%m-%d)}
USERNAME=${2:-rin5uron}

# Issueタイトル
TITLE="[勉強記録] ${DATE}"

# Issue本文のテンプレート
BODY="## 📅 日付
${DATE}

## 👤 学習者
@${USERNAME}

**⚠️ 重要: このIssueに自分のユーザー名ラベル（例: \`user-${USERNAME}\`）を必ず追加してください！**

## ✅ 今日やったこと

### 学習内容
- [ ] 過去問演習（問題数: ___問）
- [ ] 参考書学習（ページ数: ___ページ）
- [ ] アルゴリズム実装
- [ ] 単語帳学習
- [ ] その他: ___

### 詳細
<!-- 具体的に何を学んだか、どんな問題を解いたかなど -->

## 💡 学んだこと・気づき
<!-- 今日の学習で得た気づきや学び -->

## 📝 明日やること
<!-- 明日の学習予定 -->

## 🎯 今日の達成度
<!-- 1-10で評価 -->
達成度: ___/10

## 📌 メモ
<!-- その他のメモや感想 -->
"

# リポジトリのルートディレクトリに移動
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
cd "${REPO_ROOT}"

# GitHub CLIでIssueを作成
gh issue create \
  --title "${TITLE}" \
  --body "${BODY}" \
  --label "daily-study,user-${USERNAME}"

echo "✅ 勉強記録Issueを作成しました: ${TITLE}"
echo "📝 日付: ${DATE}"
echo "👤 ユーザー: @${USERNAME}"
