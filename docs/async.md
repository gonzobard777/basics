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
