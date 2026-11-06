// Power Query M examples. Adjust the path to your local project folder.
// Example for FactSales.csv:
let
    Source = Csv.Document(
        File.Contents("C:\\YOUR\\PATH\\PowerBI_Retail_Analytics_Portfolio\\data\\FactSales.csv"),
        [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]
    ),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    ChangedTypes = Table.TransformColumnTypes(PromotedHeaders,{
        {"SalesID", type text}, {"OrderDate", type date}, {"ShipDate", type date},
        {"ProductKey", Int64.Type}, {"CustomerKey", Int64.Type}, {"RegionKey", Int64.Type},
        {"Quantity", Int64.Type}, {"UnitPrice", Currency.Type}, {"DiscountPct", Percentage.Type},
        {"SalesAmount", Currency.Type}, {"CostAmount", Currency.Type}, {"Profit", Currency.Type},
        {"ShipMode", type text}, {"OrderStatus", type text}, {"SalesChannel", type text}
    }),
    CleanText = Table.TransformColumns(ChangedTypes,{
        {"SalesID", Text.Trim, type text}, {"ShipMode", Text.Trim, type text},
        {"OrderStatus", Text.Trim, type text}, {"SalesChannel", Text.Trim, type text}
    }),
    AddedOrderMonth = Table.AddColumn(CleanText, "OrderMonthStart", each Date.StartOfMonth([OrderDate]), type date)
in
    AddedOrderMonth

// For FactTargets, add a month-start field:
= Table.AddColumn(#"Changed Type", "TargetMonthStart", each Date.StartOfMonth([TargetMonth]), type date)
