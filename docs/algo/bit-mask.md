# Битовая маска

**Байт** – это восемь последовательно расположенных бит. Слово – это два последовательно расположенных байта, 16 бит. И т.д.  
**Битовая строка** – это последовательность бит, каждый из которых может принимать значение 1, либо 0. В качестве битовой строки обычно используются числа. Например, число типа беззнаковый `int` можно считать битовой строкой длиной в 32 бит, то есть в одном таком числе можно хранить 32 независимых булевых значения.  
**Битовая маска** – это инструмент, который помогает **сохранять** большое количество булевых значений в одной битовой строке. А также помогает **проверять** нужное булевое значение, хранящееся в битовой строке.

Допустим перед вами стоит задача создать расписание.  
При настройке расписания пользователь может выбрать дни недели: Пн, Вт, Ср, Чт, Пт, Сб, Вс.  
При помощи битовой маски инфорацию об установке всех семи флажков можно сохранить в одно число типа `byte`.  
Также, при помощи битовой маски можно проверить на каких днях недели пользователь установил флажек.

## Необходимый минимум знаний

### Нумерация бит

В качестве **порядкового номера**, присваемого каждому биту, используется степень 2, соответствующая местоположению этого бита.  
Самый младший бит - это нулевой бит, поскольку он представляет 2<sup>0</sup>.  
Таким образом, биты в байте нумеруются от 0 до 7:

| Номера битов | 7   | 6   | 5   | 4   | 3   | 2   | 1   | 0   |
|--------------|-----|-----|-----|-----|-----|-----|-----|-----|
| Пример байта | 0   | 0   | 1   | 0   | 0   | 1   | 1   | 0   |

### Побитовое ИЛИ (OR, `|`)

Двоичный разряд результата равен 0 только тогда, когда оба соответствующих бита равны 0.

| A&#124;B | 0   | 0   | 1   | 1   | 0   | 1   | 1   | 1   |
|----------|-----|-----|-----|-----|-----|-----|-----|-----|
| A        | 0   | 0   | 1   | 0   | 0   | 1   | 1   | 0   |
| B        | 0   | 0   | 1   | 1   | 0   | 1   | 0   | 1   |

### Побитовое И (AND, `&`)

Двоичный разряд результата равен 1 только тогда, когда оба соответствующих бита равны 1.

| A&B | 0   | 0   | 1   | 0   | 0   | 1   | 0   | 0   |
|-----|-----|-----|-----|-----|-----|-----|-----|-----|
| A   | 0   | 0   | 1   | 0   | 0   | 1   | 1   | 0   |
| B   | 0   | 0   | 1   | 1   | 0   | 1   | 0   | 1   |

---

## Шаг 1. Создать битовые маски

| DayOfWeek | Битовая маска | Альтернативное представление битовой маски |
|-----------|---------------|--------------------------------------------|
| Пн        | `00000001`    | 2<sup>0</sup> = 1                          |
| Вт        | `00000010`    | 2<sup>1</sup> = 2                          |
| Ср        | `00000100`    | 2<sup>2</sup> = 4                          |
| Чт        | `00001000`    | 2<sup>3</sup> = 8                          |
| Пт        | `00010000`    | 2<sup>4</sup> = 16                         |
| Сб        | `00100000`    | 2<sup>5</sup> = 32                         |
| Вс        | `01000000`    | 2<sup>6</sup> = 64                         |

Обратите внимание, альтернативное представление – это 2<sup>номер используемого бита</sup>

По сути, битовая маска означает:

- какой конкретно бит используется в битовой строке;
- и то, что этот бит установлен.