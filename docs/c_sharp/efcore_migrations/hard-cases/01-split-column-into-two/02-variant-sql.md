# Разделение одной колонки на две колонки (через SQL)

Например, вот такой запрос

```sql
SELECT
    a."Id" as id,
    split_part("FullName", ' ' , 1) as first_name,
    split_part("FullName", ' ' , 2) as last_name
FROM "Authors" as a
```

Разделяет `FullName` на значения:

| id  | first_name | last_name |
|-----|------------|-----------|
| 1   | Стивен     | Кинг      |
| 2   | Ян         | Флеминг   |

И **средствами SQL** эти значения надо будет засунуть в колонки `FirstName` и `LastName`

---

Потому что:

[Migrating Data as Part of Database Migration](https://stackoverflow.com/questions/54181958/migrating-data-as-part-of-database-migration#comment-95193172)
> The whole work should be done in the sql string passed to the Sql method. As I mentioned, it doesn't need to be a single select. You can use all SQL block constructs - cursors, (temporary) table variables etc.

[Read database during an entity framework migration (select query)](https://stackoverflow.com/questions/38609213/read-database-during-an-entity-framework-migration-select-query#answer-38613538)
> The problem by data reading! In reality you will never need to handle the data tranformation in C#, normally you create everything in SQL server (Stored procedure and functions and SQL stametents) and you can just call them from the migration file at the time point when you need them or when the data are ready to be trasformed.

[EF Core - Get select query results while migrating](https://stackoverflow.com/questions/75234976/ef-core-get-select-query-results-while-migrating#answer-75241145)
> Migrations are translated to Sql code upon migration. There is a method called migrationBuilder.Sql() and has the option to be executed inside the transaction so if the sql fails, transaction is rolled back.
