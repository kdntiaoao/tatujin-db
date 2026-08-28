-- 商品分類ごとの商品数
SELECT
  PC.category_name,
  COUNT(*)
FROM products P INNER JOIN product_categories PC
  ON P.category_code = PC.category_code
GROUP BY PC.category_name;

-- 支社 / 支店別の取り扱い商品の一覧
SELECT
  HO.head_office_name,
  B.branch_name,
  P.product_name
FROM branch_products BP
INNER JOIN head_offices HO
  ON BP.head_office_code = HO.head_office_code
INNER JOIN branches B
  ON BP.head_office_code = B.head_office_code AND BP.branch_code = B.branch_code
INNER JOIN products P
  ON BP.product_code = P.product_code;

-- 最も取り扱い商品数が多い支店の支店コードと商品数
SELECT
  head_office_code,
  branch_code,
  COUNT(*)
FROM branch_products
GROUP BY head_office_code, branch_code
HAVING COUNT(*) = (
  SELECT MAX(count)
  FROM (
    SELECT
      head_office_code,
      branch_code,
      COUNT(*) AS count
    FROM branch_products
    GROUP BY head_office_code, branch_code
  )
);

SELECT
  branch_code,
  COUNT(*)
FROM branch_products
GROUP BY branch_code
HAVING COUNT(*) = (
  SELECT MAX(count)
  FROM (
    SELECT
      branch_code,
      COUNT(*) AS count
    FROM branch_products
    GROUP BY branch_code
  )
);

-- 非正規化
