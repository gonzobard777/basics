# Claude Code

1. [Настроить терминал](../windows/windows-terminal/README.md)
2. [Удалить и установить Ubuntu](../windows/wsl.md)
3. [Поставить auto-in](../debian-progs/auto-in/README.md)
4. Назначить прокси:

```shell
nano ~/.bashrc

cd ~

# Добавить переменные
export http_proxy=http://xx.xx.xx.xx:3128
export https_proxy=http://xx.xx.xx.xx:3128
export HTTP_PROXY=http://xx.xx.xx.xx:3128
export HTTPS_PROXY=http://xx.xx.xx.xx:3128

# Применить переменные без перезапуска
source ~/.bashrc
```

Обязательно проверить прокси:

```shell
curl 2ip.ru
xx.xx.xx.xx:3128
```

5. Поставить проги и клод:

```shell
sudo apt update

# Node.js + npm
sudo apt install nodejs npm -y

# Всякие питоновские пакеты
sudo apt install python3-rapidfuzz python3-geopy python3-unidecode python3-numpy python3-pandas python3-scipy python3-shapely python3-pyproj python3-requests python3-openpyxl python3-sklearn python3-matplotlib python3-tqdm pandoc unzip fontconfig

# claude
curl -fsSL https://claude.ai/install.sh | bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

6. Настройки клода:

```shell
nano ~/.claude/settings.json
```

```json
{
  "permissions": {
    "allow": [
      "Read(//mnt/c/**)",
      "Read(//mnt/d/**)",
      "Bash(*)",
      "WebFetch",
      "WebSearch"
    ],
    "defaultMode": "acceptEdits",
    "additionalDirectories": [
      "/mnt/d/gm-online/frontend",
      "/mnt/d/backend",
      "/mnt/d/gm",
      "/mnt/d/ai"
    ]
  },
  "worktree": {
    "baseRef": "fresh"
  },
  "statusLine": {
    "type": "command",
    "command": "bash /home/zoomall/.claude/statusline-command.sh"
  },
  "language": "русский",
  "effortLevel": "xhigh",
  "awaySummaryEnabled": false,
  "autoUpdatesChannel": "latest",
  "skipWorkflowUsageWarning": true,
  "theme": "dark",
  "tui": "fullscreen",
  "verbose": true,
  "preferredNotifChannel": "terminal_bell",
  "terminalProgressBarEnabled": true,
  "remoteControlAtStartup": false,
  "skipAutoPermissionPrompt": true
}
```

```shell
nano ~/.claude/statusline-command.sh


#!/bin/bash
# Читаем JSON от Claude Code из stdin
input=$(cat)

# Парсим нужные поля через Python
IFS='|' read session_pct week_pct ctx_pct ctx_tokens <<< $(echo "$input" | /usr/bin/python3 -c "
import sys, json
d = json.load(sys.stdin)
sess = d.get('rate_limits', {}).get('five_hour', {}).get('used_percentage')
week = d.get('rate_limits', {}).get('seven_day', {}).get('used_percentage')
ctx  = d.get('context_window', {}).get('used_percentage')
cu = d.get('context_window', {}).get('current_usage', {})
ctx_tokens = sum(cu.values()) if cu else None
print('|'.join([
    '' if sess       is None else str(round(sess)),
    '' if week       is None else str(round(week)),
    '' if ctx        is None else str(round(ctx)),
    '' if ctx_tokens is None else str(ctx_tokens),
]), end='')
")

# Собираем массив метрик
parts=()

if [ -n "$ctx_pct" ]; then
  if [ -n "$ctx_tokens" ]; then
    ctx_k=$(( ctx_tokens / 1000 ))
    ctx_val="ctx ${ctx_pct}%(${ctx_k}k)"
    # Бордовый фон + белый текст если контекст > 50k токенов
    if [ "$ctx_tokens" -gt 500000 ]; then
      ctx_val=$'\e[48;2;100;0;20m\e[97m'"${ctx_val}"$'\e[0m'
    fi
    parts+=("$ctx_val")
  else
    # Токены недоступны — показываем только процент
    parts+=("ctx ${ctx_pct}%")
  fi
fi

[ -n "$session_pct" ] && parts+=("5h ${session_pct}%")
[ -n "$week_pct" ]    && parts+=("week ${week_pct}%")

# Соединяем через " · "
result=""
for part in "${parts[@]}"; do
  [ -z "$result" ] && result="$part" || result="${result} · ${part}"
done

printf "%s" "$result"
```

7. Вставка картинок (Если не работает)

**Симптом:** `Ctrl+V` не вставляет картинку из буфера Windows в терминал WSL; запуск `.exe` из WSL падает с `cannot execute binary file: Exec format error`.

**Причина:** при включённом `systemd` (в `wsl.conf` `systemd=true`) служба `systemd-binfmt` при старте затирает регистрацию `WSLInterop` в `binfmt_misc`. Без неё Windows‑бинарники (включая `powershell.exe`, через который пробрасывается буфер) перестают запускаться.

**Проверка состояния:**

```shell
# PID 1 = systemd? и жива ли регистрация WSLInterop
ps -p 1 -o comm=
cat /proc/sys/fs/binfmt_misc/WSLInterop   # "No such file" → регистрация слетела
```

**Починить сейчас (до перезапуска WSL):**

```shell
sudo sh -c 'echo ":WSLInterop:M::MZ::/init:PF" > /proc/sys/fs/binfmt_misc/register'
```

**Закрепить навсегда** (systemd‑binfmt будет восстанавливать при каждом старте — иначе после `wsl --shutdown` баг вернётся):

```shell
sudo sh -c 'echo ":WSLInterop:M::MZ::/init:PF" > /etc/binfmt.d/WSLInterop.conf'
```

**Проверить, что заработало:**

```shell
cat /proc/sys/fs/binfmt_misc/WSLInterop
# ожидаем: enabled / interpreter /init / flags: PF / magic 4d5a
powershell.exe -NoProfile -Command '"ok"'   # теперь .exe запускается из WSL
```

Строка регистрации: `MZ` — сигнатура любого Windows‑`.exe`; `/init` — запускатель WSL; флаги `P` (сохранять argv[0]) + `F` (зафиксировать интерпретатор сразу, иначе не работает из mount‑namespace, как у Claude Code).

**Если `Ctrl+V` всё равно капризничает** — вытащить картинку из буфера в файл через PowerShell и дать Claude путь:

```shell
powershell.exe -NoProfile -STA -Command "Add-Type -AssemblyName System.Windows.Forms,System.Drawing; \$i=[Windows.Forms.Clipboard]::GetImage(); if(\$i){\$i.Save('D:\path\clip.png',[System.Drawing.Imaging.ImageFormat]::Png); 'saved'}else{'no-image'}"
# затем указать Claude путь /mnt/d/path/clip.png
```

## Параметры агента

| Параметр (англ.)                        | Параметр (рус.)                                 | Описание                                                                                                  |
|-----------------------------------------|-------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| Auto-compact                            | Авто-сжатие контекста                           | Когда контекст заполняется, автоматически сжимает историю разговора чтобы освободить место                |
| Show tips                               | Показывать подсказки                            | Отображает полезные подсказки по использованию Claude Code в интерфейсе                                   |
| Reduce motion                           | Уменьшить анимацию                              | Отключает анимации и переходы в интерфейсе, полезно при чувствительности к движению                       |
| Thinking mode                           | Режим размышления                               | Включает extended thinking — Claude думает дольше перед ответом для сложных задач                         |
| Session recap                           | Recap сессии                                    | В начале новой сессии показывает краткое резюме предыдущей                                                |
| Rewind code (checkpoints)               | Откат кода (чекпоинты)                          | Сохраняет чекпоинты изменений кода, позволяет откатиться к предыдущему состоянию                          |
| Verbose output                          | Подробный вывод                                 | Показывает детальные логи внутренних действий и инструментов                                              |
| Terminal progress bar                   | Прогресс-бар в терминале                        | Отображает визуальный индикатор прогресса во время выполнения задач                                       |
| Show turn duration                      | Показывать время ответа                         | Показывает сколько времени заняло формирование каждого ответа                                             |
| Default permission mode                 | Режим разрешений по умолчанию                   | Определяет что Claude может делать без запроса разрешения: Default — спрашивает перед опасными действиями |
| Respect .gitignore in file picker       | Учитывать .gitignore в выборе файлов            | Скрывает файлы из .gitignore когда Claude выбирает файлы для работы                                       |
| Skip the /copy picker                   | Пропускать меню /copy                           | При копировании сразу копирует без показа меню выбора формата                                             |
| Auto-update channel                     | Канал авто-обновлений                           | Определяет откуда получать обновления: latest — всегда последняя стабильная версия                        |
| Theme                                   | Тема оформления                                 | Визуальная тема интерфейса: светлая, тёмная или системная                                                 |
| Local notifications                     | Локальные уведомления                           | Системные уведомления о завершении задач: Auto — решает сам когда уведомлять                              |
| Push when Claude decides                | Уведомлять когда Claude решит                   | Claude сам решает когда отправить push-уведомление, не только по завершению                               |
| Output style                            | Стиль вывода                                    | Формат вывода ответов в терминале                                                                         |
| Language                                | Язык                                            | Язык интерфейса Claude Code                                                                               |
| Editor mode                             | Режим редактора                                 | Режим работы встроенного редактора: normal — стандартный режим                                            |
| Show last response in external editor   | Показывать последний ответ во внешнем редакторе | Открывает последний ответ Claude во внешнем редакторе (vim, vscode и др.)                                 |
| Show PR status footer                   | Показывать статус PR                            | Отображает статус pull request в нижней части экрана во время работы с git                                |
| Model                                   | Модель                                          | Выбор модели Claude: Default — автоматически выбирает рекомендуемую модель                                |
| Auto-connect to IDE (external terminal) | Авто-подключение к IDE                          | Автоматически подключается к IDE когда Claude Code запущен во внешнем терминале                           |
| Claude in Chrome enabled by default     | Claude в Chrome по умолчанию                    | Включает расширение Claude в Chrome для управления браузером по умолчанию                                 |
| Enable Remote Control for all sessions  | Удалённое управление для всех сессий            | Разрешает внешним инструментам (IDE, расширениям) управлять Claude Code удалённо                          |
