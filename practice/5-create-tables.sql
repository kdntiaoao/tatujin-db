/**
 * ===========================
 * テーブル作成
 * ===========================
 */

-- 支社
CREATE TABLE head_offices (
  head_office_code CHAR(3) PRIMARY KEY,
  head_office_name VARCHAR(100) NOT NULL
);

-- 支店
CREATE TABLE branches (
  head_office_code CHAR(3) NOT NULL,
  branch_code CHAR(2) NOT NULL,
  branch_name VARCHAR(100) NOT NULL,

  PRIMARY KEY (head_office_code, branch_code),

  FOREIGN KEY (head_office_code)
  REFERENCES head_offices (head_office_code)
);

-- 商品分類
CREATE TABLE product_categories (
  category_code CHAR(2) PRIMARY KEY,
  category_name VARCHAR(100) NOT NULL
);

-- 商品
CREATE TABLE products (
  product_code CHAR(3) PRIMARY KEY,
  product_name VARCHAR(100) NOT NULL,
  category_code CHAR(2) NOT NULL,

  FOREIGN KEY (category_code)
  REFERENCES product_categories (category_code)
);

-- 支店商品
CREATE TABLE branch_products (
  head_office_code CHAR(3) NOT NULL,
  branch_code CHAR(2) NOT NULL,
  product_code CHAR(3) NOT NULL,

  PRIMARY KEY (
    head_office_code,
    branch_code,
    product_code
  ),

  FOREIGN KEY (head_office_code, branch_code)
  REFERENCES branches (head_office_code, branch_code),

  FOREIGN KEY (product_code)
  REFERENCES products (product_code)
);

/**
 * ===========================
 * データ挿入
 * ===========================
 */

-- 支社
INSERT INTO head_offices
(head_office_code, head_office_name)
VALUES
('001', '東京'),
('002', '大阪');

-- 支店
INSERT INTO branches
(head_office_code, branch_code, branch_name)
VALUES
('001', '01', '渋谷'),
('001', '02', '八重洲'),
('002', '01', '堺'),
('002', '02', '豊中');

-- 商品分類
INSERT INTO product_categories
(category_code, category_name)
VALUES
('C1', '水洗用品'),
('C2', '食器'),
('C3', '書籍'),
('C4', '日用雑貨');

-- 商品
INSERT INTO products
(product_code, product_name, category_code)
VALUES
('001', '石鹸', 'C1'),
('002', 'タオル', 'C1'),
('003', 'ハブラシ', 'C1'),
('004', 'コップ', 'C1'),
('005', '箸', 'C2'),
('006', 'スプーン', 'C2'),
('007', '雑誌', 'C3'),
('008', '爪切り', 'C4');

-- 支店商品
INSERT INTO branch_products
(head_office_code, branch_code, product_code)
VALUES
('001', '01', '001'),
('001', '01', '002'),
('001', '01', '003'),

('001', '02', '002'),
('001', '02', '003'),
('001', '02', '004'),
('001', '02', '005'),
('001', '02', '006'),

('002', '01', '001'),
('002', '01', '002'),

('002', '02', '007'),
('002', '02', '008');
