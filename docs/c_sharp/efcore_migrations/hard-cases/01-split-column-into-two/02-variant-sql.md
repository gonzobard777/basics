# Разделение одной колонки на две колонки (через SQL)

#### 1. Миграция - Initial

Состояние до внесения изменений.

- Создать миграцию.
- Применить к БД.

#### 2. Миграция - EntityAuthorAddedFieldsFirstNameAndLastNameThenRemoveFullName

- **Добавить колонки** `FirstName` и `LastName`
- **Заполнить их** значениями из колонки `FullName`
- **Удалить колонку** `FullName`

Внимание! Автомиграция может не удалять колонку `FullName`, а переименовать ее скажем в колонку `FirstName`.  
Поэтому надо проверять.  
Вот полный код на **Накат** и **Откат**:

```shell
protected override void Up(MigrationBuilder migrationBuilder)
{
    migrationBuilder.AddColumn<string>(
        name: "FirstName",
        table: "Authors",
        type: "text",
        nullable: false,
        defaultValue: "");
    
    migrationBuilder.AddColumn<string>(
        name: "LastName",
        table: "Authors",
        type: "text",
        nullable: false,
        defaultValue: "");
    
    migrationBuilder.Sql(
        "MERGE INTO \"Authors\" AS t "+
        "USING ("+
        "  SELECT a.\"Id\"                         as id,"+
        "        split_part(\"FullName\", ' ', 1) as first_name,"+
        "        split_part(\"FullName\", ' ', 2) as last_name"+
        "  FROM \"Authors\" as a"+
        "  ) AS s ON s.id = t.\"Id\""+
        "WHEN MATCHED THEN"+
        "	UPDATE SET"+
        "  \"FirstName\" = s.first_name,"+
        "  \"LastName\" = s.last_name;"
    );
    
    migrationBuilder.DropColumn(
        name: "FullName",
        table: "Authors");
}

protected override void Down(MigrationBuilder migrationBuilder)
{
    migrationBuilder.AddColumn<string>(
        name: "FullName",
        table: "Authors",
        type: "text",
        nullable: false,
        defaultValue: "");

    migrationBuilder.Sql(
        "MERGE INTO \"Authors\" AS t "+
        "USING ("+
        "  SELECT a.\"Id\"                         as id,"+
        "         concat(a.\"FirstName\", ' ', a.\"LastName\") as full_name"+
        "  FROM \"Authors\" as a"+
        ") AS s ON s.id = t.\"Id\""+
        "WHEN MATCHED THEN"+
        "	UPDATE SET"+
        "  \"FullName\" = s.full_name"
        );
    
    migrationBuilder.DropColumn(
        name: "FirstName",
        table: "Authors");

    migrationBuilder.DropColumn(
        name: "LastName",
        table: "Authors");
}
```

---

`.Sql(запрос)` не возвращает результат так задумано:

[Migrating Data as Part of Database Migration](https://stackoverflow.com/questions/54181958/migrating-data-as-part-of-database-migration#comment-95193172)
> The whole work should be done in the sql string passed to the Sql method. As I mentioned, it doesn't need to be a single select. You can use all SQL block constructs - cursors, (temporary) table variables etc.

[Read database during an entity framework migration (select query)](https://stackoverflow.com/questions/38609213/read-database-during-an-entity-framework-migration-select-query#answer-38613538)
> The problem by data reading! In reality you will never need to handle the data tranformation in C#, normally you create everything in SQL server (Stored procedure and functions and SQL stametents) and you can just call them from the migration file at the time point when you need them or when the data are ready to be trasformed.

[EF Core - Get select query results while migrating](https://stackoverflow.com/questions/75234976/ef-core-get-select-query-results-while-migrating#answer-75241145)
> Migrations are translated to Sql code upon migration. There is a method called migrationBuilder.Sql() and has the option to be executed inside the transaction so if the sql fails, transaction is rolled back.
