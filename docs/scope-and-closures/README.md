# Области видимости и замыкания

## Области видимости

- [конспект](./by-specification.md) при прочтении спецификации ECMA-262;
- [конспект](./kyle_simpson_vision.md) при прочтении книги [You Don't Know JS: Scope & Closures](https://www.amazon.com/gp/product/1449335586/ref=dbs_a_def_rwt_bibl_vppi_i8).

Для каждого контекста выполнения – ExecutionContext – справедливо следующее:

1. Создание и заполнение ExecutionContext. По декларациям создаются переменные и функции в соответствующих environment.
2. Выполнение ExecutionContext. Здесь строчка за строчкой выполняется код (переменным присваиваются значения именно на этом этапе).

## Замыкания

**Замыкание** – это способность функции запоминать свою лексическую область видимости и обращаться к ней, даже когда функция вызывается за пределами своей лексической области видимости.

## Checks

```js
"use strict";
console.log(someVariable123);
```

```js
"use strict";
const obj = {hello: "world"};
console.log(obj.abc);
```

```js
a = 2;
var a;
console.log(a);
```

```js
console.log(a);
var a = 2;
```

```js
if (true) {
  console.log(foo);
  const foo = 123;
}
```

```js
function foo(a) {
  console.log(a + b);
  b = 2;
}

foo(2);
```

```js
function foo() {
  var a = 123;
  console.log(a);
}

foo();
console.log(a);
```

```js
function foo(a) {
  console.log(a + b);
}

var b = 2;
foo(2);
```

```js
if (true) {
  var a = 123;
  console.log('if', a);
}
console.log('global', a);
```

```js
if (true) {
  let a = 123;
  console.log('if', a);
}
console.log('global', a);
```

```js
if (true) {
  foo(1);

  function foo(a) {
    console.log(a * 10);
  }
}
foo(2);
```

```js
foo();
if (true) {
  function foo() {
    console.log(1);
  }
} else {
  function foo() {
    console.log(2);
  }
}
```

```js
if (true) {
  function foo() {
    console.log(1);
  }
} else {
  function foo() {
    console.log(2);
  }
}
foo();
```

```js
foo(1);
var foo = (a) => {
  console.log(a * 10);
};
```

```js
var foo = function bar(a) {
  console.log(a * 10);
};
foo(2);
bar(1);
```

```js
for (var i = 1; i <= 5; i++) { // и другой вариант, где: let i = 1 
  const timerId = setTimeout(() => {
    console.log(i);
  }, i * 1000);
}
```

```js
foo();

var foo = 3;

function foo() {
  console.log(1);
}

foo = function foo() {
  console.log(2);
};

foo();
```

```js
foo();

function foo() {
  console.log(1);
}

foo = function foo() {
  console.log(2);
};

function foo() {
  console.log(3);
}

foo();
```

```js
var value = "global";

function dynamicScope() {
  const value = "lexical";
  return function () {
    console.log(value);
  }
}

function lexicalScope() {
  var value = "dynamic";
  return function () {
    console.log(value);
  }
}

dynamicScope()();
lexicalScope()();
```

```js
function makeCounter() {
  var count = 1;
  return () => console.log(count++);
}

function makeCounter(count) {
  return function () {
    return console.log(count++);
  }
}

const first = makeCounter(4);
const second = makeCounter(8);

first();
first();
second();
```
