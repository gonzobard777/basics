### Сравнение на равенство `==`, `===`
[Equality Operators](https://262.ecma-international.org/12.0/#sec-equality-operators)  

`===` [Строгое сравнение на равенство](https://262.ecma-international.org/12.0/#sec-strict-equality-comparison)

`==` [Абстрактное сравнение на равенство](https://262.ecma-international.org/12.0/#sec-abstract-equality-comparison)


| Типы                                                                                                 |                                                      | Конвертация типов                                                               |
|------------------------------------------------------------------------------------------------------|------------------------------------------------------|---------------------------------------------------------------------------------|
| 1. [Undefined](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-undefined-type)| Значение не было определено. Не примитив И не объект | [Type Conversion](https://262.ecma-international.org/12.0/#sec-type-conversion) |
| 2. [Null](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-null-type)          | Намеренное отсутствие какого-либо значения объекта   |
| 3. [Boolean](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-boolean-type)    |                                                      |
| 4. [String](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-string-type)      |                                                      |
| 5. [Symbol](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-symbol-type)      |                                                      |
| 6. [Number](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-number-type)      |                                                      |
| 7. [BigInt](https://262.ecma-international.org/12.0/#sec-ecmascript-language-types-bigint-type)      |                                                      |
| 8. [Object](https://262.ecma-international.org/12.0/#sec-object-type)


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

#### Links
[JavaScript history: `undefined`](https://2ality.com/2013/05/history-undefined.html)
