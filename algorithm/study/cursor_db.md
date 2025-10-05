

#### 🍎 カーソルとは？

SELECT の結果を **1行ずつ順番に読むための “しおり”** のような仕組み。  
👉 1件ずつ条件を変えて処理したいときに使う。

```sql
DECLARE cur CURSOR FOR
  SELECT name, salary FROM employees;

OPEN cur;
FETCH NEXT FROM cur INTO @name, @salary;

WHILE @@FETCH_STATUS = 0
BEGIN
  -- 条件によってボーナスを変える
  IF @salary < 250000
    PRINT @name + 'さん → ボーナス1万円';
  ELSE
    PRINT @name + 'さん → ボーナス2万円';

  FETCH NEXT FROM cur INTO @name, @salary;
END

CLOSE cur;
DEALLOCATE cur;
