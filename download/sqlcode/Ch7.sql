
-- PostgreSQL 配列型
CREATE TABLE huyosha (
  shain_id varchar(4),
  shain_mei varchar(20),
  kodomo varchar(20)[], -- 配列型の宣言
    PRIMARY KEY(shain_id));

-- PostgreSQL
INSERT INTO huyosha VALUES ('000A', '加藤', '{達夫, 信二}');
INSERT INTO huyosha VALUES ('000B', '藤本', NULL);
INSERT INTO huyosha VALUES ('001F', '三島', '{敦, 陽子, 清美}');

-- Oracle 要素数10の文字列型の配列タイプを定義 */
CREATE OR REPLACE TYPE children_typ IS VARRAY(10) of VARCHAR2(16);
/

-- Oracle 配列型
CREATE TABLE huyosha (
  shain_id varchar(4),
  shain_mei varchar(20),
  kodomo children_typ, -- 配列型の宣言
    PRIMARY KEY(shain_id));

