# `this` и прототипы объектов

Значение `this` каждый раз заново **передается** функции в момент ее вызова.  
Необходимо проанализировать **фактическое место вызова функции** (call-site), чтобы ответить на вопрос: на что указывает ссылка `this`?

### 1. Функция вызвана с `new`? Если да, то `this` содержит новый сконструированный объект:

```js
const obj = new fn(); // this = какой-то новый объект
```

#### 2. Функция вызвана с `call` или `apply` (явное связывание), либо `bind` (жесткое связывание)? Если да, тогда `this` содержит явно заданный объект:

```js
fn.call(obj);
fn.apply(obj);
fn.bind(obj);
```

3. Функция вызвана с контекстом (неявное связывание), также называемым объектом-владельцем? Если да, то `this` содержит контекстный объект:

```js
obj.fn(); // this = obj
``` 

4. В остальных случаях используется `this` по умолчанию. Если действует strict режим, выбирается `undefined`, а если нет – глобальный контекст:

```js
fn();
``` 

### Checks

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
