# Claude へのメモ

## 👤 学習者情報
- **GitHubユーザー名**: @dataanalytics2020
- issueで学習者を記載する際は必ず @dataanalytics2020 を使う

---

## 📅 毎日の学習フロー

### 1. 開始時
- 勉強記録issueを作成: `[勉強記録] YYYY-MM-DD`
- ラベル: `daily-study`
- 学習者: @dataanalytics2020

### 2. 勉強中
- 過去問道場で問題を解く: https://www.fe-siken.com/fekakomon.php
- 結果をCSVで保存: `uron_report/reportYYYYMMDDHHMM.csv`

### 3. 終了時
1. CSVを読み込んで結果を分析
2. 勉強記録issueを更新（問題数、正答率、学んだこと）
3. 失敗問題集を作成: `failed_questions/YYYY-MM-DD.md`
4. commit & push

---

## 🏁 セッション終了ルール
1. 勉強記録issueを更新（学習者は @dataanalytics2020）
2. 失敗問題集を保存 (failed_questions/YYYY-MM-DD.md)
3. git add . && git commit && git push

---

## 📌 重要：issueの更新方法

### ❌ これはダメ（コメント追加）
gh issue comment 50 --body "内容"
→ これはコメントとして追加される

### ✅ これが正解（issue本文を更新）
gh issue edit 50 --body "内容"
→ これはissue本文そのものを更新する

---

## 📝 学んだことを追加する手順

1. まず gh issue view で現在のissue本文を確認
2. 学んだことセクションに項目を追加
3. gh issue edit で issue本文全体を書き換える

重要: 学んだことはissue本文に直接書く！コメントじゃない！

---

## 🎯 覚えておくこと

- issue comment = コメント欄に追加
- issue edit = issue本文を書き換え

学んだことは必ず issue edit で本文に書く！
