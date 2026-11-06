# Retail Sales & Business Performance Analytics | Power BI Portfolio Project

## Business problem
A fictional Indian retail business needs a single view of sales, profitability, customer segments, product categories, regional performance and target attainment. This project demonstrates an end-to-end BI workflow using synthetic data.

> **Data notice:** All records and people in the CSV files are synthetic and generated for learning and portfolio demonstration. They do not represent a real company or customer.

## Project objectives
- Track revenue, profit, order volume, units sold and average order value.
- Compare actual sales with monthly targets.
- Identify high-performing and underperforming products, categories and regions.
- Understand customer segments and sales channels.
- Demonstrate ETL, SQL validation, dimensional modelling and DAX.

## Tech stack
Power BI Desktop | Power Query | DAX | PostgreSQL-compatible SQL | CSV | GitHub Pages

## Repository structure
```text
data/                 Synthetic source CSV files
sql/                  SQL table definitions and analysis queries
powerbi/              DAX measures and Power Query M examples
docs/                 Requirements, data dictionary and build guide
portfolio_website/    Static portfolio website
```

## Dataset
| File | Grain | Approx. rows |
|---|---|---:|
| FactSales.csv | One sales order line | 8,000 |
| DimProduct.csv | One product | 26 |
| DimCustomer.csv | One customer | 500 |
| DimRegion.csv | One city | 11 |
| DimDate.csv | One calendar date | 1,096 |
| FactTargets.csv | Month + region + category | 1,584 |

## Data model
Use a star-schema approach:
- `DimDate[Date]` 1 → * `FactSales[OrderDate]`
- `DimProduct[ProductKey]` 1 → * `FactSales[ProductKey]`
- `DimCustomer[CustomerKey]` 1 → * `FactSales[CustomerKey]`
- `DimRegion[RegionKey]` 1 → * `FactSales[RegionKey]`
- `DimRegion[RegionKey]` 1 → * `FactTargets[RegionKey]`
- `DimDate[Date]` 1 → * `FactTargets[TargetMonth]` (use a month-start date key/date column)
- For target category filtering, create a category dimension or a shared product-category dimension and relate it to both facts. Avoid a many-to-many relationship.

## Dashboard pages
1. **Executive Overview:** KPI cards, monthly sales trend, profit trend, target attainment, region/category contribution.
2. **Product Performance:** category and product ranking, sales vs profit, discount analysis.
3. **Customer Insights:** segment mix, top customers, repeat purchase patterns, channel split.
4. **Regional Performance:** region/city comparison, target vs actual, order and profit trends.

## Quick start
1. Install Power BI Desktop.
2. Download or clone this repository.
3. In Power BI Desktop choose **Get data → Text/CSV** and load the six CSV files from `data/`.
4. Set correct data types. Treat date columns as Date, keys as Whole Number, percentages as Decimal Number and financial columns as Fixed Decimal Number.
5. Create relationships following `docs/DATA_MODEL.md`.
6. Add the DAX measures from `powerbi/DAX_Measures.dax`.
7. Build the four report pages using `docs/BUILD_GUIDE.md`.
8. Validate totals against the SQL queries in `sql/analysis_queries.sql`.
9. Save your `.pbix` file in a local `report/` folder. Add screenshots to `screenshots/` before publishing your repository. Do not publish confidential data.

## Important modelling note for targets
Targets are stored at month + region + category grain, while sales are at order-line grain. Do not directly join the two fact tables. Create shared dimensions for Date/Month, Region and Category, then let those dimensions filter each fact table. Use a month-start date column in the target table.

## Portfolio positioning
Suggested project title: **Retail Sales & Profitability Analytics | Power BI, DAX, SQL**
Suggested resume bullet (edit to reflect work you actually complete):
- Built an end-to-end Power BI retail analytics solution using a star schema, Power Query transformations and DAX measures to analyse sales, profit, customer segments, product performance and regional target attainment across 8,000 synthetic order lines.

## Publish to GitHub
Create a public repository named `powerbi-retail-sales-analytics`, upload this folder, and enable GitHub Pages using `portfolio_website/` as the site source (or copy its contents to the repository root /docs as required by your Pages configuration). See `docs/GITHUB_AND_PORTFOLIO.md`.


<img width="1306" height="727" alt="image" src="https://github.com/user-attachments/assets/f00ac529-19d5-4a77-85dc-dcc0d1658d27" />
<img width="1348" height="721" alt="image" src="https://github.com/user-attachments/assets/2ffe0e05-d8a6-4052-96e6-fbf811dc6bf0" />
<img width="1312" height="727" alt="image" src="https://github.com/user-attachments/assets/3928ca95-bfd5-4238-b3b0-7aacb31c56b6" />



