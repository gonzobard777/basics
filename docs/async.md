# Асинхронность

### Checks

```javascript
console.log('before');
new Promise(resolve => {
  resolve('promise.resolve');
  console.log('next line');
}).then(x => console.log(x + ' 123'));
console.log('after');
```

```javascript
async function printHello() {
  console.log('hello');
}

async function run() {
  console.log('1');
  await printHello();
  console.log('2');
}

run();
console.log('3');
```
