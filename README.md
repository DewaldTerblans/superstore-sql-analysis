# Superstore E-Commerce SQL Performance & Profitability Analysis

An end-to-end SQL analysis project examining retail sales, product profitability, customer segmentation, and growth trends on the US Superstore dataset.

## Executive Summary & Findings

* **Overall KPIs:** Generated **$2.30M in Total Sales** and **$286.4K in Total Profit** across 5,009 orders (12.47% overall profit margin).
* **Category Profitability Trap:** While **Technology** (17.4% margin) and **Office Supplies** (17.0% margin) perform strongly, the **Furniture** category yields a tiny **2.49% profit margin**.
* **Loss-Making Sub-Categories:** **Tables** (-$17,725), **Bookcases** (-$3,472), and **Supplies** (-$1,189) consistently generate negative returns due to aggressive discounting.
* **Discount Erosion:** Orders discounted at **over 20% consistently lose money**. Discounts above 50% generate an average loss of **-$80.15 per transaction**.
* **High-Volume Customer Leakage:** The #1 customer by total spend ($25,043) resulted in a net **-$1,981 loss** for the business due to excessive discounted items.

---

## Technical Skills Demonstrated

* **Data Aggregation & Grouping:** `GROUP BY`, `HAVING`, conditional aggregations.
* **Subqueries & CTEs:** Common Table Expressions (`WITH` clauses) for modular code structure.
* **Advanced Window Functions:** `DENSE_RANK()`, `SUM() OVER()`, and `LAG()` for MoM growth tracking.
* **Data Transformation:** `CASE` statements for dynamic tiering and temporal formatting.
* **Self-Joins:** Market basket analysis to evaluate co-purchased item pairs.

---

## Repository Structure

```text
superstore-sql-analysis/
├── README.md
├── setup.sql
└── queries.sql