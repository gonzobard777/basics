# Вспомогательные программы C#

## Декомпилятор C# (DLL → читаемый C#)

ILSpy CLI (`ilspycmd`) — выдаёт **настоящий C#**, а не IL.   
Работает на Linux/WSL, из зависимостей нужен только .NET SDK.   
Движок тот же, что в ILSpy/dotPeek (ICSharpCode.Decompiler).

### 1. .NET SDK (текущая LTS)

Имя пакета зависит от версии Ubuntu.   
Сначала посмотри, что вообще есть в apt (sudo не нужен):

```shell
apt-cache search '^dotnet-sdk'
```

Поставь найденную версию. В Ubuntu 26.04 это `dotnet-sdk-10.0` (.NET 10 — текущая LTS); в 22.04/24.04 может быть `dotnet-sdk-8.0`:

```shell
sudo apt-get update && sudo apt-get install -y dotnet-sdk-10.0
```

Если apt не находит ни одного пакета — официальный скрипт (ставит в `~/.dotnet`, без sudo; PATH — в шаге 3):

```shell
curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel LTS
```

### 2. ILSpy CLI — сам декомпилятор

```shell
dotnet tool install -g ilspycmd
```

### 3. PATH для глобальных tools

Два варианта — по тому, кто будет звать tool.

**Неинтерактивный шелл** (скрипт / CI / ИИ-агент) rc-файлы НЕ читает — для него симлинк в системный PATH (один раз, sudo):

```shell
sudo ln -sf ~/.dotnet/tools/ilspycmd /usr/local/bin/ilspycmd
```

**Свой терминал** — дописать в `~/.bashrc` и `~/.profile`, идемпотентно (дубль не создаётся):

```shell
LINE='export PATH="$HOME/.dotnet:$HOME/.dotnet/tools:$PATH"'
for f in ~/.bashrc ~/.profile; do grep -qxF "$LINE" "$f" 2>/dev/null || echo "$LINE" >> "$f"; done
source ~/.profile
```

### 4. Проверка, что взлетело

```shell
dotnet --version && ilspycmd --version
```

---

### Использование

DLL обычно лежат в NuGet-кеше или в `bin` проекта:

- NuGet-кеш: `~/.nuget/packages/<пакет>/<версия>/lib/<tfm>/*.dll`
  (в WSL Windows-кеш: `/mnt/c/Users/<имя>/.nuget/packages/<пакет>/<версия>/lib/<tfm>/*.dll`)
- сборка проекта: `.../bin/Debug/<tfm>/*.dll`

**Один тип целиком, в stdout** (`-t` — полное имя с namespace):

```shell
ilspycmd -t Namespace.TypeName path/to/Lib.dll
```

**Вся сборка → компилируемый проект** (по файлу на тип; `-p` требует `-o`):

```shell
ilspycmd -p -o ./out path/to/Lib.dll
```

**Список типов в сборке** (валидные: `c`-класс, `i`-интерфейс, `s`-структура, `d`-делегат, `e`-enum):

```shell
ilspycmd -l c,i,s,e path/to/Lib.dll
```

**Прочее:** `-il` — показать IL вместо C#; `-lv CSharp12_0` — зафиксировать версию языка вывода; `--list-resources` / `--resource <name>` — вытащить встроенные ресурсы; `-genpdb` — сгенерировать PDB.

> Если не знаешь, в какой DLL лежит нужный тип — выгрузи всю сборку через `-p -o ./out`, затем `grep -rl "class TypeName" ./out`.
