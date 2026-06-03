# Claude Code

```shell
curl -fsSL https://claude.ai/install.sh | bash

echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
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

## Система памяти

`/home/zoomall/.claude/projects/-mnt-c-Users-baranov/memory/`  
они лежат на диске и читаются в начале каждой сессии через MEMORY.md.  
В частности правила пользователя:  
`/home/zoomall/.claude/projects/-mnt-c-Users-baranov/memory/feedback_general.md`

```json
  Что загружается автоматически при старте сессии:
- Файл MEMORY.md (индекс) — он всегда подгружается в контекст. Там только заголовки и одна строка-подсказка на каждое правило.
- Системные инструкции Claude Code и CLAUDE.md (если есть в проекте).

Что НЕ загружается автоматически: - Содержимое самих файлов правил (feedback_general.md, feedback_commits.md и т. д.). Их я читаю только когда: - вижу по описанию в индексе, что правило релевантно текущей задаче,
- либо ты явно спрашиваешь про память/правила (как сейчас).

Что это значит на практике:
- Краткие хуки в MEMORY.md я вижу всегда, поэтому общее направление («есть правило про пути», «есть правило про коммиты») я знаю с самого начала сессии.
- Точные формулировки и нюансы (Why/How to apply) — подгружаю по необходимости.
- Поэтому не 100% надёжно: если хук в индексе слишком общий, я могу не догадаться открыть нужный файл и пропустить правило. Например, строку [Сложность: X/5] в начале ответа — это правило сидит внутри feedback_general.md, а в индексе про него ни слова. Я
применил его сейчас только потому, что прочитал файл по твоему предыдущему вопросу.

Если хочешь, чтобы какое-то правило срабатывало гарантированно с первой реплики каждой сессии, есть два варианта: 1. Поднять его в MEMORY.md — переписать строку индекса так, чтобы само правило было видно (например: - [Сложность](feedback_general.md) — ставить [Сложность: X/5] в начале каждого ответа).
2. Вынести в CLAUDE.md проекта — этот файл всегда полностью в контексте, не нужно читать отдельно.
```

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
