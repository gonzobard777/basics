# Установка клода

Стандартная [инструкция](https://code.claude.com/docs/ru/overview#get-started) по установке:

```shell
curl -fsSL https://claude.ai/install.sh | bash -s stable
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

официальный скрипт всегда качает latest — у него самый свежий код инсталлера, и авторы хотят, чтобы установку выполнял именно он.    
Затем этот latest-бинарник выполняет `install stable`, видит, что stable — другая версия (2.1.218 ≠ latest), и качает её вторым заходом.    
Итого два скачивания по ~150-300 МБ, причём второе — встроенным загрузчиком с жёстким дедлайном, который на 1 Мбит/с не проходит.

### Если интернет медленный

```shell
nano ~/install-claude.sh
```

```shell
#!/bin/bash
# Установка Claude Code (native, stable) для медленного интернета.
#
# Официальный инсталлер (curl https://claude.ai/install.sh | bash) качает
# бинарник дважды и со встроенным таймаутом — на медленном канале падает
# с "Download timed out: exceeded the total deadline".
#
# Этот скрипт вместо этого:
#   1. Качает stable-бинарник один раз через wget -c (докачка после обрыва,
#      без таймаута) и сверяет sha256 с manifest.
#   2. Кладёт его в ~/.local/share/claude/versions/<версия> и делает
#      ссылку ~/.local/bin/claude — это уже рабочая установка.
#   3. Запускает штатный `claude install stable` — версия на месте,
#      загрузка пропускается, доделывается только настройка.
#   4. Проверяет PATH (при необходимости дописывает в ~/.bashrc) и что
#      `claude --version` работает.
#
# При обрыве связи просто запустить скрипт снова — докачает с места обрыва.
# Повторный запуск также обновляет Claude Code до текущей stable-версии.
set -e

BASE="https://downloads.claude.ai/claude-code-releases"

# версия stable
ver=$(curl -fsSL "$BASE/stable")
echo "Версия: $ver"

# определяем платформу как в официальном инсталлере
arch=$(uname -m)
case "$arch" in
    x86_64|amd64) arch="x64" ;;
    arm64|aarch64) arch="arm64" ;;
    *) echo "Неподдерживаемая архитектура: $arch" >&2; exit 1 ;;
esac
if ldd /bin/ls 2>&1 | grep -q musl; then
    platform="linux-$arch-musl"
else
    platform="linux-$arch"
fi
echo "Платформа: $platform"

# берём checksum из manifest
manifest=$(curl -fsSL "$BASE/$ver/manifest.json")
checksum=$(echo "$manifest" | tr -d ' \n\t\r' | grep -o "\"$platform\":{[^}]*}" | grep -o '"checksum":"[a-f0-9]\{64\}"' | grep -o '[a-f0-9]\{64\}' || true)
if [ -z "$checksum" ]; then
    echo "Платформа $platform не найдена в manifest. Доступные:" >&2
    echo "$manifest" | grep -o '"[a-z0-9-]*":{' | cut -d'"' -f2 >&2
    exit 1
fi
echo "Checksum из manifest: $checksum"

# качаем с докачкой — при обрыве просто запустить скрипт снова
out="$HOME/claude-$ver-$platform"
wget -c "$BASE/$ver/$platform/claude" -O "$out"

# проверяем хэш
actual=$(sha256sum "$out" | cut -d' ' -f1)
if [ "$actual" != "$checksum" ]; then
    echo "Checksum не совпал — файл повреждён, удалите $out и запустите заново" >&2
    exit 1
fi
echo "Checksum OK"
chmod +x "$out"

# ручная установка: кладём бинарник туда, где его ищет Claude Code
VERSIONS_DIR="$HOME/.local/share/claude/versions"
mkdir -p "$HOME/.local/bin" "$VERSIONS_DIR"
cp "$out" "$VERSIONS_DIR/$ver"
chmod +x "$VERSIONS_DIR/$ver"
ln -sf "$VERSIONS_DIR/$ver" "$HOME/.local/bin/claude"
echo "Бинарник установлен в $VERSIONS_DIR/$ver"

# штатный инсталлер доделывает настройку (загрузку пропустит — версия уже на месте)
if ! "$out" install stable; then
    echo "Инсталлер завершился с ошибкой, но ручная установка уже сделана." >&2
fi

# PATH: если ~/.local/bin не в PATH текущего шелла — дописываем в ~/.bashrc (без дублей)
case ":$PATH:" in
    *":$HOME/.local/bin:"*)
        echo "PATH уже содержит ~/.local/bin" ;;
    *)
        if grep -q '\.local/bin' "$HOME/.bashrc" 2>/dev/null; then
            echo "PATH настроен в ~/.bashrc (подхватится в новом окне терминала)"
        else
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
            echo "Добавил ~/.local/bin в PATH через ~/.bashrc"
        fi ;;
esac

# итоговая проверка
export PATH="$HOME/.local/bin:$PATH"
v=$(claude --version 2>/dev/null || true)
if [ -n "$v" ]; then
    echo ""
    echo "✅ Установка успешна: $v"
    echo "Откройте новое окно терминала и запустите: claude"
else
    echo "❌ claude не запускается — проверьте вывод выше" >&2
    exit 1
fi
```

запустить:

```shell
bash ~/install-claude.sh
```
