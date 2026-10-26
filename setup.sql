-- cleaned and transformed raw CSV data into a structured schema
DROP TABLE IF EXISTS superstore;

CREATE TABLE superstore AS
SELECT
    "Order ID" AS order_id,
    "Order Date" AS order_date,
    "Ship Date" AS ship_date,
    "Ship Mode" AS ship_mode,
    "Customer ID" AS customer_id,
    "Customer Name" AS customer_name,
    Segment AS segment,
    Country AS country,
    City AS city,
    State AS state,
    "Postal Code" AS postal_code,
    Region AS region,
    "Product ID" AS product_id,
    Category AS category,
    "Sub-Category" AS sub_category,
    "Product Name" AS product_name,
    CAST(Sales AS REAL) AS sales,
    CAST(Quantity AS INTEGER) AS quantity,
    CAST(Discount AS REAL) AS discount,
    CAST(Profit AS REAL) AS profit
FROM superstore_raw;

--creates indexes for analytical queries
CREATE INDEX idx_superstore_order_date ON superstore(order_date);
CREATE INDEX idx_superstore_category ON superstore(category);
CREATE INDEX idx_superstore_customer ON superstore(customer_id);