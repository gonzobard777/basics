# Инициализировать язык из запроса

Иточник: [Writing a custom request culture provider in ASP.NET Core 2.1](https://ml-software.ch/posts/writing-a-custom-request-culture-provider-in-asp-net-core-2-1)

```csharp
public class Startup
{
    public IServiceProvider ConfigureServices(IServiceCollection services)
    {
        services.Configure<RequestLocalizationOptions>(options =>
        {
            var supportedCultures = new[] { new CultureInfo("ru"), new CultureInfo("en") };
            options.SupportedCultures = supportedCultures;
            options.SupportedUICultures = supportedCultures;
            options.DefaultRequestCulture = new RequestCulture(culture: "ru", uiCulture: "ru");
            options.RequestCultureProviders.Clear(); // Clears all the default culture providers from the list
            options.RequestCultureProviders.Add(new CustomRequestCultureProvider()); // Add your custom culture provider back to the list
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
        httpContext.Request.Headers.TryGetValue("lang", out var fromReq);
        var lang = Lang.Ru;
        if (fromReq == Lang.En)
            lang = Lang.En;
        Tr.CurrentLang = lang;
        return Task.FromResult(new ProviderCultureResult(lang));
    }
}
```
