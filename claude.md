# Claude へのメモ

## 📌 重要：issueの更新方法

### ❌ これはダメ（コメント追加）
```bash
gh issue comment 50 --body "内容"
```
→ これは**コメント**として追加される

### ✅ これが正解（issue本文を更新）
```bash
gh issue edit 50 --body "$(cat <<'EOF'
（issue全体の内容）
EOF
)"
```
→ これは**issue本文そのもの**を更新する

---

## 📝 学んだことを追加する手順

1. まず `gh issue view 50` で現在のissue本文を確認
2. 「📚 学んだこと」セクションに項目を追加
3. `gh issue edit` で **issue本文全体** を書き換える

**重要**: 「学んだこと」はissue本文に直接書く！コメントじゃない！

---

## 🎯 覚えておくこと

- **issue comment** = コメント欄に追加
- **issue edit** = issue本文を書き換え

学んだことは必ず **issue edit** で本文に書く！
