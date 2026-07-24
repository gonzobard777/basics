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

# запускаем инсталлер — версия уже на месте, он должен пропустить
# загрузку и просто доделать настройку (launcher, shell integration).
# Если что-то пойдёт не так — не страшно, ручная установка выше уже рабочая.
if ! "$out" install stable; then
    echo ""
    echo "Инсталлер завершился с ошибкой, но ручная установка уже сделана." >&2
fi

# проверка
export PATH="$HOME/.local/bin:$PATH"
echo ""
echo "Проверка: $(claude --version)"
echo "Если версия видна выше — всё готово. Убедитесь, что ~/.local/bin в PATH (добавьте в ~/.bashrc):"
echo '  export PATH="$HOME/.local/bin:$PATH"'
```

запустить:

```shell
bash ~/install-claude.sh
```
