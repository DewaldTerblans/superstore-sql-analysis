--query 1: KPI summary
SELECT 
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS overall_profit_margin_pct
FROM superstore;

--query 2: fincial preformance  (Grouping & Aggregation)
SELECT 
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY category, sub_category
ORDER BY category, total_profit ASC;

--query 3: unprofitible products and categories  (HAVING clause)
SELECT 
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

--query 4: impact of discounts on profit  (CASE Bucketing)
SELECT 
    CASE 
        WHEN discount = 0 THEN '0% (No Discount)'
        WHEN discount > 0 AND discount <= 0.20 THEN '1% - 20%'
        WHEN discount > 0.20 AND discount <= 0.50 THEN '21% - 50%'
        ELSE 'Above 50%'
    END AS discount_tier,
    COUNT(*) AS total_transactions,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(profit), 2) AS avg_profit_per_order
FROM superstore
GROUP BY discount_tier
ORDER BY total_profit DESC;

--query 5: top 10 customers  (Subqueries)
SELECT 
    customer_name,
    segment,
    ROUND(SUM(sales), 2) AS total_spent,
    ROUND(SUM(profit), 2) AS total_profit_generated
FROM superstore
GROUP BY customer_id, customer_name, segment
ORDER BY total_spent DESC
LIMIT 10;

--query 6:  custom order frequency   (CTE & Subqueries)
WITH CustomerMetrics AS (
    SELECT 
        customer_id,
        customer_name,
        COUNT(DISTINCT order_id) AS order_count,
        SUM(sales) AS total_sales
    FROM superstore
    GROUP BY customer_id, customer_name
)
SELECT 
    customer_name,
    order_count,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_sales / order_count, 2) AS avg_order_value
FROM CustomerMetrics
WHERE order_count > 5 AND total_sales > (SELECT AVG(total_sales) FROM CustomerMetrics)
ORDER BY total_sales DESC;

--query 7:  regional rankings  (Window Function: DENSE_RANK)
WITH RegionalSales AS (
    SELECT 
        region,
        sub_category,
        ROUND(SUM(sales), 2) AS total_sales,
        DENSE_RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rank_in_region
    FROM superstore
    GROUP BY region, sub_category
)
SELECT * 
FROM RegionalSales 
WHERE rank_in_region <= 3;

--query 8:  monthly sales trend (Window Function: SUM OVER)
WITH MonthlySummary AS (
    SELECT 
        STRFTIME('%Y-%m', order_date) AS sales_month,
        ROUND(SUM(sales), 2) AS monthly_sales
    FROM superstore
    GROUP BY sales_month
)
SELECT 
    sales_month,
    monthly_sales,
    ROUND(SUM(monthly_sales) OVER (ORDER BY sales_month), 2) AS cumulative_sales
FROM MonthlySummary;

--query 9:  month to month growth rate  (Window Function: LAG)
WITH MonthlySales AS (
    SELECT 
        STRFTIME('%Y-%m', order_date) AS sales_month,
        SUM(sales) AS total_sales
    FROM superstore
    GROUP BY sales_month
)
SELECT 
    sales_month,
    ROUND(total_sales, 2) AS current_month_sales,
    ROUND(LAG(total_sales, 1) OVER (ORDER BY sales_month), 2) AS previous_month_sales,
    ROUND(
        ((total_sales - LAG(total_sales, 1) OVER (ORDER BY sales_month)) / 
        LAG(total_sales, 1) OVER (ORDER BY sales_month)) * 100, 2
    ) AS mom_growth_pct
FROM MonthlySales;


-- Query 10: top co-purchasded sub-categories (Self-Join)
SELECT 
    a.sub_category AS product_a,
    b.sub_category AS product_b,
    COUNT(DISTINCT a.order_id) AS times_bought_together
FROM superstore a
JOIN superstore b 
    ON a.order_id = b.order_id 
   AND a.sub_category < b.sub_category
GROUP BY a.sub_category, b.sub_category
ORDER BY times_bought_together DESC
LIMIT 10;