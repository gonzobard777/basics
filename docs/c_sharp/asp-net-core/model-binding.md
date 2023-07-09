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

    private static void SetValue(string propName, ListQueryParams obj, ModelBindingContext bindingContext)
    {
        var propInfo = GetPropInfo(propName, obj);
        var valueProvider = bindingContext.ValueProvider.GetValue(propName);
        if (valueProvider != ValueProviderResult.None)
            propInfo.SetValue(obj, valueProvider.FirstValue);
    }

    private static bool SetValueAfterParse<TProp>(string propName, ListQueryParams obj, ModelBindingContext bindingContext)
    {
        var propInfo = GetPropInfo(propName, obj);
        var valueProvider = bindingContext.ValueProvider.GetValue(propName);
        if (valueProvider != ValueProviderResult.None)
        {
            try
            {
                var parsed = TypeDescriptor
                    .GetConverter(typeof(TProp))
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

    private static PropertyInfo GetPropInfo(string propName, object obj)
    {
        var propInfo = obj.GetType().GetProperty(propName);
        if (propInfo is null)
            throw new ArgumentException($"Parsing. Unknown parameter '{propName}'");
        return propInfo;
    }
}
```
