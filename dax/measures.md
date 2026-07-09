# DAX Measure Catalog — Superstore Retail Sales & Forecasting

Home table: `_Measures` (empty table). Folders match PBI-RETAIL-001 §5.
Format strings noted per measure.

## 01 Core

```dax
Total Sales = SUM ( FactSales[Sales] )                                  -- $#,##0
Total Profit = SUM ( FactSales[Profit] )                                -- $#,##0
Profit Margin % = DIVIDE ( [Total Profit], [Total Sales] )              -- 0.0%
Total Quantity = SUM ( FactSales[Quantity] )                            -- #,##0
Order Count = DISTINCTCOUNT ( FactSales[Order ID] )                     -- #,##0
Avg Order Value = DIVIDE ( [Total Sales], [Order Count] )               -- $#,##0
Active Customers = DISTINCTCOUNT ( FactSales[CustomerKey] )             -- #,##0
Avg Discount % = AVERAGE ( FactSales[Discount] )                        -- 0.0%
```

## 02 Time Intelligence

```dax
Sales YTD = TOTALYTD ( [Total Sales], DimDate[Date] )                   -- $#,##0
Sales MTD = TOTALMTD ( [Total Sales], DimDate[Date] )                   -- $#,##0
Sales PY = CALCULATE ( [Total Sales], SAMEPERIODLASTYEAR ( DimDate[Date] ) )

Sales YoY % =                                                           -- +0.0%;-0.0%
VAR PY = [Sales PY]
RETURN DIVIDE ( [Total Sales] - PY, PY )

Profit PY = CALCULATE ( [Total Profit], SAMEPERIODLASTYEAR ( DimDate[Date] ) )

Profit YoY % =                                                          -- +0.0%;-0.0%
VAR PY = [Profit PY]
RETURN DIVIDE ( [Total Profit] - PY, PY )

Sales 3M Rolling Avg =                                                  -- $#,##0
VAR Period = DATESINPERIOD ( DimDate[Date], MAX ( DimDate[Date] ), -3, MONTH )
RETURN
    DIVIDE (
        CALCULATE ( [Total Sales], Period ),
        CALCULATE ( DISTINCTCOUNT ( DimDate[YearMonth] ), Period )
    )
-- denominator counts actual months present, so partial windows stay honest
```

## 03 Quota

Time filtering flows through the physical SalesQuota[MonthStart] → DimDate[Date]
relationship; Region is bridged virtually (Region is not unique in DimGeography).

```dax
Quota Amount =                                                          -- $#,##0
CALCULATE (
    SUM ( SalesQuota[QuotaAmount] ),
    TREATAS ( VALUES ( DimGeography[Region] ), SalesQuota[Region] )
)

Quota Attainment % = DIVIDE ( [Total Sales], [Quota Amount] )           -- 0%
Quota Variance = [Total Sales] - [Quota Amount]                         -- +$#,##0;-$#,##0

Quota Status =
SWITCH (
    TRUE (),
    ISBLANK ( [Quota Amount] ), "No Quota",
    [Quota Attainment %] >= 1.00, "Met",
    [Quota Attainment %] >= 0.90, "At Risk",
    "Missed"
)
-- drives conditional formatting: Met = green, At Risk = amber, Missed = red
```

## 04 Accounts

```dax
Last Order Date = CALCULATE ( MAX ( FactSales[Order Date] ) )           -- dd-MMM-yyyy

Days Since Last Order =                                                 -- #,##0
VAR AnchorDate = CALCULATE ( MAX ( FactSales[Order Date] ), ALL ( FactSales ) )
VAR LastOrder = [Last Order Date]
RETURN IF ( NOT ISBLANK ( LastOrder ), DATEDIFF ( LastOrder, AnchorDate, DAY ) )
-- anchored to dataset max date, not TODAY(), because Superstore ends in 2017

Account Status =
SWITCH (
    TRUE (),
    ISBLANK ( [Days Since Last Order] ), BLANK (),
    [Days Since Last Order] >= 180, "Dormant",
    [Days Since Last Order] >= 90, "At Risk",
    "Active"
)

Customer Sales Rank = RANKX ( ALL ( DimCustomer[Customer Name] ), [Total Sales] )

Top 10 Customer Sales =
CALCULATE (
    [Total Sales],
    KEEPFILTERS ( TOPN ( 10, ALL ( DimCustomer[Customer Name] ), [Total Sales] ) )
)
```

## 05 Forecast & Scenario

Primary forecast = Analytics-pane forecast on the Page 2 line chart
(ETS, season length 12, 95% CI). These measures add the scenario layer.

```dax
-- What-if parameter (Modeling → New parameter → Numeric range):
Growth Rate = GENERATESERIES ( 0.00, 0.30, 0.01 )

Growth Rate Value = SELECTEDVALUE ( 'Growth Rate'[Growth Rate], 0.05 )  -- 0%
Scenario Sales = [Total Sales] * ( 1 + [Growth Rate Value] )            -- $#,##0
Avg Monthly Sales = AVERAGEX ( VALUES ( DimDate[YearMonth] ), [Total Sales] )

Seasonality Index =                                                     -- 0.00
DIVIDE (
    [Avg Monthly Sales],
    CALCULATE (
        [Avg Monthly Sales],
        ALL ( DimDate[Month Name], DimDate[Month Number] )
    )
)
-- plot by Month Name: >1 = above-average month (Sep/Nov/Dec spike)
```
