# Вспомогательные программы C#

### Декомпилятор

**1. .NET SDK 8 (даёт команду dotnet)**

```shell
sudo apt-get update && sudo apt-get install -y dotnet-sdk-10.0
```

Добавь глобальные tools в PATH:

```shell
echo 'export PATH="$HOME/.dotnet/tools:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

Если в твоём дистрибутиве apt его не находит — официальный скрипт без apt:

```shell
curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel 8.0
echo 'export PATH="$HOME/.dotnet:$HOME/.dotnet/tools:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

**2. ILSpy CLI — это и есть декомпилятор (выдаёт настоящий C#, не IL)**

```shell
dotnet tool install -g ilspycmd
```

**3. Проверка, что взлетело**

```shell
dotnet --version && ilspycmd --version
```
