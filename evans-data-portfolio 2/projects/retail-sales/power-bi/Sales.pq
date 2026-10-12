let
    Source = Csv.Document(
        File.Contents(CleanCsvPath),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Headers = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(
        Headers,
        {
            {"source_row", Int64.Type},
            {"transaction_id", type text},
            {"order_date", type date},
            {"city", type text},
            {"category", type text},
            {"product", type text},
            {"channel", type text},
            {"quantity", Int64.Type},
            {"unit_price_ngn", Currency.Type},
            {"unit_cost_ngn", Currency.Type},
            {"discount_rate", type number},
            {"status", type text},
            {"gross_sales_ngn", Currency.Type},
            {"net_revenue_ngn", Currency.Type},
            {"cogs_ngn", Currency.Type},
            {"gross_profit_ngn", Currency.Type}
        },
        "en-US"
    )
in
    Typed
