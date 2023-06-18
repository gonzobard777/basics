# Миграции

Механизм миграций и ручное создание БД через `dbContext.Database.EnsureCreated()` (подробнее см. [Create and Drop APIs](https://learn.microsoft.com/ru-ru/ef/core/managing-schemas/ensure-created)) совместно работают плохо. Если до миграций БД была создана при помощи `EnsureCreated`, то в таком случае самый простой способ перейти к миграциям - это удалить БД и повторно создать ее с помощью миграций.

1. [Подготовка](./01-preparing.md)
2. [Команды](./02-commands.md)

### Ссылки

1. Microsoft

- [Управление схемами баз данных](https://learn.microsoft.com/ru-ru/ef/core/managing-schemas/) > раздел "Миграции"
- [Учебник. Часть 5. Применение миграций к примеру приложения университета Contoso](https://learn.microsoft.com/ru-ru/aspnet/core/data/ef-mvc/migrations?view=aspnetcore-3.1)

2. Смит. Entity Framework Core in Action (2023)

- Глава 5.9. Использование функции миграции в EF Core для изменения структуры базы данных
- Глава 9. Управление миграциями базы данных

3. Лок. ASP.Net Core в действии (2021)

- Глава 12.3. Управление изменениями с помощью миграций

4. Calabonga

- [Миграции в EntityFramework Core](https://www.youtube.com/watch?v=vfHq2ns4RlA)
- [Только факты 3: Перенос данных](https://www.youtube.com/watch?v=NGIiPTKBVsI)

5. Желнин

- [Entity Framework Миграции. Лучшее для развития вашего продукта](https://www.youtube.com/watch?v=RB5J9g_bpsI&list=PL4hR27YmlLPp4dJRBQiFRWXalNXsnvWRq&index=3)

6. Platinum DEV

- [Всё об Entity Framework Core - миграции](https://www.youtube.com/watch?v=eHayUiqBXK4&t=6726s)
