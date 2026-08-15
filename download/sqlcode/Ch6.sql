●レンジパーティションのテーブル定義構文（Oracle／MySQL）
CREATE TABLE SalesPartition (
    sales_id   INTEGER NOT NULL,
    sales_date DATE NOT NULL,
    sales_year INTEGER,
      CONSTRAINT pk_SalesPartition PRIMARY KEY (sales_id, sales_year))
PARTITION BY RANGE (sales_year) (
    PARTITION p0 VALUES LESS THAN (2020),
    PARTITION p1 VALUES LESS THAN (2021),
    PARTITION p2 VALUES LESS THAN (2022),
    PARTITION p3 VALUES LESS THAN (2023),
    PARTITION p4 VALUES LESS THAN (2024));


●リストパーティションのテーブル定義構文（PostgreSQL）
CREATE TABLE SalesPartition (
    sales_id   INTEGER NOT NULL,
    sales_date DATE NOT NULL,
    sales_year INTEGER,
      CONSTRAINT pk_SalesPartition PRIMARY KEY (sales_id, sales_year))
PARTITION BY LIST (sales_year);

CREATE TABLE SalesPartition2020 PARTITION OF SalesPartition FOR VALUES IN(2020);
CREATE TABLE SalesPartition2021 PARTITION OF SalesPartition FOR VALUES IN(2021);
CREATE TABLE SalesPartition2022 PARTITION OF SalesPartition FOR VALUES IN(2022);
CREATE TABLE SalesPartition2023 PARTITION OF SalesPartition FOR VALUES IN(2023);

INSERT INTO SalesPartition VALUES (1, '2020-01-16', 2020);
INSERT INTO SalesPartition VALUES (1, '2022-05-20', 2022);

●テーブルの継承によるパーティショニング（PostgreSQL）
CREATE TABLE measurement (
    city_id         int not null,
    logdate         date not null,
    peaktemp        int,
    unitsales       int);

CREATE TABLE measurement_y2006m02 () INHERITS (measurement);
CREATE TABLE measurement_y2006m03 () INHERITS (measurement);
...
CREATE TABLE measurement_y2007m11 () INHERITS (measurement);
CREATE TABLE measurement_y2007m12 () INHERITS (measurement);
CREATE TABLE measurement_y2008m01 () INHERITS (measurement);


●ヒント句の例（Oracle）
SELECT /*+ LEADING(e2 e1) USE_NL(e1) INDEX(e1 emp_emp_id_pk) 
           USE_MERGE(j) FULL(j) */
    e1.first_name, e1.last_name, j.job_id, sum(e2.salary) total_sal
  FROM employees e1, employees e2, job_history j
  WHERE e1.employee_id = e2.manager_id
    AND e1.employee_id = j.employee_id
    AND e1.hire_date = j.start_date
  GROUP BY e1.first_name, e1.last_name, j.job_id
  ORDER BY total_sal;

●セッション単位のパラレルクエリ（Oracle）
ALTER SESSION FORCE PARALLEL QUERY PARALLEL <並列度>;


●メモリ最適化テーブルのDDLサンプル（SQL Server）
CREATE TABLE MemoryTest
(c1 INTEGER PRIMARY KEY NONCLUSTERED) WITH (memory_optimized = on); 

●MEMORYエンジンのDDLサンプル（MySQL）
CREATE TABLE MemoryTest
(c1 INTEGER PRIMARY KEY) ENGINE=MEMORY; 
