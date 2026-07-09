# Superstore Retail Sales Analysis & Forecasting — Power BI
Three-page sales-team report on the public Superstore dataset:
star-schema model, 25-measure DAX layer, Region×Month quota framework,
6-month ETS forecast with 95% CI — built in a deliberate 4-hour timebox.
 
## Report pages
![Sales Performance](assets/page1_sales_performance.png)
![Forecast & Outlook](assets/page2_forecast_outlook.png)
![Account & Rep Actions](assets/page3_account_actions.png)
 
## Data model
![Star schema](assets/model_view.png)
 
## Highlights
- Single CSV split into a proper star schema (1 fact, 4 dims, DAX date table)
- Quota framework generated in-model (PY actuals × 1.10) — TREATAS virtual join
- Native ETS forecast (seasonality 12, 95% CI) + what-if growth scenario
- PBIP source control: every DAX change is a readable line diff
 
## Data source (not redistributed here)
- Superstore Dataset (Kaggle): https://www.kaggle.com/datasets/vivek468/superstore-dataset-final
- Tableau sample-data page:    https://public.tableau.com/app/learn/sample-data
 
## Repository map
| Folder | Contents |
|--------|----------|
| docs/  | Numbered document set (01, 08, 12, 15) |
| pbix/  | Report binary — open in Power BI Desktop |
| pbip/  | Power BI Project text files (TMDL) — the diffable source |
| powerquery/ | SalesQuota generation M script |
| dax/   | Full measure catalog |
| theme/ | Report theme JSON |
 
## Built in a 4-hour timebox
Scoping notes and cut-order guardrails are in docs/ — deliberate
prioritization under constraint is part of the demonstration.
