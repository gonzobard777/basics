# Локализация

[Глобализация и локализация в ASP.NET Core](https://learn.microsoft.com/ru-ru/aspnet/core/fundamentals/localization)  
[Глобализация и локализация приложений .NET](https://learn.microsoft.com/ru-ru/dotnet/core/extensions/globalization-and-localization)  

Общие требования к локализации:

1. На этапе компиляции:
   - контроль **отсутствующих** ключей перевода, использованных в коде
   - контроль **неиспользуемых** ключей в каком-то из файлов локализаций
   - контроль **расхождения в составе** ключей между файлами локализаций
2. Возможность отдать на перевод в простом формате.
3. Возможность загрузить переводы из простого формата.

Действия:

1. Установить пакет `Microsoft.AspNetCore.Localization`
2. [Инициализация culture](./init-culture.md)
3. [Выбрать вариант локализации](https://github.com/gonzobard777/c_sharp_LocalizationCheck)
   - [особенности работы с res-файлами](./features-res-files/README.md)

Перечисление языков:

```csharp
public class Lang
{
    public static string Ru => "ru";
    public static string En => "en";

    public static readonly string Default = Ru; // Не менять! Иначе изменение придется учесть во всех resx-файлах
    public static readonly string[] Supported = { Ru, En };

    public static string Current = Default; // текущий язык лучше хранить здесь и запрашивать отсюда, т.к. из CultureInfo.CurrentCulture.Name вместо ожидаемого "ru" можно получить "ru-RU"
}
```

