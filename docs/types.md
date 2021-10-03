### Сравнение на равенство `==`, `===`
[Equality Operators](https://262.ecma-international.org/12.0/#sec-equality-operators)  

`===` [Строгое сравнение на равенство](https://262.ecma-international.org/12.0/#sec-strict-equality-comparison)

`==` [Абстрактное сравнение на равенство](https://262.ecma-international.org/12.0/#sec-abstract-equality-comparison)

Возможно, вместо `===` стоит использовать [Object.is](https://262.ecma-international.org/12.0/#sec-object.is)

|    | Типы                                                                                                 |                                                                        | [Конвертация типов](https://262.ecma-international.org/12.0/#sec-type-conversion)
|----|------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| 1. | [Undefined](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-undefined-type)| Отсутствует значение, т.к. не было определено. [Не примитив И не объект](https://2ality.com/2013/05/history-undefined.html) | 
| 2. | [Null](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-null-type)          | Намеренное отсутствие какого-либо значения Объекта/Примитива                                                                | 
| 3. | [Boolean](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-boolean-type)    |                                                                                                                             | [ToBoolean](https://262.ecma-international.org/12.0/#sec-toboolean)
| 4. | [String](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-string-type)      | [Строки](https://learn.javascript.ru/string)                                                                                | [ToString](https://262.ecma-international.org/12.0/#sec-tostring)
| 5. | [Symbol](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-symbol-type)      | [Тип данных Symbol](https://learn.javascript.ru/symbol)                                                                     | 
| 6. | [Number](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-number-type)      | [Числа](https://learn.javascript.ru/number)                                                                                 | [ToNumber](https://262.ecma-international.org/12.0/#sec-tonumber)
| 7. | [BigInt](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-bigint-type)      | [BigInt](https://learn.javascript.ru/bigint)                                                                                | [ToBigInt](https://262.ecma-international.org/12.0/#sec-tobigint)
| 8. | [Object](https://262.ecma-international.org/12.0/#sec-object-type)                                |                                                                                                                             | [ToPrimitive](https://262.ecma-international.org/12.0/#sec-toprimitive), [Преобразование объектов в примитивы](https://learn.javascript.ru/object-toprimitive), [Пользовательский «toJSON»](https://learn.javascript.ru/json#polzovatelskiy-tojson)

|             | Undefined   | Null        | Boolean                         | String                        | Symbol      | Number                              | BigInt                      | Object              |
|-------------|-------------|-------------|---------------------------------|-------------------------------|-------------|-------------------------------------|-----------------------------|---------------------|
| Undefined   | -           | -           | `false`                         | `"undefined"`                 | -           | `NaN`                               | TypeError exception         | TypeError exception |
| Null        | -           | -           | `false`                         | `"null"`                      | -           | `+0`                                | TypeError exception         | TypeError exception |
| Boolean     | -           | -           | -                               | `"true"/"false"`              | -           | `1`/`+0`                            | `1n`/`0n`                   | `Boolean(значение)` |
| String      | -           | -           | length is 0 ? `false` : `true`  | `"значение"/"NaN"/"Infinity"` | -           | ToNumber Applied to the String Type | алгоритм                    | `String(значение)`  |
| Symbol      | -           | -           | `true`                          | `"значение"`                  | -           | TypeError exception                 | TypeError exception         | `Symbol(значение)`  |
| Number      | -           | -           | `0` or `NaN` ? `false` : `true` | TypeError Exception           | -           | -                                   | TypeError exception         | `Number(значение)`  |
| BigInt      | -           | -           | `0` ? `false` : `true`          | BigInt::toString              | -           | TypeError exception                 | -                           | `BigInt(значение)`  |
| Object      | -           | -           | `true`                          | ToPrimitive                   | -           | ToPrimitive                         | -                           | -                   |



### `typeof` Operator Results

[The typeof Operator](https://262.ecma-international.org/12.0/#sec-typeof-operator)

| Type of val                          | Result
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

