# Инициализировать culture из запроса

[learn.microsoft - Configure Localization middleware](https://learn.microsoft.com/ru/aspnet/core/fundamentals/localization/select-language-culture#configure-localization-middleware)  
[Writing a custom request culture provider in ASP.NET Core 2.1](https://ml-software.ch/posts/writing-a-custom-request-culture-provider-in-asp-net-core-2-1)  
[metanit - RequestLocalizationMiddleware](https://metanit.com/sharp/aspnet5/28.2.php)

Вообще в шарпе идея инициализации культуры состоит в следующем:

```csharp
var ruCulture = new CultureInfo("ru");
Thread.CurrentThread.CurrentCulture = ruCulture;
Thread.CurrentThread.CurrentUICulture = ruCulture;
```

Для ASP.NET Core можно использовать такой подход:

```csharp
public class Startup
{
    public IServiceProvider ConfigureServices(IServiceCollection services)
    {
        services.Configure<RequestLocalizationOptions>(options =>
        {
            options.SetDefaultCulture(Lang.DefaultCulture)
                .AddSupportedCultures(Lang.SupportedCultures)
                .AddSupportedUICultures(Lang.SupportedCultures);
            options.RequestCultureProviders.Clear(); // встроенные провайдеры не используются
            options.AddInitialRequestCultureProvider(new CustomRequestCultureProvider(async httpContext =>
            {
                httpContext.Request.Headers.TryGetValue("lang", out var headerValue);
                var culture = headerValue == Lang.En ? Lang.En : Lang.DefaultCulture;
                return new ProviderCultureResult(culture);
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
        var culture = headerValue == Lang.En ? Lang.En : Lang.DefaultCulture;
        return Task.FromResult(new ProviderCultureResult(culture));
    }
}
```
