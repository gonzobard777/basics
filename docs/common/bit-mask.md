[Low level bit hacks](https://catonmat.net/low-level-bit-hacks)

# Битовые маски

**Байт** – это восемь последовательно расположенных бит, каждый из которых может принимать значение 1, либо 0. Слово – это два последовательно расположенных байта, 16 бит. И т.д.  
**Битовая строка** – это последовательность бит. В качестве битовой строки обычно используются числа разных типов. Например, число типа беззнаковый `int` можно считать битовой строкой длиной в 32 бит, то есть в одном таком числе можно хранить 32 независимых булевых значения.  
**Битовая маска** – это инструмент, который помогает **сохранять**/**устанавливать**/**снимать** большое количество булевых значений в одной битовой строке. А также помогает **проверять** нужное булевое значение, хранящееся в битовой строке.

Допустим перед вами стоит задача создать расписание.  
При настройке расписания пользователь в интерфейсе может выбрать дни недели: Пн, Вт, Ср, Чт, Пт, Сб, Вс.  
При помощи битовой маски информацию об установленности всех семи флажков можно сохранить в одном числе типа `byte`.  
Также, при помощи битовой маски можно потом проверить на каких днях недели пользователь установил флажек.

## Необходимый минимум знаний

### Побитовый И (AND, `&`)

Двоичный разряд результата равен 1 только тогда, когда оба соответствующих бита равны 1:

| A&B | 0 | 0 | 1 | 0 | 0 | 1 | 0 | 0 |
|-----|---|---|---|---|---|---|---|---|
| A   | 0 | 0 | 1 | 0 | 0 | 1 | 1 | 0 |
| B   | 0 | 0 | 1 | 1 | 0 | 1 | 0 | 1 |

### Побитовый ИЛИ (OR, `|`)

Двоичный разряд результата равен 0 только тогда, когда оба соответствующих бита равны 0:

| A&#124;B | 0 | 0 | 1 | 1 | 0 | 1 | 1 | 1 |
|----------|---|---|---|---|---|---|---|---|
| A        | 0 | 0 | 1 | 0 | 0 | 1 | 1 | 0 |
| B        | 0 | 0 | 1 | 1 | 0 | 1 | 0 | 1 |

### Побитовый Исключающий ИЛИ (XOR, `^`)

Для получения 1 только один бит в паре может быть 1:

| A^B | 1 | 0 | 1 | 0 | 0 | 0 | 0 | 1 |
|-----|---|---|---|---|---|---|---|---|
| A   | 1 | 0 | 0 | 0 | 1 | 0 | 1 | 0 |
| B   | 0 | 0 | 1 | 0 | 1 | 0 | 1 | 1 |

### Нумерация бит

В качестве **порядкового номера**, присваемого каждому биту, используется степень 2, соответствующая местоположению этого бита.  
Самый младший бит - это нулевой бит, поскольку он представляет 2<sup>0</sup>.  
Таким образом, биты в байте нумеруются от 0 до 7:

| Нумерация бит | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|---------------|---|---|---|---|---|---|---|---|
| Пример байта  | 0 | 0 | 1 | 0 | 0 | 1 | 1 | 0 |

---

## Создать битовые маски

Идея состоит в том, чтобы некое Значение связать с Битовой маской.  
В случае с днями недели таблица связи значений с их битовыми масками может выглядеть так:

| DayOfWeek | Битовая маска | Альтернативное представление битовой маски |
|-----------|---------------|--------------------------------------------|
| Пн        | `00000001`    | 2<sup>0</sup> = 1                          |
| Вт        | `00000010`    | 2<sup>1</sup> = 2                          |
| Ср        | `00000100`    | 2<sup>2</sup> = 4                          |
| Чт        | `00001000`    | 2<sup>3</sup> = 8                          |
| Пт        | `00010000`    | 2<sup>4</sup> = 16                         |
| Сб        | `00100000`    | 2<sup>5</sup> = 32                         |
| Вс        | `01000000`    | 2<sup>6</sup> = 64                         |

Обратите внимание. Альтернативное представление битовой маски – это 2<sup>порядковый номер используемого бита</sup>  
Должно быть очевидно, что битовая маска и ее альтернативное представление – это одно и тоже число.

По сути, битовая маска означает:

- какой конкретно бит используется в битовой строке;
- и то, что этот бит установлен.

Есть еще одна маска, которая противоположна всем маскам – это **пустая битовая маска**.  
В нашем примере пустая маска соответствует: `00000000`, ну, или просто `0`.  
Пустая маска означает, что какое-то значение сейчас не установлено. Например, в расписании не установлены Пн и Сб; вот у них маска равна `00000000`.

## Сохранить маски в строку

В процессе сохранения учавствует побитовый ИЛИ.  
Допустим, пользователь установил в расписании Вт, Чт и Пт.  
Тогда результирующая битовая строка вычисляется следующим образом:

```
00000010 OR  // битовая маска Вт  
00001000 OR  // битовая маска Чт  
00010000     // битовая маска Пт    
=  
00011010  // битовая строка: Вт, Чт, Пт
```

Можно сохранять не только те маски, которые установлены, а сразу все маски для всех дней недели и результирующая битовая строка не измениться, т.к. побитовый ИЛИ с участием пустой маски не влияет на результат.

## Установить бит в строке

В процессе установки учавствует побитовый ИЛИ.  
Допустим, есть битовая строка: `01010101` - здесь установлены Пн, Ср, Пт, Вс.  
Требуется установить Вт и Сб.  
Тогда результирующая битовая строка вычисляется следующим образом:

```
01010101 OR  // битовая строка: Пн, Ср, Пт, Вс  
00000010 OR  // битовая маска Вт  
00100000     // битовая маска Сб  
=  
01110111  // битовая строка: Пн, Вт, Ср, Пт, Сб, Вс
```

## Снять бит в строке

В процессе снятия учавствует побитовый Исключающий ИЛИ.  
Допустим, есть битовая строка: `01011101` - здесь установлены Пн, Ср, Чт, Пт, Вс.  
Надо снять Ср и Пт.  
Тогда результирующая битовая строка вычисляется следующим образом:

```
01011101 XOR  // битовая строка: Пн, Ср, Чт, Пт, Вс  
00000100 XOR  // битовая маска Ср  
00010000      // битовая маска Пт  
=  
01001001  // битовая строка: Пн, Чт, Вс
```

## Проверить установленность бита

В процессе проверки учавствует побитовый И.  
Допустим, есть битовая строка: `01011101` - здесь установлены Пн, Ср, Чт, Пт, Вс.

Надо проверить, а Чт в этой битовой строке установлен или снят:

```
01011101 AND  // битовая строка: Пн, Ср, Чт, Пт, Вс  
00001000      // битовая маска Чт  
=  
00001000  // не равно 0, значит Чт установлен
```

Надо проверить, а Сб в этой битовой строке установлена или снята:

```
01011101  AND  // битовая строка: Пн, Ср, Чт, Пт, Вс  
00100000       // битовая маска Сб  
=  
00000000  // равно 0, значит Сб не установлена
```
