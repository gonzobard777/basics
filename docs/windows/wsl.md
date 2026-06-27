# wsl

## Команды

| Команда                    | Описание                                                             |
|----------------------------|----------------------------------------------------------------------|
| `wsl --update`             | Обновление подсистемы Windows для Linux                              |
| `wsl -l -v`                | Показать список установленных дистрибутивов                          |
| `wsl --set-default Ubuntu` | Установить Ubuntu как дистрибутив по умолчанию                       |
| `wsl -d Ubuntu`            | Запустить дистрибутив Ubuntu                                         |
| `wsl --unregister Ubuntu`  | Удаляет виртуальную машину с данными, но не удаляет сам пакет Ubuntu |
| `winget uninstall Ubuntu`  | Удаляет пакет Ubuntu                                                 |
| `wsl --install -d Ubuntu`  | Установить дистрибутив Ubuntu в WSL                                  |
| `wsl --shutdown`           | Остановить все запущенные дистрибутивы                               |

```shell
wsl --list --online          # что доступно для установки

wsl --install -d Ubuntu 26.04
```

## Несколько независимых Ubuntu на Windows

Да, можно — и это штатный сценарий WSL.   
На одной Windows может жить сколько угодно **независимых** Ubuntu-инсталляций: у каждой свой диск (`ext4.vhdx`), свои пакеты, пользователи, домашние каталоги.   
Общий у них только ядро WSL2 (одна виртуальная машина-хост).

### Способ 1. Разные именованные дистрибутивы из каталога

```powershell
wsl --list --online          # что доступно для установки
wsl --install -d Ubuntu-22.04
wsl --install -d Ubuntu-24.04
```

Минус: так можно поставить только **разные версии** (22.04, 24.04, …).   
Два экземпляра *одной и той же* версии этим способом не сделать — второй раз та же команда просто запустит уже установленный.

### Способ 2. Несколько копий ОДНОЙ Ubuntu (export/import)

Это правильный путь, если нужно, например, две независимые песочницы Ubuntu 24.04 — `dev` и `test`.

```powershell
# один раз поставить базовую
wsl --install -d Ubuntu-24.04

# выгрузить её в tar
wsl --export Ubuntu-24.04 D:\WSL\base.tar

# импортировать сколько нужно копий под своими именами
wsl --import ubuntu-dev  D:\WSL\dev  D:\WSL\base.tar
wsl --import ubuntu-test D:\WSL\test D:\WSL\base.tar
```

Запуск конкретного экземпляра:

```powershell
wsl -d ubuntu-dev
wsl -d ubuntu-test
```

Каждый каталог (`D:\WSL\dev`, `…\test`) содержит **отдельный** `ext4.vhdx` — это и есть изоляция.

### Способ 3 (новый WSL, версия ≥ 2.4.4). Импорт прямо из tar/rootfs

Можно ставить из rootfs-тарбола без возни с export:

```powershell
wsl --install --from-file ubuntu.tar.gz --name ubuntu-dev2 --location D:\WSL\dev2
```

### Полезное при работе с несколькими

```powershell
wsl --list --verbose          # все экземпляры + статус + версия WSL
wsl --set-default ubuntu-dev  # какой запускается по голому `wsl`
wsl --unregister ubuntu-test  # удалить экземпляр (СНОСИТ его vhdx!)
wsl --terminate ubuntu-dev    # остановить, не удаляя
```

### На что обратить внимание

- **`import` не задаёт дефолтного пользователя** — войдёшь под `root`. Чтобы по умолчанию входил обычный юзер, либо создай `/etc/wsl.conf` с `[user] default=имя`, либо запускай `wsl -d ubuntu-dev -u имя`.
- Имя экземпляра (`ubuntu-dev`) — это идентификатор для `wsl -d`, оно не обязано совпадать с версией дистрибутива.
- Изоляция касается ФС и пакетов, но **ядро и сеть общие** — все экземпляры видят одни и те же проброшенные порты/`localhost`.
- Размести `--location` на быстром диске (SSD), где есть место — `vhdx` растёт по мере использования.

### Как узнать, где лежит vhdx

У каждого дистрибутива WSL хранит путь к его папке в реестре (поле `BasePath`), а сам файл диска лежит как `BasePath\ext4.vhdx`.

Команда ниже выводит **имя дистрибутива, размер диска и полный путь** к `ext4.vhdx`:

```powershell
Get-ChildItem HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss |
  ForEach-Object {
    $name = $_.GetValue("DistributionName")
    $path = ($_.GetValue("BasePath") -replace '^\\\\\?\\','') + '\ext4.vhdx'
    $size = (Get-Item $path).Length / 1GB
    "{0,-22} | {1,8:N2} GB | {2}" -f $name, $size, $path
  }
```

Пример вывода:

```text
Ubuntu-24.04           |     3,57 GB | C:\Users\FatPinkRabbit\AppData\Local\wsl\{1f59335f-…}\ext4.vhdx
Ubuntu                 |     9,07 GB | C:\Users\FatPinkRabbit\AppData\Local\wsl\{256e017c-…}\ext4.vhdx
docker-desktop         |     0,10 GB | D:\DockerDesktopWSL\main\ext4.vhdx
```

Что делает каждая строка:

- `Get-ChildItem …Lxss |` — перебираем все записи WSL-дистрибутивов в реестре (`|` в конце = продолжение на следующих строках).
- `$name` — имя дистрибутива.
- `$path` — берём `BasePath`, срезаем служебный префикс `\\?\` и дописываем `\ext4.vhdx` → полный путь к файлу диска.
- `$size` — размер этого файла в гигабайтах.
- последняя строка собирает всё в одну: `{0,-22}` — имя (ширина 22, влево), `{1,8:N2}` — размер (ширина 8, 2 знака), `{2}` — путь; `|` между ними — просто разделитель.

#### Где лежит по умолчанию

- **Установлен из Store / `wsl --install`** → в профиле пользователя. В новом WSL это `%LOCALAPPDATA%\wsl\{GUID}\ext4.vhdx`, в старом — `%LOCALAPPDATA%\Packages\<PackageFamilyName>\LocalState\ext4.vhdx`.
- **Через `wsl --import`** → ровно там, где указан `--location`.

> Поэтому простой рекурсивный поиск `ext4.vhdx` по диску часто не находит дистрибутив: файл лежит в `AppData`, который `-ErrorAction SilentlyContinue` молча пропускает по правам. Реестр (`Lxss`) — авторитетный источник.

### Перенос диска на другой раздел

Если `vhdx` вырос и системный `C:` забит — диск можно перенести на другой раздел (например, на SSD `D:`).

**Чистый способ (новый WSL, ≥ 2.0):** WSL сам перенесёт файл и обновит `BasePath` в реестре, имя и данные сохранятся.

```powershell
wsl --shutdown
wsl --manage Ubuntu-24.04 --move D:\WSL\Ubuntu-24.04
```

**Если `--manage --move` нет (старый WSL)** — через export/import:

```powershell
wsl --shutdown
wsl --export Ubuntu-24.04 D:\WSL\u24.tar
wsl --unregister Ubuntu-24.04
wsl --import Ubuntu-24.04 D:\WSL\Ubuntu-24.04 D:\WSL\u24.tar
```

> Минус второго пути — сбросится дефолтный пользователь (войдёшь под `root`). Чинится через `/etc/wsl.conf` с `[user] default=имя`.
