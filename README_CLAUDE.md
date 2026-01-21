# Claudeへの簡潔なルール

## 毎日の勉強記録Issue作成

ユーザーが「今日の勉強記録作って」「daily study」「勉強記録」などと言ったら、以下を実行：

```bash
cd /Users/rin5uron/github-local/fe-study && ./.github/scripts/create-daily-study.sh
```

これで今日の日付で勉強記録Issueが自動作成されます。

詳細は `CLAUDE_DAILY_STUDY_RULE.md` を参照。
