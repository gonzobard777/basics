
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
  
|             | Undefined   | Null        | [ToBoolean](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-toboolean) | [ToString](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-tostring)                                           | Symbol      | [ToNumber](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-tonumber)       | [ToBigInt](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-tobigint) | [ToObject](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-toobject) |
|-------------|-------------|-------------|---------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|-------------|-------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|
| Undefined   | -           | -           | `false`                                                                               | `"undefined"`                                                                                                                 | -           | `NaN`                                                                                     | TypeError                                                                           | TypeError                                                                           |
| Null        | -           | -           | `false`                                                                               | `"null"`                                                                                                                      | -           | `+0`                                                                                      | TypeError                                                                           | TypeError                                                                           |
| Boolean     | -           | -           | -                                                                                     | `"true"/"false"`                                                                                                              | -           | `1`/`+0`                                                                                  | `1n`/`0n`                                                                           | `Boolean(значение)`                                                                 |
| Number      | -           | -           | `0` &#124;&#124; `NaN` ? `false` : `true`                                             | [Number::toString](https://tc39.es/ecma262/multipage/ecmascript-data-types-and-values.html#sec-numeric-types-number-tostring) | -           | -                                                                                         | TypeError                                                                           | `Number(значение)`                                                                  |
| BigInt      | -           | -           | `0n` ? `false` : `true`                                                               | [BigInt::toString](https://tc39.es/ecma262/multipage/ecmascript-data-types-and-values.html#sec-numeric-types-bigint-tostring) | -           | TypeError                                                                                 | -                                                                                   | `BigInt(значение)`                                                                  |
| String      | -           | -           | length is 0 ? `false` : `true`                                                        | -                                                                                                                             | -           | `алгоритм `                                                                               | `алгоритм`                                                                          | `String(значение)`                                                                  |
| Symbol      | -           | -           | `true`                                                                                | TypeError                                                                                                                     | -           | TypeError                                                                                 | TypeError                                                                           | `Symbol(значение)`                                                                  |
| Object      | -           | -           | `true`                                                                                | [ToPrimitive](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-toprimitive)                                     | -           | [ToPrimitive](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-toprimitive) | -                                                                                   | -                                                                                   |

- [Преобразование объектов в примитивы](https://learn.javascript.ru/object-toprimitive)
- [Пользовательский «toJSON»](https://learn.javascript.ru/json#polzovatelskiy-tojson)
<br/>
<br/>
  
| `typeof` *value*                     | Result
|--------------------------------------|--------
| Undefined                            | "undefined"
| Null                                 | ["object"](https://2ality.com/2013/10/typeof-null.html)
| Boolean                              | "boolean"
| Number                               | "number"
| String                               | "string"
| Symbol                               | "symbol"
| BigInt                               | "bigint"
| Object (does not implement [[Call]]) | "object"
| Object (implements [[Call]])         | "function"
<br/>
  
### Сравнение на равенство `==`, `===`

`==` [Нестрогое сравнение на равенство](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-islooselyequal)

`===` [Строгое сравнение на равенство](https://tc39.es/ecma262/multipage/abstract-operations.html#sec-isstrictlyequal)

Возможно, вместо `===` стоит использовать [Object.is](https://tc39.es/ecma262/multipage/fundamental-objects.html#sec-object.is)
