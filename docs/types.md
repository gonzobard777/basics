
|    | Типы                                                                                                                              |                                                                                                                             |
|----|-----------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| 1. | [Undefined](https://tc39.es/ecma262/multipage/ecmascript-data-types-and-values.html#sec-ecmascript-language-types-undefined-type) | Отсутствует значение, т.к. не было определено. [Не примитив И не объект](https://2ality.com/2013/05/history-undefined.html) | 
| 2. | [Null](https://tc39.es/ecma262/multipage/ecmascript-data-types-and-values.html#sec-ecmascript-language-types-null-type)           | Намеренное отсутствие какого-либо значения Объекта/Примитива                                                                | 
| 3. | [Boolean](https://tc39.es/ecma262/multipage/ecmascript-data-types-and-values.html#sec-ecmascript-language-types-boolean-type)     |                                                                                                                             | 
| 4. | [Number](https://tc39.es/ecma262/multipage/ecmascript-data-types-and-values.html#sec-ecmascript-language-types-number-type)       | [Числа](https://learn.javascript.ru/number)                                                                                 | 
| 5. | [BigInt](https://tc39.es/ecma262/multipage/ecmascript-data-types-and-values.html#sec-ecmascript-language-types-bigint-type)       | [BigInt](https://learn.javascript.ru/bigint)                                                                                | 
| 6. | [String](https://tc39.es/ecma262/multipage/ecmascript-data-types-and-values.html#sec-ecmascript-language-types-string-type)       | [Строки](https://learn.javascript.ru/string)                                                                                | 
| 7. | [Symbol](https://tc39.es/ecma262/multipage/ecmascript-data-types-and-values.html#sec-ecmascript-language-types-symbol-type)       | [Тип данных Symbol](https://learn.javascript.ru/symbol)                                                                     | 
| 8. | [Object](https://tc39.es/ecma262/multipage/ecmascript-data-types-and-values.html#sec-object-type)                                 |                                                                                                                             | 
  
| `typeof` *value*                     | Result                                                  | Maybe it would be better this way                                         |
|--------------------------------------|---------------------------------------------------------|---------------------------------------------------------------------------|
| Undefined                            | "undefined"                                             | or `value === undefined`                                                  |
| Null                                 | ["object"](https://2ality.com/2013/10/typeof-null.html) | use `value === null` or `typeof value === 'object' && value == undefined` |
| Boolean                              | "boolean"                                               | `value === true` or `value === false`                                     |
| Number                               | "number"                                                |
| String                               | "string"                                                |
| Symbol                               | "symbol"                                                |
| BigInt                               | "bigint"                                                |
| Object (does not implement [[Call]]) | "object"                                                |
| Object (implements [[Call]])         | "function"                                              |
<br/>

|           | [ToBoolean](https://tinyurl.com/r7v9y9n9)                   | [ToNumber](https://tinyurl.com/ur5yaxkh)                                                                                                       | [ToBigInt](https://tinyurl.com/3tk59vvr)       | [ToString](https://tinyurl.com/mxe9adyw)         | [ToObject](https://tinyurl.com/35nbcfmm)             |
|-----------|-------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------|--------------------------------------------------|------------------------------------------------------|
| Undefined | `false`                                                     | `NaN`                                                                                                                                          | TypeError                                      | `"undefined"`                                    | TypeError                                            |
| Null      | `false`                                                     | `0`                                                                                                                                            | TypeError                                      | `"null"`                                         | TypeError                                            |
| Boolean   | -                                                           | `1`/`0`                                                                                                                                        | `1n`/`0n`                                      | `"true"/"false"`                                 | [`new Boolean(value)`](https://tinyurl.com/4ferbkt5) |
| Number    | `-0` &#124;&#124; `0` &#124;&#124; `NaN` ? `false` : `true` | -                                                                                                                                              | TypeError                                      | [Number::toString](https://tinyurl.com/wrvtv3yy) | [`new Number(value)`](https://tinyurl.com/5ut8m98v)  |
| BigInt    | `0n` ? `false` : `true`                                     | TypeError                                                                                                                                      | -                                              | [BigInt::toString](https://tinyurl.com/m6zhrvre) | [`new BigInt(value)`](https://tinyurl.com/2zr4dpsa)  |
| String    | length === 0 ? `false` : `true`                             | [StringToNumber](https://tinyurl.com/v237tfs7),<br/> [parseInt](https://tinyurl.com/jwa6wue8),<br/> [parseFloat](https://tinyurl.com/vebyn2rb) | [StringToBigInt](https://tinyurl.com/27hu7bfu) | -                                                | [`new String(value)`](https://tinyurl.com/x92yace8)  |
| Symbol    | `true`                                                      | TypeError                                                                                                                                      | TypeError                                      | TypeError                                        | [`new Symbol(descr)`](https://tinyurl.com/ysen32ad)  |
| Object    | `true`                                                      | [ToPrimitive](https://tinyurl.com/j4dxw9ps)                                                                                                    | -                                              | [ToPrimitive](https://tinyurl.com/j4dxw9ps)      | -                                                    |

- [Преобразование объектов в примитивы](https://learn.javascript.ru/object-toprimitive)
- [Пользовательский «toJSON»](https://learn.javascript.ru/json#polzovatelskiy-tojson)
<br/>
  
### Сравнение на равенство

`==` [Нестрогое сравнение на равенство](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-islooselyequal)

`===` [Строгое сравнение на равенство](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-isstrictlyequal)

Возможно, вместо `===` стоит использовать [Object.is](https://tc39.es/ecma262/multipage/fundamental-objects.html#sec-object.is)

### leftValue operator rightValue 

Operators: `**`, `*`, `/`, `%`, `+`, `-`, `<<`, `>>`, `>>>`, `&`, `^`, `|`.  
[ApplyStringOrNumericBinaryOperator](https://tc39.es/ecma262/multipage/ecmascript-language-expressions.html#sec-applystringornumericbinaryoperator)
