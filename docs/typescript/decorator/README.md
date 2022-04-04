# Декораторы

- [Class](./class/README.md)
- [Data property класса](./data-prop/README.md)
- [Accessor property класса](https://www.typescriptlang.org/docs/handbook/decorators.html#accessor-decorators)
- [Method класса](./method/README.md)
- [Parameter метода класса](https://www.typescriptlang.org/docs/handbook/decorators.html#parameter-decorators)

Могут быть использованы функции из пакета "reflect-metadata":

- [`Reflect.decorate`](https://github.com/rbuckton/reflect-metadata/blob/3aeb98af4030be664a66f49bfd164936e0ba1825/Reflect.js#L112)
  - [`DecorateConstructor`](https://github.com/rbuckton/reflect-metadata/blob/3aeb98af4030be664a66f49bfd164936e0ba1825/Reflect.js#L538)
  - [`DecorateProperty`](https://github.com/rbuckton/reflect-metadata/blob/3aeb98af4030be664a66f49bfd164936e0ba1825/Reflect.js#L550)
- [`Reflect.metadata`](https://github.com/rbuckton/reflect-metadata/blob/3aeb98af4030be664a66f49bfd164936e0ba1825/Reflect.js#L176)
  - [`OrdinaryDefineOwnMetadata`](https://github.com/rbuckton/reflect-metadata/blob/3aeb98af4030be664a66f49bfd164936e0ba1825/Reflect.js#L619)

## Порядок вызова декораторов

- [Decorator Evaluation](https://www.typescriptlang.org/docs/handbook/decorators.html#decorator-evaluation)

## Несколько декораторов для одного объявления

- [Decorator Composition](https://www.typescriptlang.org/docs/handbook/decorators.html#decorator-composition)

### Links

- [Могучие Typescript Декораторы — как работают, во что компилируются и для каких прикладных задач применимы](https://habr.com/ru/post/494668/)
