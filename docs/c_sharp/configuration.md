# Конфигурация

Лок. Глава 11. Конфигурирование приложения ASP.NET Core  
Как работать с механизмом секретов: [Securing Sensitive Information with .NET User Secrets](https://blog.jetbrains.com/dotnet/2023/01/17/securing-sensitive-information-with-net-user-secrets/)

# Последовательность загрузки настроек

```
appsettings.json                   // optional, reloadOnChange
appsettings.{EnvironmentName}.json // optional, reloadOnChange
секреты
переменные окружения
из командной строки, переданные при запуске
```

# Получить значение

Все загруженные значения **без вложенности** из всех провайдеров:

```csharp
Configuration.Get<Dictionary<string, string>>();
```

Объекты с вложенностью получать так:

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "applicationName": "MyApp",
  "AllowedHosts": "*"
}
```

```csharp
Configuration["Logging:LogLevel:Default"];
Configuration.GetSection("Logging")["LogLevel:Default"];
Configuration.GetValue<object>("Logging:LogLevel:Default123", "Если нет значения");
```

## Создание конфигурации

Поставить пакет:

```
Microsoft.Extensions.Configuration
Microsoft.Extensions.Configuration.Abstractions // или этого одного достаточно...
```

```csharp
var builder = new ConfigurationBuilder()
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json", true, false);
    
IConfiguration configuration = builder.Build();
```
