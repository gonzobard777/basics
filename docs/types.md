# Типы значений

В языке JavaScript у переменных нет типов – типы есть у _значений_.  
Переменная может хранить любое значение в любой момент времени. Иначе говоря, движёк не требует, чтобы в _переменной_ всегда хранились значения _исходного типа_, с которым она начала свое существование.  

|    | Типы значений                             |                                                                                                                                                             |
|----|-------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1. | [undefined](https://tinyurl.com/3mbrhdbk) | Значение `undefined` присваивается непроинициализированным переменным.<br>Значение `undefined` возвращает функция, для которой не определено return значение.<br>Значение `undefined` возвращается при обращении к отсутствующему полю объекта.<br>[Не примитив И не объект](https://tinyurl.com/4586tj84) | 
| 2. | [null](https://tinyurl.com/2t5u8wv6)      | Намеренное отсутствие значения (по смыслу м.б. ближе к объектам).                                                                                           | 
| 3. | [boolean](https://tinyurl.com/8c7zzanm)   |                                                                                                                                                             | 
| 4. | [number](https://tinyurl.com/dsz6yry7)    | [Числа](https://learn.javascript.ru/number), [Double-precision floating-point format](https://en.wikipedia.org/wiki/Double-precision_floating-point_format), [Как работают числа с плавающей точкой](https://www.youtube.com/watch?v=U0U8Ddx4TgE) | 
| 5. | [bigInt](https://tinyurl.com/yxyf6kex)    | [BigInt](https://learn.javascript.ru/bigint)                                                                                                                | 
| 6. | [string](https://tinyurl.com/s69stj49)    | [Строки](https://learn.javascript.ru/string)                                                                                                                | 
| 7. | [symbol](https://tinyurl.com/3dz2st73)    | [Тип данных Symbol](https://learn.javascript.ru/symbol)                                                                                                     | 
| 8. | [object](https://tinyurl.com/du3bf37k)    |                                                                                                                                                             |

**Примитивный тип** – это все, что не `Object`.

### К какому типу относится это значение или значение в этой переменной?
  
| `typeof` *value*                     | Result                                   | Maybe it would be better this way                                     |
|--------------------------------------|------------------------------------------|-----------------------------------------------------------------------|
| Undefined                            | "undefined"                              | `value === undefined`, but remember about `var undefined = "abc"`     |
| Null                                 | ["object"](https://tinyurl.com/ymjz3v7h) | `value === null` or `typeof value === 'object' && value == undefined` |
| Boolean                              | "boolean"                                |
| Number                               | "number"                                 |
| BigInt                               | "bigint"                                 |
| String                               | "string"                                 |
| Symbol                               | "symbol"                                 |
| Object (does not implement [[Call]]) | "object"                                 |
| Object (implements [[Call]])         | "function"                               |

# Конвертации

### Когда и как движёк будет выполять конвертацию?
| Как?   | [ToBoolean](https://tinyurl.com/r7v9y9n9)                                                     | [ToNumber](https://tinyurl.com/ur5yaxkh), [ToNumeric](https://tinyurl.com/hp6snzfb)                                                                                                                                                                                                                                                                                                                                      | [ToBigInt](https://tinyurl.com/3tk59vvr)                                    | [ToString](https://tinyurl.com/mxe9adyw)                                                                                            |
|--------|-----------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| Когда? | `Boolean(value)`,<br>Unary `!`,<br>`if`, циклы,<br>`? :`,<br>`&&`, `\|\|`<br>&nbsp;<br>&nbsp; | Unary `+`, `-`, `~`,<br>`Number(value)`,<br>[Binary](https://tinyurl.com/b7ny87t9) `+`, `-`, `**`, `*`, `/`, `%`, `<<`, `>>`, `>>>`, `&`, `^`, `\|`,<br>[Relational](https://tinyurl.com/yj6zydm6) `<`, `>`, `<=`, `>=`<br>[Update](https://tinyurl.com/vffpnsw2) `++`, `--`,<br>[Equality](https://tinyurl.com/vbhc8cw2) `==`, `!=`,<br>[isNaN](https://tinyurl.com/3sype8zz), [isFinite](https://tinyurl.com/54zxtza6) | `BigInt(value)`<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp; | `${value}`,<br>`String(value)`,<br>`object[key]`, `in`,<br>[Binary](https://tinyurl.com/b7ny87t9) `+`<br>&nbsp;<br>&nbsp;<br>&nbsp; |

### Как сконвертируется значение соответствующего типа?
|           | [ToBoolean](https://tinyurl.com/r7v9y9n9)                   | [ToNumber](https://tinyurl.com/ur5yaxkh)       | [ToBigInt](https://tinyurl.com/3tk59vvr)       | [ToString](https://tinyurl.com/mxe9adyw)         | [ToObject](https://tinyurl.com/35nbcfmm)             |
|-----------|-------------------------------------------------------------|------------------------------------------------|------------------------------------------------|--------------------------------------------------|------------------------------------------------------|
| Undefined | `false`                                                     | `NaN`                                          | TypeError                                      | `"undefined"`                                    | TypeError                                            |
| Null      | `false`                                                     | `0`                                            | TypeError                                      | `"null"`                                         | TypeError                                            |
| Boolean   | –                                                           | `1`/`0`                                        | `1n`/`0n`                                      | `"true"/"false"`                                 | [`new Boolean(value)`](https://tinyurl.com/4ferbkt5) |
| Number    | `-0` &#124;&#124; `0` &#124;&#124; `NaN` ? `false` : `true` | –                                              | TypeError                                      | [Number::toString](https://tinyurl.com/wrvtv3yy) | [`new Number(value)`](https://tinyurl.com/5ut8m98v)  |
| BigInt    | `0n` ? `false` : `true`                                     | TypeError                                      | –                                              | [BigInt::toString](https://tinyurl.com/m6zhrvre) | [`new BigInt(value)`](https://tinyurl.com/2zr4dpsa)  |
| String    | length === 0 ? `false` : `true`                             | [StringToNumber](https://tinyurl.com/v237tfs7) | [StringToBigInt](https://tinyurl.com/27hu7bfu) | –                                                | [`new String(value)`](https://tinyurl.com/x92yace8)  |
| Symbol    | `true`                                                      | TypeError                                      | TypeError                                      | TypeError                                        | [`new Symbol(descr)`](https://tinyurl.com/ysen32ad)  |
| Object    | `true`                                                      | [ToPrimitive](https://tinyurl.com/j4dxw9ps)    | –                                              | [ToPrimitive](https://tinyurl.com/j4dxw9ps)      | –                                                    |

- [Преобразование объектов в примитивы](https://learn.javascript.ru/object-toprimitive)
- [Пользовательский «toJSON»](https://learn.javascript.ru/json#polzovatelskiy-tojson) 
  
# Другое

### Сравнение на равенство

`==` [Нестрогое сравнение на равенство](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-islooselyequal)

`===` [Строгое сравнение на равенство](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-isstrictlyequal)

Возможно, вместо `===` стоит использовать [Object.is](https://tc39.es/ecma262/multipage/fundamental-objects.html#sec-object.is)

### Checks

`"1" + 3`  
`3 + "1" + 5`  
`"7" - 3`  
`"4px" - 3`  
`6 - "3" - 1`  
`6 + "3" - 1`  
`+[]`  
`+[3]`  
`+[1, 2]`  
`true + false`  
`"five" + + "two"`  
`null + 2`  
`undefined + 3`  
`"7" * "3"`  
`1 * "123d"`  
`"9" / 3`  
`5 / "hello" === NaN`  
`NaN == NaN`  
`NaN !== NaN`  
`Object.is(NaN, NaN)`  
`isNaN("hello")`  
`Number.isNaN("hello")`  
`4 + Infinity`  
`Infinity - Infinity`  
`Infinity * Infinity`  
`Infinity / Infinity`  
`"5" / 0`  
`-1 / -0`  
`1 / -0`  
`1 / Infinity`  
`0 / -3`  
`0 - 0`  
`1 || 0 || 7`  
`"false" && 0 && 7`  
`0 || "0" && 1`  
`5/null`  
`!"0"`  
`!!"false"`  
`"a" == "b"`  
`123 != "456"`  
`"true" == true`  
`false == "false"`  
`null == ""`  
`undefined == null`  
```js
var a;
if (a != null) {
  console.log('hello');
} else {
  console.log('world');
}
```  
```js
var a = new Boolean(false);
if (!a) {
  console.log('hello123');
} else {
  console.log('world');
}
```  
```js
var str = "hello";
str.lang = 'eng';
console.log(str.lang);
```
`false == new Boolean(false)`  
`false === new Boolean(false)`  
`true == new Boolean([])`  
`!!"false" == !!"true"`  
`Object.is(0, -0)`  
`0 === -0`  
`0 == -0`  
`typeof null === "object"`  
`typeof NaN === "number"`  
`typeof -Infinity === "undefined"`  
`typeof {} === "object"`  
`typeof(()=>{}) === "object"`  
`typeof [3, 5, 2] === "array"`  
`typeof(typeof 0) === "number"`  
`(function helloWorld(){})() === undefined`  
`({})() === undefined`  
`void "hello"`  
`void false`  
```js
var a;
console.log(a);
console.log(z);
```  
```js
var a;
console.log(typeof a);
console.log(typeof z);
```  
```js
var a;
var z = 42;
z = a;
console.log(typeof a);
console.log(typeof z);
```  
```js
var a = 2;
var b = a;
b++;
console.log(a, b);
```  
```js
function foo(x){
  x.push(4);
  
  x = [4, 5, 6];
  x.push(7);
  console.log('x', x);
}

var a = [1, 2, 3];
foo(a);
console.log('a', a);
```  
```js
function foo(x){
  x.push(4);
  
  x.length = 0;
  x.push(4, 5, 6);
  console.log('x', x);
}

var a = [1, 2, 3];
foo(a);
console.log('a', a);
```  
```js
function foo(x) {
  x++;
}
var a = new Number(1);
foo(a);
console.log(+a);
```  
