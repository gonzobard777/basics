# Типы

|    | Типы                                      |                                                                                                        |
|----|-------------------------------------------|--------------------------------------------------------------------------------------------------------|
| 1. | [Undefined](https://tinyurl.com/3mbrhdbk) | Отсутствует значение, т.к. не было определено. [Не примитив И не объект](https://tinyurl.com/4586tj84) | 
| 2. | [Null](https://tinyurl.com/2t5u8wv6)      | Намеренное отсутствие значения Объекта                                                                 | 
| 3. | [Boolean](https://tinyurl.com/8c7zzanm)   |                                                                                                        | 
| 4. | [Number](https://tinyurl.com/dsz6yry7)    | [Числа](https://learn.javascript.ru/number)                                                            | 
| 5. | [BigInt](https://tinyurl.com/yxyf6kex)    | [BigInt](https://learn.javascript.ru/bigint)                                                           | 
| 6. | [String](https://tinyurl.com/s69stj49)    | [Строки](https://learn.javascript.ru/string)                                                           | 
| 7. | [Symbol](https://tinyurl.com/3dz2st73)    | [Тип данных Symbol](https://learn.javascript.ru/symbol)                                                | 
| 8. | [Object](https://tinyurl.com/du3bf37k)    |                                                                                                        | 
  
| `typeof` *value*                     | Result                                   | Maybe it would be better this way                                         |
|--------------------------------------|------------------------------------------|---------------------------------------------------------------------------|
| Undefined                            | "undefined"                              | or `value === undefined`                                                  |
| Null                                 | ["object"](https://tinyurl.com/ymjz3v7h) | use `value === null` or `typeof value === 'object' && value == undefined` |
| Boolean                              | "boolean"                                |
| Number                               | "number"                                 |
| String                               | "string"                                 |
| Symbol                               | "symbol"                                 |
| BigInt                               | "bigint"                                 |
| Object (does not implement [[Call]]) | "object"                                 |
| Object (implements [[Call]])         | "function"                               |

# Конвертации

| [ToBoolean](https://tinyurl.com/r7v9y9n9)                                           | [ToNumber](https://tinyurl.com/ur5yaxkh), [ToNumeric](https://tinyurl.com/hp6snzfb)                                                                                                                                                                                                                                                  | [ToBigInt](https://tinyurl.com/3tk59vvr)                          | [ToString](https://tinyurl.com/mxe9adyw)                                                                                  |
|-------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| `Boolean(value)`,<br>Unary `!`,<br>`if`, циклы,<br>`? :`,<br>`&&`, `\|\|`<br>&nbsp; | Unary `+`, `-`, `~`,<br>`Number(value)`,<br>[Binary](https://tinyurl.com/b7ny87t9) `+`, `-`, `**`, `*`, `/`, `%`, `<<`, `>>`, `>>>`, `&`, `^`, `\|`,<br>[Relational](https://tinyurl.com/yj6zydm6) `<`, `>`, `<=`, `>=`<br>[Update](https://tinyurl.com/vffpnsw2) `++`, `--`,<br>[Equality](https://tinyurl.com/vbhc8cw2) `==`, `!=` | `BigInt(value)`<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp; | `${value}`,<br>`String(value)`,<br>`object[key]`, `in`,<br>[Binary](https://tinyurl.com/b7ny87t9) `+`<br>&nbsp;<br>&nbsp; |
  
|           | [ToBoolean](https://tinyurl.com/r7v9y9n9)                   | [ToNumber](https://tinyurl.com/ur5yaxkh)       | [ToBigInt](https://tinyurl.com/3tk59vvr)       | [ToString](https://tinyurl.com/mxe9adyw)         | [ToObject](https://tinyurl.com/35nbcfmm)             |
|-----------|-------------------------------------------------------------|------------------------------------------------|------------------------------------------------|--------------------------------------------------|------------------------------------------------------|
| Undefined | `false`                                                     | `NaN`                                          | TypeError                                      | `"undefined"`                                    | TypeError                                            |
| Null      | `false`                                                     | `0`                                            | TypeError                                      | `"null"`                                         | TypeError                                            |
| Boolean   | -                                                           | `1`/`0`                                        | `1n`/`0n`                                      | `"true"/"false"`                                 | [`new Boolean(value)`](https://tinyurl.com/4ferbkt5) |
| Number    | `-0` &#124;&#124; `0` &#124;&#124; `NaN` ? `false` : `true` | -                                              | TypeError                                      | [Number::toString](https://tinyurl.com/wrvtv3yy) | [`new Number(value)`](https://tinyurl.com/5ut8m98v)  |
| BigInt    | `0n` ? `false` : `true`                                     | TypeError                                      | -                                              | [BigInt::toString](https://tinyurl.com/m6zhrvre) | [`new BigInt(value)`](https://tinyurl.com/2zr4dpsa)  |
| String    | length === 0 ? `false` : `true`                             | [StringToNumber](https://tinyurl.com/v237tfs7) | [StringToBigInt](https://tinyurl.com/27hu7bfu) | -                                                | [`new String(value)`](https://tinyurl.com/x92yace8)  |
| Symbol    | `true`                                                      | TypeError                                      | TypeError                                      | TypeError                                        | [`new Symbol(descr)`](https://tinyurl.com/ysen32ad)  |
| Object    | `true`                                                      | [ToPrimitive](https://tinyurl.com/j4dxw9ps)    | -                                              | [ToPrimitive](https://tinyurl.com/j4dxw9ps)      | -                                                    |

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
`true + false`  
`"five" + + "two"`  
`1 || 0 || 7`  
`7 && 1`  
`0 || "0" && 1`  
`"7" * "3"`  
`"9" / 3`  
`5/null`  
`null + 2`  
`undefined + 3`  
`!"0"`  
`"a" == "b"`  
`123 != "456"`  
`"true" == true`  
`false == "false"`  
`null == ""`  
`!!"false" == !!"true"`  
