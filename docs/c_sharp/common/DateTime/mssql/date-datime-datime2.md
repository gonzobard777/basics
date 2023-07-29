# MSSQL. Date, DateTime, DateTime2

[Ошибки при работе с датой и временем в SQL Server](https://habr.com/ru/companies/otus/articles/487774/)

```csharp
b.Property(x => x.SomeDateTime).HasColumnType("date");

b.Property(x => x.SomeTimeSpan).HasColumnType("time"); // микросекунды 7 знаков
b.Property(x => x.SomeTimeSpan).HasColumnType("time").HasPrecision(4); // микросекунды от 0 до 7 знаков

b.Property(x => x.SomeDateTime).HasColumnType("datetime"); // микросекунды 3 знака

b.Property(x => x.SomeDateTime).HasColumnType("datetime2"); // микросекунды 7 знаков
b.Property(x => x.SomeDateTime).HasColumnType("datetime2").HasPrecision(5); // микросекунды от 0 до 7 знаков

b.Property(x => x.SomeDateTimeOffset).HasColumnType("datetimeoffset"); // микросекунды 7 знаков
b.Property(x => x.SomeDateTimeOffset).HasColumnType("datetimeoffset").HasPrecision(8); // микросекунды от 0 до 7 знаков
```

[Date and time data types](https://learn.microsoft.com/en-us/sql/t-sql/functions/date-and-time-data-types-and-functions-transact-sql#DateandTimeDataTypes)

| Тип C#         | Тип MSSQL      |
|----------------|----------------|
| TimeSpan       | time           | 
| DateTime       | date           | 
| DateTime       | datetime       | 
| DateTime       | datetime2      | 
| DateTimeOffset | datetimeoffset | 
