# Локализация

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
