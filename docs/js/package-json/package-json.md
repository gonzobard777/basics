# package.json

## Поля, которые использует Node.js (другие поля игнорирует)

[Node.js `package.json` field definitions](https://nodejs.org/api/packages.html#nodejs-packagejson-field-definitions)

- [`name`](https://tinyurl.com/hs87ntxz)
- [`main`](https://tinyurl.com/3uxynps4)
- [`packageManager`](https://tinyurl.com/yckheed4)
- [`type`](https://tinyurl.com/vu76nf6n)
  - [Determining module system](https://nodejs.org/api/packages.html#determining-module-system)
- [`exports`](https://tinyurl.com/2p8rmv9f)
  - [Version selection with `typesVersions`](https://www.typescriptlang.org/docs/handbook/declaration-files/publishing.html#version-selection-with-typesversions)
  - [habr. Exports в package.json](https://habr.com/ru/company/space307/blog/546240/)
  - [2ality. TypeScript and native ESM on Node.js](https://2ality.com/2021/06/typescript-esm-nodejs.html)
  - [пример exports в RxJs](https://github.com/ReactiveX/rxjs/blob/master/package.json)
- [`imports`](https://tinyurl.com/42975ypr)

## Поля, которые использует npm

[Specifics of npm's `package.json` handling](https://docs.npmjs.com/cli/v8/configuring-npm/package-json)

О некоторых из них:

- [`bin`](https://docs.npmjs.com/cli/v8/configuring-npm/package-json#bin)
  - [A guide to creating a NodeJS command-line package](https://medium.com/netscape/a-guide-to-create-a-nodejs-command-line-package-c2166ad0452e)

## Настройка пакета для экспорта js и types

### Вариант 1

Вроде нет проблем с импортом.  
Это полная версия, если надо и ES-модули и cjs, но по умолчанию ES-модули:

```
"type": "module",
"main": "./lib/index.cjs",
"types": "./lib/index.d.ts",
"module": "./lib/index.js",
"exports": {
  ".": {
    "require": "./lib/index.cjs",
    "import": "./lib/index.js",
    "types": "./lib/index.d.ts"
  }
},
```

### Вариант 2

Webstorm в большинстве случаев некорректно импортирует.  
Но всегда падает при сборке(что плюс):

```
"exports": "./dist/cjs/index.js",
"typesVersions": {
  "*": {
    "*": [
      "dist/types/*"
    ]
  }
},
```
