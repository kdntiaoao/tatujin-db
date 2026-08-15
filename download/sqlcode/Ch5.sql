
CREATE TABLE 会社
(会社コード   CHAR(5)      NOT NULL PRIMARY KEY,
 会社名       VARCHAR(32)  NOT NULL);

INSERT INTO 会社 VALUES('C0001', 'A 商事');
INSERT INTO 会社 VALUES('C0002', 'B 化学');
INSERT INTO 会社 VALUES('C0003', 'C 建設');


CREATE TABLE 部署
(部署コード   CHAR(3)      NOT NULL PRIMARY KEY,
 部署名       VARCHAR(32)  NOT NULL);

INSERT INTO 部署 VALUES('D01', '開発');
INSERT INTO 部署 VALUES('D02', '人事');
INSERT INTO 部署 VALUES('D03', '営業');
INSERT INTO 部署 VALUES('D04', '総務');

CREATE TABLE 社員
(会社コード   CHAR(5)      NOT NULL,
 社員ID       CHAR(4)      NOT NULL,
 社員名       VARCHAR(32)  NOT NULL,
 年齢         INTEGER      NOT NULL,
 部署コード   CHAR(3)      NOT NULL,
   CONSTRAINT pk_社員 PRIMARY KEY(会社コード, 社員ID),
   CONSTRAINT fk_会社 FOREIGN KEY (会社コード) REFERENCES 会社(会社コード),
   CONSTRAINT fk_部署 FOREIGN KEY (部署コード) REFERENCES 部署(部署コード));

INSERT INTO 社員 VALUES('C0001', '000A', '加藤', '40', 'D01');
INSERT INTO 社員 VALUES('C0001', '000B', '藤本', '32', 'D02');
INSERT INTO 社員 VALUES('C0001', '001F', '三島', '50', 'D03');
INSERT INTO 社員 VALUES('C0002', '000A', '斉藤', '47', 'D03');
INSERT INTO 社員 VALUES('C0002', '009F', '田島', '25', 'D01');
INSERT INTO 社員 VALUES('C0002', '010A', '渋谷', '33', 'D04');

SELECT 会社.会社名,
       社員.社員名
  FROM 社員 INNER JOIN 会社
             ON 社員.会社コード = 会社.会社コード
 WHERE 社員.社員名 = '田島';

SELECT 会社.会社名,
       社員.社員名,
       部署.部署名
  FROM 社員 INNER JOIN 会社
               ON 社員.会社コード = 会社.会社コード
                  INNER JOIN 部署
                     ON 社員.部署コード = 部署.部署コード
 WHERE 社員.社員名 = '田島';

SELECT 会社.会社コード,
       COUNT(社員.社員名) AS 社員数
  FROM 会社 LEFT OUTER JOIN 社員
              ON 社員.会社コード = 会社.会社コード
 GROUP BY 会社.会社コード;

DROP TABLE 社員;
CREATE TABLE 社員
(会社コード   CHAR(5)      NOT NULL,
 会社名       VARCHAR(32)  NOT NULL,
 社員ID       CHAR(4)      NOT NULL,
 社員名       VARCHAR(32)  NOT NULL,
 年齢         INTEGER      NOT NULL,
 部署コード   CHAR(3)      NOT NULL,
 部署名       VARCHAR(32)  NOT NULL,
   CONSTRAINT pk_社員 PRIMARY KEY(会社コード, 社員ID));

INSERT INTO 社員 VALUES('C0001', 'A 商事',  '000A', '加藤', 40, 'D01', '開発');
INSERT INTO 社員 VALUES('C0001', 'A 商事',  '000B', '藤本', 32, 'D02', '人事');
INSERT INTO 社員 VALUES('C0001', 'A 商事',  '001F', '三島', 50, 'D03', '営業');
INSERT INTO 社員 VALUES('C0002', 'B 化学',  '000A', '斉藤', 47, 'D03', '営業');
INSERT INTO 社員 VALUES('C0002', 'B 化学',  '009F', '田島', 25, 'D01', '開発');
INSERT INTO 社員 VALUES('C0002', 'B 化学',  '010A', '渋谷', 33, 'D04', '総務');

SELECT 会社名,
       社員名,
       部署名
  FROM 社員
 WHERE 社員名 = '田島';

UPDATE 社員
   SET 会社名 = 'E物産'
 WHERE 会社コード = 'C0001';

UPDATE 会社
   SET 会社名 = 'E物産'
 WHERE 会社コード = 'C0001';

CREATE TABLE 受注
(受注ID   CHAR(4)  NOT NULL PRIMARY KEY,
 受注日   DATE     NOT NULL,
 注文名義 VARCHAR(32) NOT NULL);

INSERT INTO 受注 VALUES('0001', '2024-01-05', '岡野　徹');
INSERT INTO 受注 VALUES('0002', '2024-01-05', '浜田　健一');
INSERT INTO 受注 VALUES('0003', '2024-01-06', '石井　慶子');
INSERT INTO 受注 VALUES('0004', '2024-01-07', '若山　みどり');
INSERT INTO 受注 VALUES('0005', '2024-01-07', '庄野　弘一');
INSERT INTO 受注 VALUES('0006', '2024-01-11', '若山　みどり');
INSERT INTO 受注 VALUES('0007', '2024-01-12', '岡野　徹');

CREATE TABLE 受注明細
(受注ID   CHAR(4)        NOT NULL,
 受注明細連番   INTEGER  NOT NULL,
 商品名 VARCHAR(32) NOT NULL,
   CONSTRAINT pk_受注明細 PRIMARY KEY(受注ID, 受注明細連番),
   CONSTRAINT fk_受注明細 FOREIGN KEY (受注ID) REFERENCES 受注(受注ID));

INSERT INTO 受注明細 VALUES('0001', 1, 'マカロン');
INSERT INTO 受注明細 VALUES('0001', 2, '紅茶');
INSERT INTO 受注明細 VALUES('0001', 3, 'オリーブオイル');
INSERT INTO 受注明細 VALUES('0001', 4, 'チョコ詰め合わせ');
INSERT INTO 受注明細 VALUES('0002', 1, '紅茶');
INSERT INTO 受注明細 VALUES('0002', 2, '日本茶');
INSERT INTO 受注明細 VALUES('0002', 3, 'ティーポット');
INSERT INTO 受注明細 VALUES('0003', 1, '米');
INSERT INTO 受注明細 VALUES('0004', 1, 'アイロン');
INSERT INTO 受注明細 VALUES('0004', 2, 'ネクタイ');
INSERT INTO 受注明細 VALUES('0005', 1, 'チョコ詰め合わせ');
INSERT INTO 受注明細 VALUES('0005', 2, '紅茶');
INSERT INTO 受注明細 VALUES('0005', 3, 'クッキーセット');
INSERT INTO 受注明細 VALUES('0006', 1, '牛肉');
INSERT INTO 受注明細 VALUES('0006', 2, '鍋セット');
INSERT INTO 受注明細 VALUES('0007', 1, '米');

SELECT 受注.受注日,
       COUNT(*) AS 商品数
  FROM 受注 INNER JOIN 受注明細
              ON 受注.受注ID = 受注明細.受注ID
 GROUP BY 受注.受注日;

DROP TABLE 受注 CASCADE;
CREATE TABLE 受注
(受注ID   CHAR(4)  NOT NULL PRIMARY KEY,
 受注日   DATE     NOT NULL,
 注文名義 VARCHAR(32) NOT NULL,
 商品数   INTEGER  NOT NULL);

INSERT INTO 受注 VALUES('0001', '2024-01-05', '岡野　徹', 7);
INSERT INTO 受注 VALUES('0002', '2024-01-05', '浜田　健一',7);
INSERT INTO 受注 VALUES('0003', '2024-01-06', '石井　慶子', 1);
INSERT INTO 受注 VALUES('0004', '2024-01-07', '若山　みどり',5);
INSERT INTO 受注 VALUES('0005', '2024-01-07', '庄野　弘一',5);
INSERT INTO 受注 VALUES('0006', '2024-01-11', '若山　みどり',2);
INSERT INTO 受注 VALUES('0007', '2024-01-12', '岡野　徹',1);

SELECT DISTINCT 受注日, 商品数
  FROM 受注;

SELECT 受注.受注ID,
       受注明細.商品名
  FROM 受注 INNER JOIN 受注明細
    ON 受注.受注ID = 受注明細.受注ID
WHERE 受注.受注日 BETWEEN '2024-01-06' AND '2024-01-07';


DROP TABLE 受注明細;
CREATE TABLE 受注明細
(受注ID   CHAR(4)        NOT NULL,
 受注明細連番   INTEGER  NOT NULL,
 商品名 VARCHAR(32) NOT NULL,
 受注日 DATE NOT NULL,
   CONSTRAINT pk_受注明細 PRIMARY KEY(受注ID, 受注明細連番),
   CONSTRAINT fk_受注明細 FOREIGN KEY (受注ID) REFERENCES 受注(受注ID) );

INSERT INTO 受注明細 VALUES('0001', 1, 'マカロン', '2024-01-05');
INSERT INTO 受注明細 VALUES('0001', 2, '紅茶', '2024-01-05');
INSERT INTO 受注明細 VALUES('0001', 3, 'オリーブオイル', '2024-01-05');
INSERT INTO 受注明細 VALUES('0001', 4, 'チョコ詰め合わせ', '2024-01-05');
INSERT INTO 受注明細 VALUES('0002', 1, '紅茶', '2024-01-05');
INSERT INTO 受注明細 VALUES('0002', 2, '日本茶', '2024-01-05');
INSERT INTO 受注明細 VALUES('0002', 3, 'ティーポット', '2024-01-05');
INSERT INTO 受注明細 VALUES('0003', 1, '米', '2024-01-06');
INSERT INTO 受注明細 VALUES('0004', 1, 'アイロン', '2024-01-07');
INSERT INTO 受注明細 VALUES('0004', 2, 'ネクタイ', '2024-01-07');
INSERT INTO 受注明細 VALUES('0005', 1, 'チョコ詰め合わせ', '2024-01-07');
INSERT INTO 受注明細 VALUES('0005', 2, '紅茶', '2024-01-07');
INSERT INTO 受注明細 VALUES('0005', 3, 'クッキーセット', '2024-01-07');
INSERT INTO 受注明細 VALUES('0006', 1, '牛肉', '2024-01-11');
INSERT INTO 受注明細 VALUES('0006', 2, '鍋セット', '2024-01-11');
INSERT INTO 受注明細 VALUES('0007', 1, '米', '2024-01-12');

SELECT 受注ID,
       商品名
  FROM 受注明細
 WHERE 受注日 BETWEEN '2024-01-06' AND '2024-01-07';
