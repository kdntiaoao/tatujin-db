●隣接リストモデル
CREATE TABLE OrgChartAdjacency
 (emp  VARCHAR(32),
  boss VARCHAR(32),
    CONSTRAINT pk_OrgChartAdjacency PRIMARY KEY (emp), 
    CONSTRAINT fk_OrgChartAdjacency FOREIGN KEY (boss) REFERENCES OrgChartAdjacency (emp)); 

INSERT INTO OrgChartAdjacency VALUES ('アダム', NULL);
INSERT INTO OrgChartAdjacency VALUES ('イブ', 'アダム');
INSERT INTO OrgChartAdjacency VALUES ('セト', 'アダム');
INSERT INTO OrgChartAdjacency VALUES ('カイン','セト');
INSERT INTO OrgChartAdjacency VALUES ('アベル','セト');
INSERT INTO OrgChartAdjacency VALUES ('ノア', 'セト');
INSERT INTO OrgChartAdjacency VALUES ('ヨブ', 'カイン');

●再帰共通表式による木の深さの探索
WITH RECURSIVE Traversal (emp, boss, depth) AS
(SELECT O1.emp, O1.boss, 1 AS depth /* 開始点となるクエリ */
   FROM OrgChartAdjacency O1
  WHERE boss IS NULL
 UNION ALL
 SELECT O2.emp, O2.boss, (T.depth + 1) AS depth /* 再帰的に繰り返されるクエリ */
   FROM OrgChartAdjacency O2 INNER JOIN Traversal T
     ON T.emp = O2.boss)
SELECT emp, boss, depth
  FROM Traversal;


●セトをルートとする部分木の取得

WITH RECURSIVE Traversal (emp, boss, depth) AS
(SELECT O1.emp, O1.boss, 1 AS depth /* 開始点となるクエリ */
   FROM OrgChartAdjacency O1
  WHERE emp = 'セト'
 UNION ALL
 SELECT O2.emp, O2.boss, (T.depth + 1) AS depth /* 再帰的に繰り返されるクエリ */
   FROM OrgChartAdjacency O2 INNER JOIN Traversal T
     ON T.emp = O2.boss)
SELECT emp, boss, depth
  FROM Traversal;


●木を逆さに辿る
WITH RECURSIVE Traversal (emp, boss, depth) AS
(SELECT O1.emp, O1.boss, 1 AS depth /* 開始点となるクエリ */
   FROM OrgChartAdjacency O1
  WHERE emp = 'ヨブ'
 UNION ALL
 SELECT O2.emp, O2.boss, (T.depth + 1) AS depth  /* 再帰的に繰り返されるクエリ */
   FROM OrgChartAdjacency O2 INNER JOIN Traversal T
     ON T.boss = O2.emp)
SELECT emp, boss, depth
  FROM Traversal;


●隣接リストモデルでリーフノードを求める
SELECT emp
  FROM OrgChartAdjacency O1
 WHERE NOT EXISTS 
       (SELECT * 
          FROM OrgChartAdjacency O2
         WHERE O1.emp = O2.boss);

●セトを削除する：エラーになる
DELETE FROM OrgChartAdjacency
 WHERE emp = 'セト';

●ノードの削除時に子ノードも削除するテーブル定義
CREATE TABLE OrgChartAdjacency
 (emp  VARCHAR(32),
  boss VARCHAR(32),
    CONSTRAINT pk_OrgChartAdjacency PRIMARY KEY (emp), 
    CONSTRAINT fk_OrgChartAdjacency FOREIGN KEY (boss) 
      REFERENCES OrgChartAdjacency (emp) ON DELETE CASCADE); 


●セトの部下の上司をアダムに変えてからセトを削除
UPDATE OrgChartAdjacency
   SET boss = 'アダム'
 WHERE boss = 'セト';

DELETE FROM OrgChartAdjacency
 WHERE emp = 'セト';


●アダムとイブの間にヤコブを挿入
INSERT INTO OrgChartAdjacency VALUES ('ヤコブ', 'アダム');

UPDATE OrgChartAdjacency
   SET boss = 'ヤコブ'
 WHERE emp = 'イブ';



●閉包テーブルモデルのテーブル定義
CREATE TABLE OrgChart
 (emp  VARCHAR(32) PRIMARY KEY,
  role VARCHAR(32) NOT NULL,
  tree_id INTEGER  UNIQUE NOT NULL); 

CREATE TABLE Closure
(parent INTEGER NOT NULL,
 child  INTEGER NOT NULL,
   CONSTRAINT pk_Closure PRIMARY KEY (parent, child),
   CONSTRAINT fk_parent FOREIGN KEY  (parent) REFERENCES OrgChart (tree_id),
   CONSTRAINT fk_child  FOREIGN KEY  (child)  REFERENCES OrgChart (tree_id));

INSERT INTO OrgChart VALUES ('アダム',  '社長', 1);
INSERT INTO OrgChart VALUES ('イブ',    '部長', 2);
INSERT INTO OrgChart VALUES ('セト',    '部長', 3);
INSERT INTO OrgChart VALUES ('カイン',  '課長', 4);
INSERT INTO OrgChart VALUES ('アベル',  '課長', 5);
INSERT INTO OrgChart VALUES ('ノア',    '課長', 6);
INSERT INTO OrgChart VALUES ('ヨブ',    'ヒラ', 7);

INSERT INTO Closure VALUES (1, 1);
INSERT INTO Closure VALUES (1, 2);
INSERT INTO Closure VALUES (1, 3);
INSERT INTO Closure VALUES (1, 4);
INSERT INTO Closure VALUES (1, 5);
INSERT INTO Closure VALUES (1, 6);
INSERT INTO Closure VALUES (1, 7);
INSERT INTO Closure VALUES (2, 2);
INSERT INTO Closure VALUES (3, 3);
INSERT INTO Closure VALUES (3, 4);
INSERT INTO Closure VALUES (3, 5);
INSERT INTO Closure VALUES (3, 6);
INSERT INTO Closure VALUES (3, 7);
INSERT INTO Closure VALUES (4, 4);
INSERT INTO Closure VALUES (4, 7);
INSERT INTO Closure VALUES (5, 5);
INSERT INTO Closure VALUES (6, 6);
INSERT INTO Closure VALUES (7, 7);

●階層の深さを求めるクエリ（閉包テーブル）
SELECT O.emp, COUNT(*) AS depth
  FROM OrgChart O INNER JOIN Closure C
    ON O.tree_id = C.child
 GROUP BY O.emp 
 ORDER BY depth;

●セトの部下を全員求める（自分も含める）
SELECT O2.emp
  FROM (SELECT O.emp, C.child, O.tree_id
          FROM OrgChart O INNER JOIN Closure C
            ON O.tree_id = C.parent
         WHERE O.emp = 'セト') TMP
      INNER JOIN OrgChart O2
         ON O2.tree_id = TMP.child;


●セト配下の部分木を削除
DELETE FROM Closure
 WHERE parent IN
          (SELECT child
             FROM Closure
            WHERE parent = (SELECT O.tree_id
                              FROM OrgChart O
                             WHERE emp = 'セト'));

●セトを部下として持っているレコードを削除
DELETE FROM Closure
 WHERE child = (SELECT O.tree_id
                  FROM OrgChart O
                 WHERE emp = 'セト');

●社員マスタからもセトを削除
DELETE FROM OrgChart
 WHERE emp = 'セト';


●ヨブ配下にイサクを追加
INSERT INTO OrgChart VALUES ('イサク',    'ヒラ', 8);

●上司たちのレコードを追加
INSERT INTO Closure VALUES (7, (SELECT tree_id FROM OrgChart WHERE emp = 'イサク'));
INSERT INTO Closure VALUES (4, (SELECT tree_id FROM OrgChart WHERE emp = 'イサク'));
INSERT INTO Closure VALUES (3, (SELECT tree_id FROM OrgChart WHERE emp = 'イサク'));
INSERT INTO Closure VALUES (1, (SELECT tree_id FROM OrgChart WHERE emp = 'イサク'));

●イサク自身のレコードを追加
INSERT INTO Closure VALUES ((SELECT tree_id FROM OrgChart WHERE emp = 'イサク'), 
                            (SELECT tree_id FROM OrgChart WHERE emp = 'イサク'));


●演習問題 9-2 リーフノードを求めるクエリ（間違い）
SELECT emp
  FROM OrgChartAdjacency
 WHERE emp NOT IN
            (SELECT boss
               FROM OrgChartAdjacency);
