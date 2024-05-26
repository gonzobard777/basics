[Пакуем приложения ASP.NET Core с помощью Docker](https://habr.com/ru/companies/microsoft/articles/435914/)  
[Secure your container build and publish with .NET 8](https://devblogs.microsoft.com/dotnet/secure-your-container-build-and-publish-with-dotnet-8/)

[dotnet publish](https://learn.microsoft.com/ru-ru/dotnet/core/tools/dotnet-publish)  
[dotnet build](https://learn.microsoft.com/ru-ru/dotnet/core/tools/dotnet-build)  
[Publish .NET apps with the .NET CLI](https://learn.microsoft.com/en-us/dotnet/core/deploying/deploy-with-cli)

[Understand build configurations](https://learn.microsoft.com/en-us/visualstudio/ide/understanding-build-configurations)  
[Справочник по MSBuild для проектов пакета SDK для .NET](https://learn.microsoft.com/ru-ru/dotnet/core/project-sdk/msbuild-props#useapphost)

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS publish
ARG BUILD_CONFIGURATION=Debug
WORKDIR /src
COPY ["WebApplication1", "WebApplication1"]
RUN dotnet restore "./WebApplication1/WebApplication1.csproj"
WORKDIR "/src/WebApplication1"
RUN dotnet publish "./WebApplication1.csproj" -c $BUILD_CONFIGURATION -o /app/publish -p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
USER app
EXPOSE 8080
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WebApplication1.dll"]
```

```shell
docker build -f .\WebApplication1\Dockerfile --force-rm --target final --build-arg "BUILD_CONFIGURATION=Release" --tag build:dev .
```

