# cameroon-health-db-practice
Practice queries answering business questions on a demo auto-generated Cameroon health database

## Project Overview
This project models a 7-table relational electronic health records system tracking 1,500 clinical transactions across all 10 regions of Cameroon. Rather than tracking basic epidemiology, this database evaluates clinical efficiency, diagnostic data gaps, and hospital billing deviations.

> **Note on Data Generation:** The underlying relational database structure and mock transaction records were synthetically designed and generated using AI to simulate a realistic, localized Cameroonian healthcare dataset for advanced practice.

## Core Concepts & Technical Skills Applied
* **Advanced Joins:** Multi-table inner joins mapping regions to patients, and left joins used to identify data collection gaps.
* **Common Table Expressions (CTEs):** Breaking complex problems down into modular steps to isolate and evaluate distinct data layers.
* **Advanced Aggregations:** Multi-attribute grouping and window functions (`AVG() OVER()`, `ROW_NUMBER() OVER()`).
* **Data Cleansing:** Safeguarding data tracking using `COALESCE` to eliminate diagnostic `NULL` string visibility.
* **Database Programmability:** Encapsulating data pipelines into dynamic parameter-driven Stored Procedures.
