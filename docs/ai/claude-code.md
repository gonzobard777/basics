# Claude Code

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

Файл `~/.claude/statusline-command.sh`:

```shell
#!/bin/bash
input=$(cat)

read cwd session_pct week_pct ctx_pct <<< $(echo "$input" | /usr/bin/python3 -c "
import sys, json
d = json.load(sys.stdin)
cwd = d.get('cwd', '')
sess = d.get('rate_limits', {}).get('five_hour', {}).get('used_percentage')
week = d.get('rate_limits', {}).get('seven_day', {}).get('used_percentage')
ctx  = d.get('context_window', {}).get('used_percentage')
print(cwd,
      '' if sess is None else str(round(sess)),
      '' if week is None else str(round(week)),
      '' if ctx  is None else str(round(ctx)))
")

metrics=""
[ -n "$session_pct" ] && metrics="${metrics} 5h:${session_pct}%"
[ -n "$week_pct" ]    && metrics="${metrics} week:${week_pct}%"
[ -n "$ctx_pct" ]     && metrics="${metrics} ctx:${ctx_pct}%"
metrics="${metrics# }"

printf "%s" "$metrics"
```

Что показывает statusline:

| Поле   | Источник в JSON                         | Значение                          |
|--------|-----------------------------------------|-----------------------------------|
| `5h`   | `rate_limits.five_hour.used_percentage` | Лимит за 5 часов                  |
| `week` | `rate_limits.seven_day.used_percentage` | Лимит за 7 дней                   |
| `ctx`  | `context_window.used_percentage`        | Заполненность контекста разговора |

Пример вывода: `5h:30% week:10% ctx:26%`

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
