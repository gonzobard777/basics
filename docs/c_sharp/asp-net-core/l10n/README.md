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

Класс для инкапсулирования данных, связанных с языком/локализацией:

```csharp
public class Lang
{
    public const string Ru = "ru";
    public const string En = "en";

    public static readonly string[] Supported = { Ru, En };

    public const string Default = Ru; // Внимание! Изменил значение Default -> поменяй реализацию SetCurrent

    /*
     * Текущий язык лучше хранить здесь и запрашивать отсюда,
     * т.к. если брать язык из CultureInfo.CurrentCulture.Name,
     * то вместо ожидаемого "ru" можно получить "ru-RU"
     */
    public static string Current { get; private set; } = Default;

    public static void SetCurrent(string value) =>
        Current = value switch // язык, заданный в Default, не должен участвовать в case условиях switch
        {
            En => En,
            _ => Default
        };
}
```

