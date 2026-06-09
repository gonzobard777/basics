#!/usr/bin/env python3
"""Интерактивный поиск по истории команд (подстрока, live-фильтр).

Историю читает из stdin (по одной команде в строке, свежие — сверху),
начальный запрос берёт из argv[1]. Выбранную команду печатает в исходный
stdout (его перехватывает $() в bash). Рисует меню на /dev/tty.

Режим самотеста (без curses, для проверки фильтрации):
    python3 auto-in.py --test "запрос" < файл-с-историей
"""
import sys
import os
import locale

# Минимальная задержка распознавания Esc/стрелок: по умолчанию ncurses ждёт
# ~1 с после Esc (стрелки тоже начинаются с Esc). Ставим ДО импорта/инициализации
# curses и форсируем (не setdefault), чтобы перебить возможное большое значение.
os.environ["ESCDELAY"] = "10"

import curses


def get_history():
    """Прочитать историю из stdin, убрать пустые строки и дубли (порядок сохранить)."""
    data = sys.stdin.buffer.read().decode("utf-8", "replace")
    seen = set()
    out = []
    for line in data.splitlines():
        s = line.rstrip("\n")
        if s.strip() and s not in seen:
            seen.add(s)
            out.append(s)
    return out


def filter_items(items, query):
    """Подстрочный регистронезависимый фильтр с сохранением порядка."""
    if not query:
        return items
    q = query.lower()
    return [x for x in items if q in x.lower()]


def run_ui(history, query):
    sel = {"v": None, "mode": None}

    def _ui(stdscr):
        curses.curs_set(0)
        stdscr.keypad(True)
        try:
            curses.set_escdelay(10)  # дублируем форс ESCDELAY уже после init
        except (AttributeError, curses.error):
            pass
        hist_lower = [h.lower() for h in history]
        q = list(query)
        last_q = None
        items = history
        idx = 0
        top = 0
        while True:
            cur_q = "".join(q)
            if cur_q != last_q:  # фильтр пересчитываем только при смене запроса
                if cur_q:
                    needle = cur_q.lower()
                    items = [h for h, hl in zip(history, hist_lower) if needle in hl]
                else:
                    items = history
                last_q = cur_q
                idx = 0
                top = 0
            if idx >= len(items):
                idx = max(0, len(items) - 1)
            if idx < 0:
                idx = 0
            h, w = stdscr.getmaxyx()
            list_h = max(1, min(10, h - 1))  # максимум 10 строк, дальше прокрутка
            # прокрутка, чтобы выбранная строка всегда была видна
            if idx < top:
                top = idx
            elif idx >= top + list_h:
                top = idx - list_h + 1

            stdscr.erase()
            for row in range(list_h):
                li = top + row
                if li >= len(items):
                    break
                marker = "> " if li == idx else "  "
                text = (marker + items[li])[: w - 1]
                attr = curses.A_REVERSE if li == idx else curses.A_NORMAL
                try:
                    stdscr.addstr(row, 0, text, attr)
                except curses.error:
                    pass
            status = "поиск: " + "".join(q) + "   [{}]".format(len(items))
            try:
                stdscr.addstr(h - 1, 0, status[: w - 1], curses.A_BOLD)
            except curses.error:
                pass
            stdscr.refresh()

            c = stdscr.getch()
            if c == 27:  # Esc — отмена
                sel["v"] = None
                return
            elif c in (curses.KEY_UP, 16):  # ↑ / Ctrl-P
                idx -= 1
            elif c in (curses.KEY_DOWN, 14):  # ↓ / Ctrl-N
                idx += 1
            elif c in (10, 13, curses.KEY_ENTER):  # Enter — выбрать и выполнить
                if items:
                    sel["v"] = items[idx]
                    sel["mode"] = "run"
                return
            elif c == 9:  # Tab — подставить в строку без запуска
                if items:
                    sel["v"] = items[idx]
                    sel["mode"] = "insert"
                return
            elif c in (curses.KEY_BACKSPACE, 127, 8):
                if q:
                    q.pop()
                idx = 0
            elif c == 21:  # Ctrl-U — очистить запрос
                q = []
                idx = 0
            elif 32 <= c <= 126:  # печатаемые ASCII — в запрос
                q.append(chr(c))
                idx = 0
            # остальное игнорируем

    curses.wrapper(_ui)
    return sel["v"], sel["mode"]


def main():
    locale.setlocale(locale.LC_ALL, "")
    args = sys.argv[1:]
    test = False
    if args and args[0] == "--test":
        test = True
        args = args[1:]
    query = args[0] if args else ""
    history = get_history()

    if test:
        for x in filter_items(history, query):
            print(x)
        return

    # сохранить исходный stdout (pipe из $()), а curses увести на /dev/tty
    result_fd = os.dup(1)
    tty_out = os.open("/dev/tty", os.O_WRONLY)
    os.dup2(tty_out, 1)
    tty_in = os.open("/dev/tty", os.O_RDONLY)
    os.dup2(tty_in, 0)

    selection, mode = run_ui(history, query)

    if selection:
        os.write(result_fd, (selection + "\n").encode("utf-8"))

    # Код возврата сообщает bash, что делать дальше:
    #   0 — выполнить команду (нажат Enter)
    #   3 — только подставить в строку (нажат Tab)
    #   1 — отмена (Esc или пустой выбор)
    if mode == "run":
        sys.exit(0)
    elif mode == "insert":
        sys.exit(3)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
