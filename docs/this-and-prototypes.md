# `this` и прототипы объектов

## `this`

Значение `this` каждый раз при вызове функции **вычисляется** заново.  
Чтобы ответить на вопрос: на что указывает ссылка `this`? - необходимо проанализировать **фактическое место вызова функции** (call-site). 

Правила определения значение `this` (в порядке приоритета):

**1.** Функция вызвана с `new`? Если да, то `this` содержит новый сконструированный объект:

```js
const obj = new fn(); // this = какой-то новый объект
```

**2.** Функция вызвана с `call` или `apply` (явное связывание), либо `bind` (жесткое связывание)? Если да, тогда `this` содержит явно переданный объект:

```js
fn.call(obj);
fn.apply(obj);
const boundFn = fn.bind(obj);
```

**3.** Функция вызвана с объектом-владельцем (неявное связывание), также называемым "контекстом"? Если да, то `this` содержит контекстный объект:

```js
obj.fn(); // this = obj
``` 

См. описание [внутренней реализации](https://learn.javascript.ru/object-methods#vnutrennyaya-realizatsiya-ssylochnyy-tip).

**4.** В остальных случаях используется `this` по умолчанию. Если действует strict режим, выбирается `undefined`, а если нет – [глобальный контекст](https://developer.mozilla.org/en-US/docs/Glossary/Global_object):

```js
fn();
``` 

### Исключение – стрелочные функции

Стрелочные функции берут `this` из [лексической области видимости](./scope-and-closures/kyle_simpson_vision.md#%D0%BE%D0%B1%D0%BB%D0%B0%D1%81%D1%82%D0%B8-%D0%B2%D0%B8%D0%B4%D0%B8%D0%BC%D0%BE%D1%81%D1%82%D0%B8). Например:

```js
function foo() {
  return (a) => console.log(this.a);
}

const obj1 = {
  a: 2,
};
const obj2 = {
  a: 3,
};
const bar = foo.call(obj1);
bar.call(obj2); // 2, не 3!
```

## Checks

```js
const obj = {
  id: 'obj.id',
  log: function someFn() {
    console.log(this.id);
  }
}
obj.log(); //?
setTimeout(obj.log, 1000); //?
```

```js
const obj = {
  id: 'obj.id',
  log: () => {
    console.log(this.id);
  }
}
obj.log(); //?
setTimeout(obj.log, 1000); //?
```

```js
"use strict";

function foo() {
  console.log(this.a);
}

var a = 2;
foo();
```

```js
const obj2 = {
  a: 42,
  foo() {
    console.log(this.a);
  },
};
let obj1 = {
  a: 2,
  obj2,
};
obj1.obj2.foo(); 
```

```js
let arrowFn = () => {
  console.log('hi');
}
const obj = new arrowFn();
```
