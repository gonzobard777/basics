#!/usr/bin/env bash
# install.sh — установщик "auto-in": поиск/просмотр истории команд через
# curses-меню на стрелке вверх (движок на Python + клей на bash для readline).
#
# Файлы:
#   install.sh — этот установщик (клей вшит внутри);
#   auto-in.py         — движок-меню, лежит РЯДОМ с установщиком (копируется при установке).
#
# Что делает:
#   1) проверяет python3 и модуль curses (при нужде доставляет через apt);
#   2) копирует движок auto-in.py -> ~/.local/bin/auto-in.py
#   3) создаёт клей               -> ~/.hist_search.bash
#   4) подключает клей в ~/.bashrc (без дублей) и добавляет ~/.local/bin в PATH.
#
# Идемпотентно: запускать можно сколько угодно раз — файлы перезапишутся
# свежими версиями, строки в ~/.bashrc не продублируются.
#
# Использование (например, после переустановки Ubuntu):
#   bash install.sh
#   exec bash            # подхватить изменения в текущем терминале

set -euo pipefail

say() { printf '==> %s\n' "$*"; }

# Каталог, где лежит этот установщик (рядом ожидается auto-in.py)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- 1. Зависимости -----------------------------------------------------------
if ! command -v python3 >/dev/null 2>&1; then
    say "python3 не найден — ставлю через apt"
    sudo apt update
    sudo apt install -y python3
fi

if ! python3 -c 'import curses' >/dev/null 2>&1; then
    say "Модуль curses недоступен — доустанавливаю python3 через apt"
    sudo apt update
    sudo apt install -y python3
    if ! python3 -c 'import curses' >/dev/null 2>&1; then
        echo "ОШИБКА: модуль curses всё ещё недоступен (обычно входит в python3)." >&2
        exit 1
    fi
fi
say "python3: $(python3 --version 2>&1); модуль curses доступен"

# --- 2. Движок: копируем auto-in.py из папки установщика ----------------------
ENGINE_SRC="$SCRIPT_DIR/auto-in.py"
if [[ ! -f "$ENGINE_SRC" ]]; then
    echo "ОШИБКА: рядом с установщиком нет auto-in.py: $ENGINE_SRC" >&2
    exit 1
fi
mkdir -p "$HOME/.local/bin"
say "Копирую движок: $ENGINE_SRC -> ~/.local/bin/auto-in.py"
cp "$ENGINE_SRC" "$HOME/.local/bin/auto-in.py"
chmod +x "$HOME/.local/bin/auto-in.py"

# --- 3. Клей: ~/.hist_search.bash --------------------------------------------
say "Пишу клей -> ~/.hist_search.bash"
cat > "$HOME/.hist_search.bash" <<'BASHEOF'
# ~/.hist_search.bash — поиск/просмотр истории через curses-меню на стрелке вверх
# Движок-меню: ~/.local/bin/auto-in.py (Python + curses)
# Подключается из ~/.bashrc строкой:  . "$HOME/.hist_search.bash"
#
# Как работает авто-запуск по Enter:
#   bind -x сам по себе не умеет "нажать Enter" за readline. Поэтому стрелка
#   вверх — это макрос из двух шагов:  \C-xU (запустить меню)  +  \C-xE (акцепт).
#   Движок-меню возвращает код:
#       0 — нажат Enter  -> __on_up включает на \C-xE команду accept-line (выполнить)
#       3 — нажат Tab    -> \C-xE = no-op (команда просто подставлена в строку)
#       1 — Esc/отмена   -> \C-xE = no-op, строка не меняется

__HIST_ENGINE="$HOME/.local/bin/auto-in.py"

# Список истории: свежие сверху, без номеров, без дублей
__hist_list() {
    history | tac | sed 's/^[[:space:]]*[0-9][0-9]*[[:space:]]*//' | awk '!seen[$0]++'
}

# Шаг 1 макроса: открыть меню, подставить выбранное, настроить шаг "акцепт"
__on_up() {
    local out rc
    out=$(__hist_list | python3 "$__HIST_ENGINE" "$READLINE_LINE")
    rc=$?
    if [[ -n "$out" ]]; then
        READLINE_LINE="$out"
        READLINE_POINT=${#READLINE_LINE}
    fi
    if [[ $rc -eq 0 ]]; then
        bind '"\C-xE": accept-line'         2>/dev/null   # Enter -> выполнить
    else
        bind '"\C-xE": redraw-current-line' 2>/dev/null   # Tab/Esc -> ничего не запускать
    fi
}

# Привязки только в интерактивном shell
if [[ $- == *i* ]]; then
    bind -x '"\C-xU": __on_up'              2>/dev/null   # шаг 1: меню
    bind    '"\C-xE": redraw-current-line'  2>/dev/null   # шаг 2: по умолчанию no-op
    bind    '"\e[A": "\C-xU\C-xE"'          2>/dev/null   # стрелка вверх = шаг1 + шаг2
    bind    '"\eOA": "\C-xU\C-xE"'          2>/dev/null   # стрелка вверх (application-mode)
fi
BASHEOF

# --- 4. Подключение в ~/.bashrc (без дублей) ---------------------------------
touch "$HOME/.bashrc"
if ! grep -qF '.hist_search.bash' "$HOME/.bashrc"; then
    say "Добавляю подключение в ~/.bashrc"
    {
        printf '\n# auto-in: поиск/просмотр истории на стрелке вверх (Python+curses)\n'
        printf '%s\n' '[ -f "$HOME/.hist_search.bash" ] && . "$HOME/.hist_search.bash"'
    } >> "$HOME/.bashrc"
else
    say "Подключение в ~/.bashrc уже есть — пропускаю"
fi

if ! grep -qF '.local/bin' "$HOME/.bashrc"; then
    say "Добавляю ~/.local/bin в PATH"
    printf '%s\n' 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

say "Готово. Выполните:  exec bash   (или откройте новый терминал)"
