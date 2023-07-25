# Инициализировать язык из запроса

[learn.microsoft - Configure Localization middleware](https://learn.microsoft.com/ru/aspnet/core/fundamentals/localization/select-language-culture#configure-localization-middleware)  
[Writing a custom request culture provider in ASP.NET Core 2.1](https://ml-software.ch/posts/writing-a-custom-request-culture-provider-in-asp-net-core-2-1)

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
            options.RequestCultureProviders.Add(new CustomRequestCultureProvider(async httpContext =>
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

В моем случае язык приходит в каждом запросе в заголовке "lang":

```csharp
public class CustomRequestCultureProvider : RequestCultureProvider
{
    public override Task<ProviderCultureResult?> DetermineProviderCultureResult(HttpContext httpContext)
    {
        httpContext.Request.Headers.TryGetValue("lang", out var headerValue);
        var culture = Lang.DefaultCulture;
        if (headerValue == Lang.En)
            culture = Lang.En;
        Tr.CurrentLang = culture;
        return Task.FromResult(new ProviderCultureResult(culture));
    }
}
```
