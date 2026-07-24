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

В этом скрипте сразу качается бинарник stable-версии.   
Когда он выполняет `install stable`, запрошенная версия совпадает с его собственной — качать нечего,     
он просто копирует сам себя в `~/.local/share/claude` и прописывает launcher.    
Одно скачивание вместо двух, и оно идёт через `wget -c` без дедлайна и с докачкой.

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

# берём checksum из manifest (заодно проверяем, что платформа там есть)
manifest=$(curl -fsSL "$BASE/$ver/manifest.json")
checksum=$(echo "$manifest" | tr -d ' \n' | grep -o "\"$platform\":{\"checksum\":\"[a-f0-9]\{64\}\"" | grep -o '[a-f0-9]\{64\}')
if [ -z "$checksum" ]; then
    echo "Платформа $platform не найдена в manifest. Доступные:" >&2
    echo "$manifest" | grep -o '"[a-z0-9-]*":{"checksum' | cut -d'"' -f2 >&2
    exit 1
fi

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
"$out" install stable
```

запустить:

```shell
bash ~/install-claude.sh
```
