// SalesQuota generation — PBI-RETAIL-001 §4.3
// Grain: one row per Region per Month (2015–2017).
// Quota = prior-year actual sales per Region per month × 1.10, rounded.
// Reference the STAGING query (raw CSV load, before the star-schema split)
// so Region is still present on each row. Disable load on stgSuperstore.

let
    Source = stgSuperstore,   // staging query: raw CSV with Region + Order Date + Sales
    AddMonth = Table.AddColumn ( Source, "OrderMonthStart",
        each Date.StartOfMonth ( [Order Date] ), type date ),
    Grouped = Table.Group ( AddMonth, { "Region", "OrderMonthStart" },
        { { "PYSales", each List.Sum ( [Sales] ), type number } } ),
    ShiftYear = Table.TransformColumns ( Grouped,
        { { "OrderMonthStart", each Date.AddYears ( _, 1 ), type date } } ),
    AddQuota = Table.AddColumn ( ShiftYear, "QuotaAmount",
        each Number.Round ( [PYSales] * 1.10, 0 ), Currency.Type ),
    RemovePY = Table.RemoveColumns ( AddQuota, { "PYSales" } ),
    Renamed = Table.RenameColumns ( RemovePY,
        { { "OrderMonthStart", "MonthStart" } } ),
    Filtered = Table.SelectRows ( Renamed, each [MonthStart] <= #date ( 2017, 12, 1 ) )
in
    Filtered

// Model relationship: SalesQuota[MonthStart] *:1 DimDate[Date] (single direction).
// Region is bridged virtually in DAX via TREATAS — see dax/measures.md, 03 Quota.
