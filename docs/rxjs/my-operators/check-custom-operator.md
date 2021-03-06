# Проверка кастомного оператора на утечку

1. Проверка на самостоятельный `complete`. Например, `myTake` после 3х элементов должен завершить поток и, как следствие, `interval` должен сделать `clearInterval` и выгрузиться из памяти.
2. Проверка на `complete`, если нижестоящий подписчик отпишется. Например, после отписки по таймауту `subscription.unsubscribe()`, `interval` должен сделать `clearInterval` и выгрузиться из памяти.
3. Проверка того, что происходит проброс `complete`, `error`. Например, когда `myTake` сделает `complete`, то должна быть вызвана комплит в обсервере и строка лога `console.log(`COMPLETE`,)` отработать.

```typescript
import {finalize, interval} from 'rxjs';

let subscription = interval(1000).pipe(
    myTake(3),
    myMap((x, i) => `[${x}], index ${i}`),
    finalize(() => console.log(`FINALIZE`,)),
).subscribe({
    next(value) {
        console.log(`next`, value)
    },
    error(err) {
        console.log(`err`, err)
    },
    complete() {
        console.log(`COMPLETE`,)
    }
});

setTimeout(() => subscription.unsubscribe(), 10000);
```
