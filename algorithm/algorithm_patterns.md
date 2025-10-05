# 基本情報技術者試験 アルゴリズムBEST10

過去問から抽出した頻出パターン（出題率・読解力重視）

---

## 01. 線形探索（逐次探索）

**出題率**: ★★★★★（毎年登場）

**ポイント**:
- 配列の先頭から順に比較
- 見つかったら break
- 「見つからない場合の処理」を選ばせる設問が多い

```
idx ← -1
for i ← 0 to n-1
  if A[i] = key then
    idx ← i
    break
return idx
```

---

## 02. 最大値・最小値の更新

**出題率**: ★★★★★

**ポイント**:
- 初期値は A[0]
- 「一番○○なデータを出力」系でよく出る
- 更新処理（> / <）の条件と位置を問う問題が多い

```
maxv ← A[0]; maxi ← 0
for i ← 1 to n-1
  if A[i] > maxv then
    maxv ← A[i]
    maxi ← i
return maxi
```

---

## 03. 二分探索（ソート済み配列）

**出題率**: ★★★★☆

**ポイント**:
- 条件分岐と範囲更新を正しく読めるか
- mid 計算と while 条件（≤）を混同しやすい
- 「見つからないときの返値」に注目

```
low ← 0; hi ← n-1
while low ≤ hi
  mid ← (low + hi) div 2
  if A[mid] = key then return mid
  else if A[mid] < key then low ← mid + 1
  else hi ← mid - 1
return -1
```

---

## 04. 配列の逆順（左右入替）

**出題率**: ★★★★☆

**ポイント**:
- 「左右の要素を入れ替える」＝逆順
- right = n-1-i の計算に注目
- tmp変数を経由してswapすること

```
for i ← 0 to (n div 2)-1
  j ← n - 1 - i
  tmp ← A[i]
  A[i] ← A[j]
  A[j] ← tmp
```

---

## 05. バブルソート（隣接交換法）

**出題率**: ★★★★★

**ポイント**:
- 内外二重ループ構造を見抜く
- 「i の範囲」「j の範囲」の設定に注目
- 中間結果（途中の配列）を問う設問が多い

```
for i ← 0 to n-2
  for j ← 0 to n-2-i
    if A[j] > A[j+1] then
      tmp ← A[j]
      A[j] ← A[j+1]
      A[j+1] ← tmp
```

---

## 06. 選択ソート

**出題率**: ★★★★☆

**ポイント**:
- 「minj の更新箇所」「入替タイミング」に注意
- 小さい要素を前に持ってくる

```
for i ← 0 to n-2
  minj ← i
  for j ← i+1 to n-1
    if A[j] < A[minj] then minj ← j
  tmp ← A[i]; A[i] ← A[minj]; A[minj] ← tmp
```

---

## 07. 挿入ソート

**出題率**: ★★★★☆

**ポイント**:
- 「既に整列済み部分」に1要素挿入
- 条件 A[j] > v の方向に注意
- whileループが終わる位置が重要

```
for i ← 1 to n-1
  v ← A[i]
  j ← i - 1
  while j ≥ 0 and A[j] > v
    A[j+1] ← A[j]
    j ← j - 1
  A[j+1] ← v
```

---

## 08. フラグ制御（found）

**出題率**: ★★★★☆

**ポイント**:
- 「条件成立 → フラグtrue → break」
- 終了後に found 判定
- 設問では「break有無」の挙動を問われる

```
found ← false
for i ← 0 to n-1
  if 条件 then
    found ← true
    break
if found then print("Yes")
else print("No")
```

---

## 09. 回文判定（左右比較）

**出題率**: ★★★☆☆

**ポイント**:
- 「左右から一致確認」構造を読めるか
- 不一致で break する条件を問う設問
- 配列インデックス操作の理解が問われる

```
ok ← true
left ← 0; right ← len(s) - 1
while left < right
  if s[left] ≠ s[right] then
    ok ← false
    break
  left ← left + 1
  right ← right - 1
```

---

## 10. 再帰（階乗・フィボナッチ）

**出題率**: ★★★☆☆（計算トレースで出題）

**ポイント**:
- 停止条件（ベースケース）を読めるか
- 「呼び出し回数」「戻り値の流れ」を追う練習が重要

```
fact(n):
  if n ≤ 1 then return 1
  else return n * fact(n - 1)

fib(n):
  if n ≤ 1 then return n
  else return fib(n-1) + fib(n-2)
```
