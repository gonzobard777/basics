# Углы

[atan2](https://en.wikipedia.org/wiki/Atan2)

## atan2, когда ось Y направлена вниз (применительно к веб-разработке)

Обычное использование `atan2` – это `atan2(x,y)` и `atan2(y,x)`.  
Но интересно то, что комбинаций аргументов для функции `atan2` может быть 8 штук.  
И эти комбинации покрывают все 4 стороны света по/против часовой стрелке.

Ниже представлена таблица комбинаций аргументов `atan2` для случая, когда:

- ось Y направлена вниз ↓
- ось X направлена направо →

Обратите внимание, что если первый аргумент отрицательный, то `atan2` на краях принимает значение -0° и -180°.  
А если первый аргумент положительный, то 0° и 180°.

| Сторона и направление    | Аргументы `atan2` | Результат `atan2`                                          | Результат `atan2`, <br/> помещенный в диапазон `[0; +360)`  |
|--------------------------|-------------------|------------------------------------------------------------|-------------------------------------------------------------|
| `North-Clockwise`        | `(  x, -y )`      | <img src="./pic/north-clockwise.png" width="253"/>         | <img src="./pic/north-clockwise-0-to-360.png" width="253"/> |
| `North-CounterClockwise` | `( -x, -y )`      | <img src="./pic/north-counter-clockwise.png" width="253"/> |                                                             |
| `East-Clockwise`         | `(  y,  x )`      | <img src="./pic/east-clockwise.png" width="253"/>          |                                                             |
| `East-CounterClockwise`  | `( -y,  x )`      | <img src="./pic/east-counter-clockwise.png" width="253"/>  |                                                             |
| `South-Clockwise`        | `( -x,  y )`      | <img src="./pic/south-clockwise.png" width="253"/>         |                                                             |
| `South-CounterClockwise` | `(  x,  y )`      | <img src="./pic/south-counter-clockwise.png" width="253"/> |                                                             |
| `West-Clockwise`         | `( -y, -x )`      | <img src="./pic/west-clockwise.png" width="253"/>          |                                                             |
| `West-CounterClockwise`  | `(  y, -x )`      | <img src="./pic/west-counter-clockwise.png" width="253"/>  |                                                             |

