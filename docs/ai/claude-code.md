# Claude Code

Система памяти работает через файлы в   
`/home/zoomall/.claude/projects/-mnt-c-Users-baranov/memory/`   
они лежат на диске и читаются в начале каждой сессии через MEMORY.md.

## Включить statusline в настройках

Файл `~/.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Read(/mnt/d/backend/gm-online-backend/*)"
    ]
  },
  "theme": "dark",
  "statusLine": {
    "type": "command",
    "command": "bash /home/zoomall/.claude/statusline-command.sh"
  }
}
```

#### Создать скрипт

Файл `nano ~/.claude/statusline-command.sh`:

```shell
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
    if [ "$ctx_tokens" -gt 50000 ]; then
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

Что показывает statusline:

| Поле   | Источник в JSON                         | Значение                          |
|--------|-----------------------------------------|-----------------------------------|
| `5h`   | `rate_limits.five_hour.used_percentage` | Лимит за 5 часов                  |
| `week` | `rate_limits.seven_day.used_percentage` | Лимит за 7 дней                   |
| `ctx`  | `context_window.used_percentage`        | Заполненность контекста разговора |

Пример вывода: `ctx 11%(23k) · 5h 74% · week 25%`

#### Отладка

Чтобы посмотреть какой JSON приходит в скрипт, добавь в начало скрипта (после input=$(cat)):

```shell
echo "$input" > /tmp/statusline-debug.json
```

Затем запусти любое сообщение и читай файл: `! cat /tmp/statusline-debug.json`

#### Тест скрипта вручную

```shell
echo '{"cwd":"/home/user","rate_limits":{"five_hour":{"used_percentage":22},"seven_day":{"used_percentage":9}},"context_window":{"used_percentage":5}}' | bash ~/.claude/statusline-command.sh
```
