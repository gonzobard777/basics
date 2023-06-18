# Подготовка

Инструменты для работы с миграциями:

1. Для Visual Studio - [The Package Manager Console (PMC) tools for Entity Framework Core](https://learn.microsoft.com/ru-ru/ef/core/cli/powershell)
2. Кроссплатформенно - [.NET Core CLI или The command-line interface (CLI) tools for Entity Framework Core](https://learn.microsoft.com/ru-ru/ef/core/cli/dotnet), +требуется пакет `Microsoft.EntityFrameworkCore.Design`

Перед запуском команд **переходят в папку проекта, где лежит DbContext**.  
Но в папку проекта с DbContext можно не переходить, а задать ее вручную:

```shell
dotnet ef --project Путь_До_Проекта_Где_Лежит_DbContext ТУТ_КОМАНДЫ
```

Может так оказаться, что **настройки для подключения к базе данных** лежат не том проекте, к которому относится DbContext.  
В таком случае надо будет указать путь до проекта с настройками подключения:

```shell
dotnet ef --startup-project Путь_До_Проекта_С_Настройками_Подключения_К_БазеДанных ТУТ_КОМАНДЫ
```

Если несколько контекстов, тогда можно **явно задать имя класса контекста**:

```shell
dotnet ef ТУТ_КОМАНДЫ --context AppDbContext
```

Можно задать **среду исполнения**:

```shell
dotnet ef database update -- --environment Production
```

Маркер `--` указывает рассматривать все последующие `dotnet ef` как аргументы, а не пытаться проанализировать их как параметры. Все дополнительные аргументы, не используемые `dotnet ef`, перенаправляются в приложение.
