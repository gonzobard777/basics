# Оператор `map`

```typescript
import {Observable, OperatorFunction} from 'rxjs';

export function myMap<T, R>(fn: (value: T, index: number) => R): OperatorFunction<T, R> {
  let index = 0;
  return source$ => {
    return new Observable(subscriber =>
      source$.subscribe({
        next(x) {
          const result = fn(x, index);
          index++;
          subscriber.next(result);
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
