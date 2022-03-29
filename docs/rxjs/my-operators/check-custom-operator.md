# Проверка кастомного оператора на утечку

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
