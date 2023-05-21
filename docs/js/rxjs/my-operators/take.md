# Оператор `take`

```typescript
import {MonoTypeOperatorFunction, Observable} from 'rxjs';

export function myTake<T>(max = Infinity): MonoTypeOperatorFunction<T> {
    let count = 0;
    return source$ => {
        return new Observable(subscriber =>
            source$.subscribe({
                next(x) {
                    if (count < max) {
                        subscriber.next(x);
                        count++;
                    } else
                        subscriber.complete();
                },
                error(err) {
                    subscriber.error(err);
                },
                complete() {
                    subscriber.complete();
                },
            })
        );
    };
}
```
