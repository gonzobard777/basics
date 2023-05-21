# Декоратор Class'а

```typescript
declare type ClassDecorator = <TFunction extends Function>(target: TFunction) => TFunction | void;
```

[**Class Decorator**](https://www.typescriptlang.org/docs/handbook/decorators.html#class-decorators)

- [Class без параметров](class-no-params.md)
- [Class с параметрами](class-with-params.md)
