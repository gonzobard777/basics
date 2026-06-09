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
if [[ -f "$HOME/.bashrc" ]] && grep -q '\.hist_search\.bash' "$HOME/.bashrc"; then
    cp "$HOME/.bashrc" "$HOME/.bashrc.auto-in.bak"
    # удаляем строку-комментарий "# auto-in:" и строку подключения клея
    sed -i '\|# auto-in:|d; /\.hist_search\.bash/d' "$HOME/.bashrc"
    say "Убрано подключение из ~/.bashrc (бэкап: ~/.bashrc.auto-in.bak)"
else
    say "Подключения в ~/.bashrc нет — пропускаю"
fi

say "Готово. Выполните:  exec bash   (или откройте новый терминал)"
say "PATH (~/.local/bin) не трогал — им могут пользоваться другие программы."
