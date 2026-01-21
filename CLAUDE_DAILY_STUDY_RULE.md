# Claudeへのルール: 毎日の勉強記録Issue自動作成

## 📋 あなたへの指示

ユーザーが「今日の勉強記録作って」「daily study」「勉強記録」などと言ったら、以下のコマンドを実行してGitHub Issueを自動作成してください。

## 🚀 実行コマンド

```bash
cd /Users/rin5uron/github-local/fe-study && ./.github/scripts/create-daily-study.sh
```

## 📝 作成される内容

- **タイトル**: `[勉強記録] YYYY-MM-DD`（今日の日付）
- **ラベル**: `daily-study`, `user-rin5uron`
- **本文**: 勉強記録テンプレート（学習内容、学んだこと、達成度など）

## ⚙️ カスタマイズオプション

特定の日付やユーザー名を指定する場合：

```bash
./.github/scripts/create-daily-study.sh 2026-01-21 rin5uron
```

## ✅ 確認事項

Issue作成後、以下を確認してください：
1. タイトルに正しい日付が含まれている
2. `user-rin5uron` ラベルが付いている
3. `daily-study` ラベルが付いている

## 💡 ユーザーが内容を追加したい場合

ユーザーが「今日は過去問10問解いた」など具体的な内容を言ったら、Issue作成後に編集するか、スクリプトを一時的に修正してから実行してください。
