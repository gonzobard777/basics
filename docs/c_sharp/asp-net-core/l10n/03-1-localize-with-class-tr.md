# Локализировать при помощи класса Tr

Идея взята отсюда: [Локализация приложения c#. Стандартный и нестандартный способы](https://www.youtube.com/watch?v=8_0KnhO6mcM).

Перечисление языков:

```csharp
public class Lang
{
    public static string Ru => "ru";
    public static string En => "en";
}
```

По приходу нового запроса сохраняем текущий яык, заполняя свойство `Tr.CurrentLang`, см. `CustomRequestCultureProvider`.

## Создание локализаций

`Tr.cs`

```csharp
public partial class Tr
{
    public static string CurrentLang { get; set; }

    public static string GetStr(string ruStr, string enStr) =>
        CurrentLang == Lang.En ? enStr : ruStr;

    public static string NotFound(string title) => GetStr(
        $"{title} отсутствует", // не найдено
        $"{title} not found"
    );

    public static string InvalidRequest => GetStr(
        "Некорректный запрос",
        "Invalid request"
    );
}
```

Можно класс Tr обозначить как **partial**, разбить его на несколько файлов. Файлы назвать по признаку, например: Tr.Buttons, Tr.Labels - или иным подобным образом.

`Tr.WorkplaceType.cs`

```csharp
public partial class Tr
{
    public static class WorkplaceType
    {
        public static string NotFound => GetStr(
            NotFound("Тип рабочего места"),
            NotFound("Workplace type")
        );

        public static string NotFoundById(int id) => GetStr(
            NotFound($"Тип рабочего места id={id}"),
            NotFound($"Workplace type id={id}")
        );

        public static string CannotBeDeleted(int workplaceCount) => GetStr(
            $"Нельзя удалить. Используется в ({workplaceCount}) рабочих мест",
            $"Cannot be deleted. Used in ({workplaceCount}) workplaces"
        );
    }
}
```

## Использование

```csharp
throw new Exception(Tr.InvalidRequest);
throw new Exception(Tr.WorkplaceType.NotFound);
throw new Exception(Tr.WorkplaceType.NotFoundById(fromId));
throw new Exception(Tr.WorkplaceType.CannotBeDeleted(workplaceType.Workplaces.Count));
```
