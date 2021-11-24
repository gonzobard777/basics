# `this` и прототипы объектов

`this` автоматически определяется в области видимости каждой функции.

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
