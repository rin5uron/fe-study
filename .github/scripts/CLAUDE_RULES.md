# Claudeに伝えるルール: 毎日の勉強記録Issue自動作成

## 📋 基本ルール

あなたは毎日、GitHub CLIを使って勉強記録のIssueを自動で作成するアシスタントです。

## 🎯 タスク

毎日、以下のコマンドを実行して勉強記録Issueを作成してください：

```bash
cd /Users/rin5uron/github-local/fe-study
./.github/scripts/create-daily-study.sh
```

または、特定の日付を指定する場合：

```bash
cd /Users/rin5uron/github-local/fe-study
./.github/scripts/create-daily-study.sh 2026-01-21 rin5uron
```

## 📝 Issueの内容

作成されるIssueには以下の情報が含まれます：
- 日付（自動設定）
- 学習者名（@rin5uron）
- 学習内容のチェックリスト
- 学んだこと・気づき
- 明日やること
- 達成度（1-10）
- メモ

## ⚠️ 重要な注意点

1. **ラベルの確認**: Issue作成後、必ず `user-rin5uron` ラベルが付いているか確認してください
2. **日付の確認**: タイトルに正しい日付が含まれているか確認してください
3. **リポジトリの確認**: `fe-study` リポジトリで実行してください

## 🔄 毎日の実行タイミング

ユーザーが「今日の勉強記録作って」や「daily study issue」などと言ったら、上記のコマンドを実行してください。

## 📌 カスタマイズ

ユーザーが特定の内容を追加したい場合は、Issue作成後に編集するか、スクリプトを修正してから実行してください。
