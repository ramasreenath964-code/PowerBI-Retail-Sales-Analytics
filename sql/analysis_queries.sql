-- PostgreSQL-compatible starter SQL
-- Create tables by importing CSVs with your SQL client, or adapt these definitions.

CREATE TABLE dim_product (
  productkey INT PRIMARY KEY, productname TEXT, category TEXT,
  subcategory TEXT, brand TEXT, unitprice NUMERIC(12,2), unitcost NUMERIC(12,2)
);
CREATE TABLE dim_customer (
  customerkey INT PRIMARY KEY, customername TEXT, segment TEXT,
  city TEXT, regionkey INT, signupdate DATE
);
CREATE TABLE dim_region (
  regionkey INT PRIMARY KEY, region TEXT, city TEXT, country TEXT
);
CREATE TABLE fact_sales (
  salesid TEXT PRIMARY KEY, orderdate DATE, shipdate DATE,
  productkey INT, customerkey INT, regionkey INT, quantity INT,
  unitprice NUMERIC(12,2), discountpct NUMERIC(5,4),
  salesamount NUMERIC(14,2), costamount NUMERIC(14,2), profit NUMERIC(14,2),
  shipmode TEXT, orderstatus TEXT, saleschannel TEXT
);
CREATE TABLE fact_targets (
  targetmonth DATE, regionkey INT, category TEXT, salestarget NUMERIC(14,2),
  PRIMARY KEY (targetmonth, regionkey, category)
);

-- 1. KPI summary
SELECT
  SUM(salesamount) AS total_sales,
  SUM(profit) AS total_profit,
  ROUND(100.0 * SUM(profit) / NULLIF(SUM(salesamount),0), 2) AS profit_margin_pct,
  COUNT(DISTINCT salesid) AS total_orders,
  SUM(quantity) FILTER (WHERE orderstatus = 'Completed') AS completed_units
FROM fact_sales;

-- 2. Monthly sales trend
SELECT DATE_TRUNC('month', orderdate)::date AS sales_month,
       SUM(salesamount) AS sales,
       SUM(profit) AS profit
FROM fact_sales
GROUP BY 1
ORDER BY 1;

-- 3. Category performance
SELECT p.category, SUM(f.salesamount) AS sales,
       SUM(f.profit) AS profit,
       ROUND(100.0*SUM(f.profit)/NULLIF(SUM(f.salesamount),0),2) AS margin_pct
FROM fact_sales f
JOIN dim_product p ON p.productkey=f.productkey
GROUP BY p.category
ORDER BY sales DESC;

-- 4. Regional performance
SELECT r.region, r.city, SUM(f.salesamount) AS sales,
       SUM(f.profit) AS profit, COUNT(DISTINCT f.salesid) AS orders
FROM fact_sales f
JOIN dim_region r ON r.regionkey=f.regionkey
GROUP BY r.region, r.city
ORDER BY sales DESC;

-- 5. Customer segment
SELECT c.segment, SUM(f.salesamount) AS sales,
       COUNT(DISTINCT f.customerkey) AS customers,
       COUNT(DISTINCT f.salesid) AS orders
FROM fact_sales f
JOIN dim_customer c ON c.customerkey=f.customerkey
GROUP BY c.segment
ORDER BY sales DESC;

-- 6. Top 10 products
SELECT p.productname, p.category, SUM(f.salesamount) AS sales,
       SUM(f.profit) AS profit
FROM fact_sales f
JOIN dim_product p ON p.productkey=f.productkey
GROUP BY p.productname, p.category
ORDER BY sales DESC
LIMIT 10;

-- 7. Data quality: orphan product keys (should return zero rows)
SELECT f.productkey
FROM fact_sales f
LEFT JOIN dim_product p ON p.productkey=f.productkey
WHERE p.productkey IS NULL
GROUP BY f.productkey;

-- 8. Target grain uniqueness (should return zero rows)
SELECT targetmonth, regionkey, category, COUNT(*)
FROM fact_targets
GROUP BY targetmonth, regionkey, category
HAVING COUNT(*) > 1;
