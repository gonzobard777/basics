# Декораторы

- [Class](./class/README.md)
- [Data property класса](./prop-data/README.md)
- [Accessor property класса](./prop-accessor/README.md)
- [Method класса](./method/README.md)
- [Parameter метода класса](./method-parameter/README.md)

Могут быть использованы функции из пакета "reflect-metadata":

- [`Reflect.decorate`](https://github.com/rbuckton/reflect-metadata/blob/3aeb98af4030be664a66f49bfd164936e0ba1825/Reflect.js#L112)
  - [`DecorateConstructor`](https://github.com/rbuckton/reflect-metadata/blob/3aeb98af4030be664a66f49bfd164936e0ba1825/Reflect.js#L538)
  - [`DecorateProperty`](https://github.com/rbuckton/reflect-metadata/blob/3aeb98af4030be664a66f49bfd164936e0ba1825/Reflect.js#L550)
- [`Reflect.metadata`](https://github.com/rbuckton/reflect-metadata/blob/3aeb98af4030be664a66f49bfd164936e0ba1825/Reflect.js#L176)
  - [`OrdinaryDefineOwnMetadata`](https://github.com/rbuckton/reflect-metadata/blob/3aeb98af4030be664a66f49bfd164936e0ba1825/Reflect.js#L619)

Настройки TypeScript'а:

- [`experimentalDecorators`](https://www.typescriptlang.org/tsconfig#experimentalDecorators)
- [`emitDecoratorMetadata`](https://www.typescriptlang.org/tsconfig#emitDecoratorMetadata)
  - `"design:type"`
  - `"design:paramtypes"`
  - `"design:returntype"`

## Порядок вызова декораторов

- [Decorator Evaluation](https://www.typescriptlang.org/docs/handbook/decorators.html#decorator-evaluation)

## Несколько декораторов для одного объявления

- [Decorator Composition](https://www.typescriptlang.org/docs/handbook/decorators.html#decorator-composition)

### Links

- [Могучие Typescript Декораторы — как работают, во что компилируются и для каких прикладных задач применимы](https://habr.com/ru/post/494668/)
