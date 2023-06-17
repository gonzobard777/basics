# Миграции

Механизм миграций и ручное создание БД через `dbContext.Database.EnsureCreated()` (подробнее см. [Create and Drop APIs](https://learn.microsoft.com/ru-ru/ef/core/managing-schemas/ensure-created)) совместно работают плохо. Если до миграций БД была создана при помощи `EnsureCreated`, то в таком случае самый простой способ перейти к миграциям - это удалить БД и повторно создать ее с помощью миграций.

Источники:

1. [Управление схемами баз данных](https://learn.microsoft.com/ru-ru/ef/core/managing-schemas/) > Миграции

## Подготовка

Инструменты для работы с миграциями:

1. Для Visual Studio - [The Package Manager Console (PMC) tools for Entity Framework Core](https://learn.microsoft.com/ru-ru/ef/core/cli/powershell)
2. Кроссплатформенно - [.NET Core CLI или The command-line interface (CLI) tools for Entity Framework Core](https://learn.microsoft.com/ru-ru/ef/core/cli/dotnet), +требуется пакет `Microsoft.EntityFrameworkCore.Design`

Перед запуском команд **переходят в папку проекта, где лежит DbContext**.  
Но в папку проекта с DbContext можно не переходить, а задать ее вручную:

```shell
dotnet ef --project Путь_До_Проекта_Где_Лежит_DbContext
```

Может так оказаться, что **настройки для подключения к базе данных** лежат не том проекте, к которому относится DbContext.  
В таком случае надо будет указать путь до проекта с настройками подключения:

```shell
dotnet ef --startup-project Путь_До_Проекта_С_Настройками_Подключения_К_БазеДанных
```

Можно задать **среду исполнения**:

```shell
dotnet ef database update -- --environment Production
```

Маркер `--` указывает рассматривать все последующие `dotnet ef` как аргументы, а не пытаться проанализировать их как параметры. Все дополнительные аргументы, не используемые `dotnet ef`, перенаправляются в приложение.

## Команды

Добавляет миграцию, но не коммитит:

```shell
dotnet ef migrations add Initial
```

