# Разделение одной колонки на две колонки (через DbContext)

#### 1. Миграция - Initial

Состояние до внесения изменений.

- Создать миграцию.
- Применить к БД.

#### 2. Миграция - EntityAuthorAddedFieldsFirstNameAndLastName

- **Добавить колонки** `FirstName` и `LastName`.
- Создать миграцию.
- Применить к БД.

#### 3. Миграция - EntityAuthorMoveDataFromFullNameToFirstNameAndLastName

Прямое действие - **Перенести данные** из колонки `FullName` в колонки `FirstName` и `LastName`.
Обратное действие - сделать пустым значение колонок `FirstName` и `LastName`.

Не внося изменений в код, добавить новую миграцию - методы Up и Down должны быть пустыми.  
Добавить код в миграцию:

```shell
protected override void Up(MigrationBuilder migrationBuilder)
{
    using (var context = new AppDbContext())
    {
        var authors = context.Authors.ToList();
        foreach (var author in authors)
        {
            var fullName = author.GetType().GetProperty("FullName").GetValue(author, null) as string;
            var arr = fullName.Split(new char[0]); // разделяю FullName на FirstName и LastName 
            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: author.Id,
                columns: new[] { "FirstName", "LastName" },
                values: new[]{ arr[0], arr[1]}); // заполняю соответствующие колонки
        }
    }
}

protected override void Down(MigrationBuilder migrationBuilder)
{
    using (var context = new AppDbContext())
    {
        var authors = context.Authors.ToList();
        foreach (var author in authors)
        {
            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: author.Id,
                columns: new[] { "FirstName", "LastName" },
                values: new[]{ "", ""}); // делаю значение колонок пустым
        }
    }
}
```

- Применить к БД.

#### 4. Миграция - EntityAuthorFillBackFieldFullName

У данной миграции только **обратное действие - заполнить `FullName`** значениями из колонок `FirstName` и `LastName`.

Не внося изменений в код, добавить новую миграцию - методы Up и Down должны быть пустыми.  
Добавить код в миграцию:

```shell
protected override void Down(MigrationBuilder migrationBuilder)
{
    using (var context = new AppDbContext())
    {
        var authors = context.Authors.ToList();
        foreach (var author in authors)
        {
            var firstName = author.GetType().GetProperty("FirstName").GetValue(author, null) as string;
            var lastName = author.GetType().GetProperty("LastName").GetValue(author, null) as string;
            migrationBuilder.UpdateData(
                table: "Authors",
                keyColumn: "Id",
                keyValue: author.Id,
                column: "FullName",
                value: firstName + " " + lastName); // возвращаю значение в FullName 
        }
    }
}
```

#### 5. Миграция - EntityAuthorDeletedFieldFullName

- **Удалить колонку** `FullName`.
- Создать миграцию.
- Применить к БД.
