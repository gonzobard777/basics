# Model Binding - Привязка модели

[Пользовательская привязка модели в ASP.NET Core](https://learn.microsoft.com/ru-ru/aspnet/core/mvc/advanced/custom-model-binding?view=aspnetcore-7.0)  
[Создание привязчика модели - Metanit](https://metanit.com/sharp/aspnet5/8.6.php)

Самописный маппер можно привязать непосредственно в методе контроллера:

```csharp
[HttpGet]
public async Task<ActionResult<PagedResult<T>>> List(
    [ModelBinder(BinderType = typeof(ListQueryParamsBinder), Name = "ListQueryParams")]
    ListQueryParams queryParams
)
{
    return Ok(await Service.List(queryParams));
}
```

а можно прямо на модели:

```csharp
[ModelBinder(BinderType = typeof(ListQueryParamsBinder), Name = "ListQueryParams")]
public class ListQueryParams {
  ...
}
```

Пример маппера:

```csharp
public class ListQueryParamsBinder : IModelBinder
{
    public Task BindModelAsync(ModelBindingContext bindingContext)
    {
        if (bindingContext == null)
            throw new ArgumentNullException(nameof(bindingContext));

        var obj = new ListQueryParams();

        /*
         * Фильтры.
         */
        SetValue("Search", obj, bindingContext);
        SetValueAfterParse<int>("CompanyId", obj, bindingContext);
        SetValueAfterParse<int>("LicenseId", obj, bindingContext);
        SetValueAfterParse<int>("WorkplaceId", obj, bindingContext);
        SetValueAfterParse<int>("WorkScheduleId", obj, bindingContext);

        /*
        * Сортировка.
        */
        SetValue("SortBy", obj, bindingContext);
        if (!SetValueAfterParse<bool>("Desc", obj, bindingContext))
            obj.Desc = false;

        /*
         * Пагинация.
         */
        if (!SetValueAfterParse<int>("Skip", obj, bindingContext))
            obj.Skip = 0;
        if (!SetValueAfterParse<int>("Take", obj, bindingContext))
            obj.Take = 20;


        if (bindingContext.ModelState.ErrorCount > 0)
            return Task.CompletedTask;

        bindingContext.Result = ModelBindingResult.Success(obj);
        return Task.CompletedTask;
    }

    public static void SetValue(string propName, ListQueryParams obj, ModelBindingContext bindingContext)
    {
        var propInfo = obj.GetType().GetProperty(propName);
        if (propInfo is null)
            throw new ArgumentException($"Unknown parameter '{propName}'");

        var valueProvider = bindingContext.ValueProvider.GetValue(propName);
        if (valueProvider != ValueProviderResult.None)
            propInfo.SetValue(obj, valueProvider.FirstValue);
    }

    public static bool SetValueAfterParse<T>(string propName, ListQueryParams obj, ModelBindingContext bindingContext)
    {
        var propInfo = obj.GetType().GetProperty(propName);
        if (propInfo is null)
            throw new ArgumentException($"Unknown parameter '{propName}'");

        var valueProvider = bindingContext.ValueProvider.GetValue(propName);
        if (valueProvider != ValueProviderResult.None)
        {
            object parsed;
            try
            {
                parsed = TypeDescriptor
                    .GetConverter(typeof(T))
                    .ConvertFromString(valueProvider.FirstValue);

                propInfo.SetValue(obj, parsed);
                return true;
            }
            catch (Exception e)
            {
                bindingContext.ModelState.TryAddModelError(bindingContext.ModelName, $"Parsing '{propName}'. ${e.Message}");
            }
        }

        return false;
    }
}
```
