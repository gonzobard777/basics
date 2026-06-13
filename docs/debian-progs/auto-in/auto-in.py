#!/usr/bin/env python3
"""Интерактивный поиск по истории команд (подстрока, live-фильтр).

Историю читает из stdin (по одной команде в строке, свежие — сверху),
начальный запрос берёт из argv[1]. Выбранную команду печатает в исходный
stdout (его перехватывает $() в bash). Рисует меню на /dev/tty.

Режим самотеста (без curses, для проверки фильтрации):
    python3 auto-in.py --test "запрос" < файл-с-историей

Аргумент `--` завершает разбор опций: всё после него — позиционный запрос.
Клей вызывает движок именно так (`... -- "$READLINE_LINE"`), поэтому текст
вроде `--test` в командной строке НЕ включает режим самотеста, а ищется как
обычная подстрока.
"""
import sys
import os
import locale

# Задержка распознавания Esc/стрелок: по умолчанию ncurses ждёт ~1 с после Esc
# (стрелки тоже начинаются с Esc). Ставим ДО импорта/инициализации curses и
# форсируем (не setdefault). 50 мс — компромисс: Esc срабатывает мгновенно на глаз,
# но хвост escape-последовательности стрелки успевает прийти даже по медленному
# каналу (ssh/нагрузка), иначе стрелку приняли бы за голый Esc и закрыли меню.
os.environ["ESCDELAY"] = "50"

import curses


def get_history():
    """Прочитать историю из stdin, убрать пустые строки и дубли (порядок сохранить).

    Записи разделены NUL — так многострочные команды (lithist / встроенный \\n)
    приходят ЦЕЛЫМИ, а не рвутся на отдельные пункты меню. Если NUL во входе нет
    (например режим --test читает историю построчно из файла) — делим по строкам.
    """
    data = sys.stdin.buffer.read().decode("utf-8", "replace")
    records = data.split("\0") if "\0" in data else data.splitlines()
    seen = set()
    out = []
    for rec in records:
        s = rec.strip("\n")  # снять обрамляющие \n, внутренние (многострочность) сохранить
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


def _flatten(s):
    """Однострочное представление команды для показа/фильтра (реальный текст не меняем)."""
    return s.replace("\n", " ⏎ ") if "\n" in s else s


def run_ui(history, query):
    sel = {"v": None, "mode": None}

    def _ui(stdscr):
        curses.curs_set(0)
        stdscr.keypad(True)
        try:
            curses.set_escdelay(50)  # дублируем форс ESCDELAY уже после init
        except (AttributeError, curses.error):
            pass
        # flat_all — однострочный показ (многострочные склеены через ⏎), фильтр по нему;
        # history — реальные команды (с \n), их и возвращаем при выборе.
        flat_all = [_flatten(h) for h in history]
        lower_all = [f.lower() for f in flat_all]
        q = list(query)
        last_q = None
        items = history
        items_flat = flat_all
        idx = 0
        top = 0
        while True:
            cur_q = "".join(q)
            if cur_q != last_q:  # фильтр пересчитываем только при смене запроса
                if cur_q:
                    needle = cur_q.lower()
                    items = []
                    items_flat = []
                    for h, f, l in zip(history, flat_all, lower_all):
                        if needle in l:
                            items.append(h)
                            items_flat.append(f)
                else:
                    items = history
                    items_flat = flat_all
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
                text = (marker + items_flat[li])[: w - 1]
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
    if args and args[0] == "--":  # дальше — позиционный запрос, не опции
        args = args[1:]
    query = args[0] if args else ""
    history = get_history()

    if test:
        for x in filter_items(history, query):
            print(x)
        return

    # сохранить исходный stdout (pipe из $()), а curses увести на /dev/tty
    try:
        result_fd = os.dup(1)
        tty_out = os.open("/dev/tty", os.O_WRONLY)
        os.dup2(tty_out, 1)
        tty_in = os.open("/dev/tty", os.O_RDONLY)
        os.dup2(tty_in, 0)
    except OSError:
        # нет управляющего терминала (запуск без tty) — тихо отменяем, как Esc
        sys.exit(1)

    try:
        selection, mode = run_ui(history, query)
    except curses.error:
        # TERM не задан/неизвестен, curses не смог инициализироваться — тихая отмена
        sys.exit(1)

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
