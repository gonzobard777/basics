#!/usr/bin/env bash
# uninstall.sh — удаляет "auto-in", установленный через install.sh.
#
# Обратная операция к install.sh: убирает движок, клей и подключение из ~/.bashrc.
# Идемпотентно: если что-то уже удалено — просто пропускает.
#
# НЕ удаляет строку 'export PATH ~/.local/bin' из ~/.bashrc — ею могут
# пользоваться другие программы из ~/.local/bin.
#
# Использование:
#   bash uninstall.sh
#   exec bash            # подхватить изменения в текущем терминале

set -euo pipefail

say() { printf '==> %s\n' "$*"; }

# --- 1. Движок ---------------------------------------------------------------
if [[ -e "$HOME/.local/bin/auto-in.py" ]]; then
    rm -f "$HOME/.local/bin/auto-in.py" "$HOME/.local/bin/__pycache__/auto-in"*.pyc
    say "Удалён движок ~/.local/bin/auto-in.py"
else
    say "Движка ~/.local/bin/auto-in.py нет — пропускаю"
fi

# --- 2. Клей -----------------------------------------------------------------
if [[ -e "$HOME/.hist_search.bash" ]]; then
    rm -f "$HOME/.hist_search.bash"
    say "Удалён клей ~/.hist_search.bash"
else
    say "Клея ~/.hist_search.bash нет — пропускаю"
fi

# --- 3. Подключение из ~/.bashrc (с бэкапом) ---------------------------------
# Удаляем ТОЛЬКО две точные строки, добавленные установщиком (целиком: grep -x -F),
# а не по подстроке — иначе сносились бы пользовательские строки, где '# auto-in:'
# или '.hist_search.bash' встречаются как часть текста.
__ai_comment='# auto-in: поиск/просмотр истории на стрелке вверх (Python+curses)'
__ai_source='[ -f "$HOME/.hist_search.bash" ] && . "$HOME/.hist_search.bash"'
if [[ -f "$HOME/.bashrc" ]] && grep -qxF "$__ai_source" "$HOME/.bashrc"; then
    cp "$HOME/.bashrc" "$HOME/.bashrc.auto-in.bak"
    __tmp="$HOME/.bashrc.auto-in.tmp"
    grep -vxF -e "$__ai_comment" -e "$__ai_source" "$HOME/.bashrc" > "$__tmp" && __grc=0 || __grc=$?
    if [[ $__grc -le 1 ]]; then            # 0 = остались строки, 1 = удалили все — оба валидны
        mv "$__tmp" "$HOME/.bashrc"
        say "Убрано подключение из ~/.bashrc (бэкап: ~/.bashrc.auto-in.bak)"
    else
        rm -f "$__tmp"
        echo "ОШИБКА grep при правке ~/.bashrc — файл не тронут (бэкап цел)." >&2
    fi
else
    say "Подключения в ~/.bashrc нет — пропускаю"
fi

say "Готово. Выполните:  exec bash   (или откройте новый терминал)"
say "PATH (~/.local/bin) не трогал — им могут пользоваться другие программы."
