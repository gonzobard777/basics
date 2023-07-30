# DateTime

[ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)

- [Потеря Kind при сохранении в БД](./kind-set-on-reading-from-db.md)
- Конвертации .NET <-> Database:
  - [MSSQL. time, date, datetime, datetime2, datetimeoffset](mssql-time-date-datime-datime2-datetimeoffset.md)
  - [PostgreSQL. time, date, timestamp, timestamptz, interval](postgresql-time-date-timestamp-timestamptz-interval.md)
- Duration
  - [Iso8601DurationHelper](https://www.nuget.org/packages/Iso8601DurationHelper)
  - [Microsoft.Graph.Duration](https://learn.microsoft.com/en-us/dotnet/api/microsoft.graph.duration)
  - [Noda Time](https://stackoverflow.com/questions/74155954/how-can-i-parse-iso-8601s-pndtnhnmn-ns-format-in-c-net#answer-74156166)

## Time Zone

Оба, и MSSQL и PostgreSQL, дают возможность сохранить **смещение относительно UTC**.  
Но этого **недостаточно** для точной работы с временными зонами, которые обозначаются строковыми идентификаторами - [TZ identifier](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).  
Пример работы с временными зонами: [When “UTC everywhere” isn’t enough - storing time zones in PostgreSQL and SQL Server](https://www.roji.org/storing-timezones-in-the-db) 
