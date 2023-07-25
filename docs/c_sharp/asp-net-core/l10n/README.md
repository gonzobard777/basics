# Локализация

Общие требования к локализации:

1. На этапе компиляции:
   - контроль отсутствующих ключей перевода, использованных в коде
   - контроль лишних ключей в каком-то из файлов локализаций
   - контроль расхождения в составе ключей между файлами локализаций
2. Возможность отдать на перевод в простом формате.
3. Возможность загрузить переводы из простого формата.

Действия:

1. Установить пакет `Microsoft.AspNetCore.Localization`
2. [Инициализировать culture из запроса](./02-init-culture-from-req.md)
3. [Локализировать при помощи класса Tr](./03-localize-with-class-tr.md)
4. [Локализовать средствами шарп](./04-localize-standard-way.md)

Перечисление языков:

```csharp
public class Lang
{
    public static string Ru => "ru";
    public static string En => "en";

    public static readonly string DefaultCulture = Ru;
    public static readonly string[] SupportedCultures = { Ru, En };
}
```

