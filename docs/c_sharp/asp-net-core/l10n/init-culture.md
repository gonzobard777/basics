# Инициализация culture

[learn.microsoft - Configure Localization middleware](https://learn.microsoft.com/ru/aspnet/core/fundamentals/localization/select-language-culture#configure-localization-middleware)  
[Writing a custom request culture provider in ASP.NET Core 2.1](https://ml-software.ch/posts/writing-a-custom-request-culture-provider-in-asp-net-core-2-1)  
[metanit - RequestLocalizationMiddleware](https://metanit.com/sharp/aspnet5/28.2.php)

Вообще, идея инициализации культуры состоит в следующем:

```csharp
var culture = new CultureInfo("ru");
Thread.CurrentThread.CurrentCulture = culture;
Thread.CurrentThread.CurrentUICulture = culture;
```

Можно еще вот такую инициализацию встретить:

```csharp
var culture = new CultureInfo("ru");
CultureInfo.CurrentCulture = culture;
CultureInfo.CurrentUICulture = culture;
```

Для ASP.NET Core можно использовать такой подход:

```csharp
public class Startup
{
    public IServiceProvider ConfigureServices(IServiceCollection services)
    {
        services.Configure<RequestLocalizationOptions>(options =>
        {
            options.SetDefaultCulture(Lang.Default)
                .AddSupportedCultures(Lang.Supported)
                .AddSupportedUICultures(Lang.Supported);
            options.RequestCultureProviders.Clear(); // не используются встроенные провайдеры для определения культуры 
            options.AddInitialRequestCultureProvider(new CustomRequestCultureProvider(async httpContext =>
            {
                httpContext.Request.Headers.TryGetValue("lang", out var headerValue);
                Lang.SetCurrent(headerValue);
                return new ProviderCultureResult(Lang.Current);
            }));
        });

        return serviceProvider;
    }

    public void Configure(IApplicationBuilder app, IWebHostEnvironment _)
    {
        app.UseRequestLocalization();
    }
}
```

В примере выше провайдер `CustomRequestCultureProvider` используется из пакета `Microsoft.AspNetCore.Localization`, но его можно создать и своми силами:

```csharp
public class CustomRequestCultureProvider : RequestCultureProvider
{
    public override Task<ProviderCultureResult?> DetermineProviderCultureResult(HttpContext httpContext)
    {
        httpContext.Request.Headers.TryGetValue("lang", out var headerValue);
        Lang.SetCurrent(headerValue);
        return new ProviderCultureResult(Lang.Current);
    }
}
```
