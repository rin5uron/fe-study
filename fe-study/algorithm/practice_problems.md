# ✅ 基本情報アルゴリズム15問セット（午前＋午後対策）
# すべて擬似言語。<br> は余白用。

============================================================
【午前対策：基礎10問】

Q1.（線形探索）
A = [8,3,6,1]
key = 6
idx ← -1
for i ← 0 to 3
  if A[i] = key then
    idx ← i
    break
出力: idx の値は？

<br>

Q2.（最大値更新）
A = [5,7,2,9,6]
maxv ← A[0]
for i ← 1 to 4
  if A[i] > maxv then maxv ← A[i]
出力: maxv = ?

<br>

Q3.（二分探索）
A = [1,3,5,7,9,11]
key = 7
low←0; hi←5
while low ≤ hi
  mid←(low+hi) div 2
  if A[mid]=key then break
  else if A[mid]<key then low←mid+1
  else hi←mid-1
出力: mid の最終値は？

<br>

Q4.（逆順）
A = [1,2,3,4]
for i ← 0 to (4 div 2)-1
  j ← 4-1-i
  tmp ← A[i]; A[i] ← A[j]; A[j] ← tmp
出力: A = ?

<br>

Q5.（バブルソート）
A = [5,2,4]
for i ← 0 to 1
  for j ← 0 to 1-i
    if A[j]>A[j+1] then
      tmp←A[j];A[j]←A[j+1];A[j+1]←tmp
出力: A = ?

<br>

Q6.（選択ソート）
A = [3,1,4]
for i ← 0 to 1
  minj←i
  for j ← i+1 to 2
    if A[j]<A[minj] then minj←j
  tmp←A[i];A[i]←A[minj];A[minj]←tmp
出力: A = ?

<br>

Q7.（挿入ソート）
A = [5,1,3]
for i←1 to 2
  v←A[i]; j←i-1
  while j≥0 and A[j]>v
    A[j+1]←A[j]; j←j-1
  A[j+1]←v
出力: A = ?

<br>

Q8.（フラグ制御）
found←false
for i←1 to 4
  if i=3 then found←true;break
出力: found の値は？

<br>

Q9.（回文判定）
s="level"
ok←true; left←0; right←4
while left<right
  if s[left]≠s[right] then ok←false;break
  left←left+1; right←right-1
出力: ok の値は？

<br>

Q10.（再帰：階乗）
fact(n):
  if n≤1 then return 1
  else return n*fact(n-1)
出力: fact(4) の結果は？

<br><br>


============================================================
【午後対策：応用アルゴリズムBEST5】

Q11.（累積和）
A=[2,3,5,4]
P[0]=0
for i←1 to 4
  P[i]=P[i-1]+A[i-1]
出力: P = ?

<br>

Q12.（スライディングウィンドウ）
A=[3,1,2,5,1], S=6
left←0; sum←0; ans←999
for right←0 to 4
  sum←sum+A[right]
  while sum≥S
    ans←min(ans, right-left+1)
    sum←sum-A[left]; left←left+1
出力: ans の値は？（最短区間長）

<br>

Q13.（スタック：括弧の整合性）
s="(()())"
stack←empty
ok←true
for each c in s
  if c='(' then push(c)
  else if c=')' then
    if empty(stack) then ok←false
    else pop()
if not empty(stack) then ok←false
出力: ok の値は？

<br>

Q14.（キュー：幅優先探索イメージ）
Q←empty; push(1)
while not empty(Q)
  v←pop()
  print(v)
  if v<3 then push(v+1)
出力: print順は？

<br>

Q15.（再帰：フィボナッチ）
fib(n):
  if n≤1 then return n
  else return fib(n-1)+fib(n-2)
出力: fib(5) = ?

<br><br>


============================================================
💡【解答・解説まとめ】

Q1 → 2　# A[2]=6<br>
Q2 → 9　# 最大値9<br>
Q3 → 3　# A[3]=7で一致<br>
Q4 → [4,3,2,1]　# 逆順<br>
Q5 → [2,4,5]　# 昇順に整列<br>
Q6 → [1,3,4]　# 選択ソート結果<br>
Q7 → [1,3,5]　# 挿入ソート結果<br>
Q8 → true　# i=3でfound=true<br>
Q9 → true　# levelは回文<br>
Q10 → 24　# 4*3*2*1=24<br>
Q11 → [0,2,5,10,14]　# 累積和<br>
Q12 → 2　# [1,2,5,1]の中で(2,5)区間長2<br>
Q13 → true　# 括弧は全て対応<br>
Q14 → 出力順: 1,2,3　# BFSの流れ<br>
Q15 → 5　# fib(5)=5 (1,1,2,3,5)
