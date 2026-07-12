# Olist Analytics Warehouse

A dimensional model (star schema) for e-commerce reporting, built with dbt on Databricks. Uses the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle, ~100k orders, 2016-2018) — real, anonymized commercial data across orders, customers, products, sellers, payments, and reviews.

## Why this project

Multiple related entities (orders, customers, products, sellers) need to be organized into a proper star schema before they're easy to query — fact tables for the measurable events, dimension tables for the who/what/where/when context, and a couple of the classic dimensional-modeling problems (grain, surrogate keys, slowly changing dimensions) actually worked through rather than skipped.

## Architecture

```
9 raw CSVs --> Bronze (Delta, one table per source file)
                    |
                    v
          Staging (dbt: typed, renamed columns, one model per source)
                    |
                    v
        Dimensions (dim_customers w/ SCD Type 2, dim_products,
                     dim_sellers, dim_date)
                    |
                    v
        Facts (fct_order_items — grain: one product line item
               per order; fct_order_reviews — grain: one review
               per order)
                    |
                    v
              Power BI (connects directly to the gold tables)
```

- **Bronze** — each of the 9 source CSVs loaded as-is into its own Delta table (`workspace.olist_bronze.*`), schema inferred rather than explicit (a deliberate shortcut for 9 tables at once — explicit schema would be the production choice).
- **Staging** — one dbt model per bronze table: column renaming, basic typing, nothing fancier yet.
- **Dimensions** — `dim_customers_snapshot` is built with a dbt snapshot (`strategy='check'` on city/state) to track a customer's location history rather than overwriting it — confirmed working by forcing a city change and re-running the snapshot, which produced a second row for that customer with the old version closed off (`dbt_valid_to` populated) and a new current one. `dim_products` and `dim_sellers` are simpler, no history tracking, with surrogate keys generated via `row_number()`. `dim_date` is generated from a date spine (`sequence()` + `explode()`) rather than sourced from anywhere.
- **Facts** — two fact tables at two different grains sharing the same dimensions: `fct_order_items` (product-line-item level, the most granular level the source data allows) and `fct_order_reviews` (order-review level — `review_score` is non-additive, only meaningful as an average, never summed). Both join against only the *current* version of `dim_customers_snapshot`; joining against the historically-correct version (the one valid at the time of the order) would be the more accurate approach and is a known simplification here.

A traditional-SQL version of the same schema (with real `PRIMARY KEY`/`FOREIGN KEY` constraints and indexes) lives in `docs/olist_star_schema_traditional_sql.sql`, mainly to make the contrast explicit: Delta Lake constraints are declarative rather than enforced, so referential integrity here is checked through dbt tests instead of the database refusing bad writes, and there's no B-tree indexing — partitioning and Z-ORDER do that job instead.

## Known issues

The `order_reviews` source CSV has free-text review comments with embedded commas/newlines that weren't parsed correctly under the default CSV read options, which shifted columns on some rows (review text ending up in a date column). Fix is `multiLine`/`quote`/`escape` options on the bronze read for that file — in progress.

## Checks

dbt tests on the fact/dimension layer cover uniqueness on grain columns (`order_id` + `order_item_number` on the item fact), not-null on foreign keys, and `relationships` tests standing in for what would be FK constraints in a traditional database.

## Run it

```bash
# ingestion (Databricks notebook, downloads the dataset via the Kaggle API directly into a Volume)
notebooks/01_ingest_bronze.py

# dbt
cd dbt
dbt snapshot   # builds/updates dim_customers_snapshot (SCD Type 2)
dbt run
dbt test
```

`dbt_profiles/`, `data/`, `.env` are gitignored.

## Status

Staging, dimensions (including SCD Type 2), and both fact tables are built and passing tests. Fixing the `order_reviews` CSV parsing issue and adding dbt tests on the dimension tables are next, then the Power BI connection once the gold layer is stable.