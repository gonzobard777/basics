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
    say "Модуль curses недоступен — пробую доустановить стандартную библиотеку python3"
    sudo apt update
    # На Debian/Ubuntu модуль _curses входит в libpython3-stdlib (НЕ в сам пакет
    # python3), поэтому ставим именно её; '|| true' — чтобы дойти до сообщения ниже.
    sudo apt install -y libpython3-stdlib python3 || true
    if ! python3 -c 'import curses' >/dev/null 2>&1; then
        echo "ОШИБКА: модуль curses всё ещё недоступен." >&2
        echo "       На Debian/Ubuntu он входит в пакет libpython3-stdlib (часть стандартной" >&2
        echo "       поставки python3). Убедитесь, что установлен полный python3, а не" >&2
        echo "       урезанный python3-minimal без стандартной библиотеки." >&2
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
# Клей при подключении сам проставит зависимости фичи "общая история между
# вкладками": shopt -s histappend и ignoredups в HISTCONTROL (не затирая ваши
# настройки). Поэтому отдельно править ~/.bashrc под историю не требуется.
say "Пишу клей -> ~/.hist_search.bash (он сам настроит histappend + ignoredups)"
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
#
# Общая история между вкладками (см. README, раздел "Общая история между вкладками"):
#   при выборе команды (Enter) __on_up СРАЗУ дописывает её в ~/.bash_history
#   (history -s + history -a), поэтому новая вкладка видит её наверху мгновенно —
#   даже если выбранная команда долгоживущая (claude, ssh, ...) и ещё выполняется
#   (обычный bash и PROMPT_COMMAND так не умеют: пишут историю лишь когда команда
#   завершилась и вернулось приглашение). А history -n в начале __on_up подтягивает
#   команды, которые успели дописать другие вкладки.
#
#   ЗАВИСИМОСТИ фичи проставляются ниже при подключении клея (а не предполагаются
#   в ~/.bashrc) — аккуратно, не затирая пользовательские значения:
#       shopt -s histappend      — дописывать историю при выходе, а не перезатирать
#                                  (иначе выход одной вкладки затёр бы команды других);
#       HISTCONTROL c ignoredups — чтобы выбранная команда не задвоилась: её добавляет
#                                  и history -s, и сам accept-line; ignoredups гасит дубль.
#
# Набранные ВРУЧНУЮ команды (не из меню) тоже видны другим вкладкам сразу — через
# DEBUG-trap (__auto_in_flush -> history -a) команда дописывается в файл ПЕРЕД своим
# запуском, поэтому и долгоживущая (claude/ssh), набранная руками, всплывает в новых
# вкладках немедленно. Trap ставится один раз на сессию (guard __AUTO_IN_HOOKED).
# С atuin/bash-preexec совместимо: они ставят свой DEBUG-trap отложенно и ЦЕПЛЯЮТ
# существующий, т.е. подхватят наш.

__HIST_ENGINE="$HOME/.local/bin/auto-in.py"

# Pre-exec: зафиксировать набранную команду в общей истории ДО её выполнения.
__auto_in_flush() { history -a; }

# Список истории: свежие сверху, без номеров, без дублей, записи разделены NUL.
# awk собирает МНОГОСТРОЧНУЮ команду (lithist / встроенный \n) в одну запись:
# новая запись начинается со строки с номером, строки без номера — её продолжения.
# NUL-разделитель (а не \n) нужен, чтобы движок не порезал многострочное на пункты.
__hist_list() {
    history | awk '
        function flush() { if (have) { recs[n++] = rec; have = 0 } }
        /^[ \t]*[0-9]+[ \t]/ {                              # начало записи (есть номер)
            flush()
            sub(/^[ \t]*[0-9]+[ \t]+/, "")                  # снять номер у первой строки
            rec = $0; have = 1; next
        }
        { rec = rec "\n" $0 }                               # строка-продолжение команды
        END {
            flush()
            for (i = n - 1; i >= 0; i--) {                  # свежие — первыми
                r = recs[i]
                if (!(r in seen) && r ~ /[^ \t\n]/) { seen[r] = 1; printf "%s%c", r, 0 }
            }
        }
    '
}

# Шаг 1 макроса: подтянуть чужое -> открыть меню -> подставить выбранное ->
# зафиксировать выбранное в общей истории -> настроить шаг "акцепт".
__on_up() {
    history -n 2>/dev/null            # подтянуть команды, дописанные другими вкладками
    local out rc
    # "--" завершает опции: текст вроде "--test" ищется как подстрока, а не как флаг
    out=$(__hist_list | python3 "$__HIST_ENGINE" -- "$READLINE_LINE")
    rc=$?
    if [[ -n "$out" ]]; then
        READLINE_LINE="$out"
        READLINE_POINT=${#READLINE_LINE}
    fi
    if [[ $rc -eq 0 ]]; then
        if [[ -n "$out" ]]; then
            history -s -- "$out"      # в in-memory (ignoredups гасит дубль от accept-line)
            history -a                # сразу в ~/.bash_history -> новые вкладки видят немедленно
        fi
        bind '"\C-xE": accept-line'         2>/dev/null   # Enter -> выполнить
    else
        bind '"\C-xE": redraw-current-line' 2>/dev/null   # Tab/Esc -> ничего не запускать
    fi
}

# Привязки и зависимости — только в интерактивном shell
if [[ $- == *i* ]]; then
    # Зависимости фичи "общая история" проставляем здесь, чтобы не полагаться на
    # содержимое ~/.bashrc и не затирать пользовательский HISTCONTROL:
    shopt -s histappend                                   # не перезатирать историю при выходе
    case ":${HISTCONTROL}:" in
        *:ignoredups:*|*:ignoreboth:*) : ;;               # ignoredups уже обеспечен — не трогаем
        *) HISTCONTROL="${HISTCONTROL:+$HISTCONTROL:}ignoredups" ;;
    esac

    # Биндим в ОБА keymap'а (emacs-standard и vi-insert): bind без -m пишет только
    # в текущий keymap, и при `set -o vi` стрелка ↑ потеряла бы функциональность.
    for __km in emacs-standard vi-insert; do
        bind -m "$__km" -x '"\C-xU": __on_up'              2>/dev/null   # шаг 1: меню
        bind -m "$__km"    '"\C-xE": redraw-current-line'  2>/dev/null   # шаг 2: по умолчанию no-op
        bind -m "$__km"    '"\e[A": "\C-xU\C-xE"'          2>/dev/null   # стрелка вверх = шаг1 + шаг2
        bind -m "$__km"    '"\eOA": "\C-xU\C-xE"'          2>/dev/null   # стрелка вверх (application-mode)
    done
    unset __km

    # Pre-exec для команд, набранных ВРУЧНУЮ: ставим наш DEBUG-trap один раз на
    # сессию. Guard __AUTO_IN_HOOKED защищает от повторной установки при ре-сорсе
    # ~/.bashrc (в т.ч. чтобы не перезатереть версию, которую мог сцепить atuin).
    # Прочитать чужой trap из sourced-контекста нельзя (там DEBUG скрыт — это
    # ограничение bash), поэтому ставим напрямую. С atuin/bash-preexec безопасно:
    # они ставят свой trap отложенно (на первом приглашении) и ЦЕПЛЯЮТ имеющийся,
    # т.е. подхватят наш, в каком бы порядке их ни подключили в ~/.bashrc.
    if [[ -z "${__AUTO_IN_HOOKED:-}" ]]; then
        trap '__auto_in_flush' DEBUG
        __AUTO_IN_HOOKED=1
    fi
fi
BASHEOF

# --- 4. Подключение в ~/.bashrc (без дублей) ---------------------------------
touch "$HOME/.bashrc"
# Проверяем ТОЧНУЮ строку подключения целиком (grep -x -F), а не подстроку
# '.hist_search.bash' — иначе чужая строка с этой подстрокой (alias/коммент)
# заставила бы пропустить добавление реального подключения.
if ! grep -qxF '[ -f "$HOME/.hist_search.bash" ] && . "$HOME/.hist_search.bash"' "$HOME/.bashrc"; then
    say "Добавляю подключение в ~/.bashrc"
    {
        printf '\n# auto-in: поиск/просмотр истории на стрелке вверх (Python+curses)\n'
        printf '%s\n' '[ -f "$HOME/.hist_search.bash" ] && . "$HOME/.hist_search.bash"'
    } >> "$HOME/.bashrc"
else
    say "Подключение в ~/.bashrc уже есть — пропускаю"
fi

# Ищем именно НЕзакомментированную строку, кладущую .local/bin в PATH
# (старое 'grep -F .local/bin' срабатывало и на комментарии -> PATH не добавлялся).
if ! grep -qE '^[[:space:]]*(export[[:space:]]+)?PATH=.*\.local/bin' "$HOME/.bashrc"; then
    say "Добавляю ~/.local/bin в PATH"
    printf '%s\n' 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

say "Готово. Выполните:  exec bash   (или откройте новый терминал)"
