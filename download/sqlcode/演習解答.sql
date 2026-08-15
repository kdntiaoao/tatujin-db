
●演習問題3-3 正規化

CREATE TABLE 支社
(支社コード  CHAR(3)  NOT NULL PRIMARY KEY,
 支社名      CHAR(32) NOT NULL);

INSERT INTO 支社 VALUES ('001', '東京');
INSERT INTO 支社 VALUES ('002', '大阪');

CREATE TABLE 商品
(商品コード  CHAR(3)  NOT NULL PRIMARY KEY,
 商品名      CHAR(32) NOT NULL,
 商品分類コード CHAR(2)  NOT NULL);

INSERT INTO 商品 VALUES('001', '石鹸',    'C1');
INSERT INTO 商品 VALUES('002', 'タオル',  'C1');
INSERT INTO 商品 VALUES('003', 'ハブラシ','C1');
INSERT INTO 商品 VALUES('004', 'コップ',  'C1');
INSERT INTO 商品 VALUES('005', '箸',      'C2');
INSERT INTO 商品 VALUES('006', 'スプーン','C2');
INSERT INTO 商品 VALUES('007', '雑誌',    'C3');
INSERT INTO 商品 VALUES('008', '爪切り',  'C4');

CREATE TABLE 支店
(支社コード  CHAR(3)  NOT NULL,
 支店コード  CHAR(2)  NOT NULL,
 支店名      CHAR(32) NOT NULL,
   CONSTRAINT pk_支店 PRIMARY KEY (支社コード, 支店コード));

INSERT INTO 支店 VALUES ('001', '01', '渋谷');
INSERT INTO 支店 VALUES ('001', '02', '八重洲');
INSERT INTO 支店 VALUES ('002', '01', '堺');
INSERT INTO 支店 VALUES ('002', '02', '豊中');

CREATE TABLE 商品分類
(商品分類コード   CHAR(2) NOT NULL PRIMARY KEY,
 分類名           CHAR(32) NOT NULL);

INSERT INTO 商品分類 VALUES('C1', '水洗用品');
INSERT INTO 商品分類 VALUES('C2', '食器');
INSERT INTO 商品分類 VALUES('C3', '書籍');
INSERT INTO 商品分類 VALUES('C4', '日用雑貨');

CREATE TABLE 支店商品
(支社コード  CHAR(3) NOT NULL,
 支店コード  CHAR(2)  NOT NULL,
 商品コード  CHAR(3)  NOT NULL,
   CONSTRAINT pk_支店商品 PRIMARY KEY (支社コード, 支店コード, 商品コード));

INSERT INTO 支店商品 VALUES('001', '01', '001');
INSERT INTO 支店商品 VALUES('001', '01', '002');
INSERT INTO 支店商品 VALUES('001', '01', '003');
INSERT INTO 支店商品 VALUES('001', '02', '002');
INSERT INTO 支店商品 VALUES('001', '02', '003');
INSERT INTO 支店商品 VALUES('001', '02', '004');
INSERT INTO 支店商品 VALUES('001', '02', '005');
INSERT INTO 支店商品 VALUES('001', '02', '006');
INSERT INTO 支店商品 VALUES('002', '01', '001');
INSERT INTO 支店商品 VALUES('002', '01', '002');
INSERT INTO 支店商品 VALUES('002', '02', '007');
INSERT INTO 支店商品 VALUES('002', '02', '008');


●演習5-1 正規化されたテーブルに対するSQL

※演習3-3で作成したテーブルおよびデータを使用する。

●SQL文1
SELECT 商品分類.商品分類コード,
       商品分類.分類名,
       COUNT(*) AS 商品数
  FROM 商品分類 INNER JOIN 商品
         ON 商品分類.商品分類コード = 商品.商品分類コード
 GROUP BY 商品分類.商品分類コード, 商品分類.分類名;

●SQL文2
SELECT 支社.支社名,
       支店.支店名,
       商品.商品名
  FROM 支社 INNER JOIN 支店
         ON 支社.支社コード = 支店.支社コード
            INNER JOIN 支店商品
              ON 支店.支社コード = 支店商品.支社コード
             AND 支店.支店コード = 支店商品.支店コード
              INNER JOIN 商品
                ON 支店商品.商品コード = 商品.商品コード;

●SQL文3
SELECT 支店.支社コード,
       支店.支店コード,
       COUNT(*) AS 最大商品数
  FROM 支店 INNER JOIN 支店商品
       ON 支店.支社コード = 支店商品.支社コード
      AND 支店.支店コード = 支店商品.支店コード
 GROUP BY 支店.支社コード, 支店.支店コード
HAVING COUNT(*) >=
           ( SELECT MAX(商品数)
               FROM ( SELECT 支店.支社コード,
                             支店.支店コード,
                             COUNT(*) AS 商品数
                        FROM 支店 INNER JOIN 支店商品
                          ON 支店.支社コード = 支店商品.支社コード
                         AND 支店.支店コード = 支店商品.支店コード
                       GROUP BY 支店.支社コード, 支店.支店コード) TMP );


●演習9-3 連番の生成

●Oracle以外の答え
WITH RECURSIVE NumberGenerate (num) AS
(SELECT 1 AS num /* 開始点となるクエリ */
 UNION ALL
 SELECT num + 1 AS num /* 再帰的に繰り返されるクエリ */
   FROM NumberGenerate
  WHERE num <= 99)
SELECT num
  FROM NumberGenerate;

※SQL Serverでは一行目のキーワードRECURSIVEを削除してください。

●Oracleでの答え
WITH NumberGenerate (num) AS
(SELECT 1 AS num /* 開始点となるクエリ */
   FROM DUAL
 UNION ALL
 SELECT num + 1 AS num /* 再帰的に繰り返されるクエリ */
   FROM NumberGenerate
  WHERE num <= 99)
SELECT num
  FROM NumberGenerate;

●フィボナッチ数列の生成（Oracle以外）
WITH RECURSIVE Fib (a, b) AS
(SELECT 0 AS a, 1 AS b /* 開始点となるクエリ */
 UNION ALL
 SELECT b, a + b /* 再帰的に繰り返されるクエリ */
   FROM Fib
  WHERE b <= 99)
SELECT a
  FROM Fib;


●フィボナッチ数列の生成（Oracle）
/* 以下のエラーが発生する
   ORA-32044: 再帰的WITH問合せの実行中にサイクルが検出されました
*/
WITH Fib (a, b) AS
(SELECT 0 AS a, 1 AS b /* 開始点となるクエリ */
   FROM DUAL
 UNION ALL
 SELECT b, a + b /* 再帰的に繰り返されるクエリ */
   FROM Fib
  WHERE b <= 99)
SELECT a
  FROM Fib;
