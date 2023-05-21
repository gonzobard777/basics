# Декоратор Parameter'а метода класса

```typescript
declare type ParameterDecorator = (target: Object, propertyKey: string | symbol, parameterIndex: number) => void;
```

[**Parameter Decorator**](https://www.typescriptlang.org/docs/handbook/decorators.html#parameter-decorators)

```typescript

function forClass() {
  return (target: object) => {
    console.log('run @forClass');
  };
}

function forParamCtor() {
  return (target: object, propKey: string | symbol, paramIndex: number) => {
    console.log('run @forParamCtor', propKey, paramIndex);
  };
}

function forParamMethod() {
  return (target: object, propKey: string | symbol, paramIndex: number) => {
    console.log('run @forParamMethod', propKey, paramIndex);
  };
}

@forClass()
class Some {

  constructor(@forParamCtor() say: string) {
  }

  print(@forParamMethod() say: string) {
    console.log('print()');
  }

}
```

преобразуется в:

```javascript
"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
  var c = arguments.length;
  var r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
  if (typeof Reflect === "object" && typeof Reflect.decorate === "function")
    r = Reflect.decorate(decorators, target, key, desc);
  else {
    for (var i = decorators.length - 1; i >= 0; i--) {
      if (d = decorators[i])
        r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    }
  }
  return c > 3 && r && Object.defineProperty(target, key, r), r;
};

var __metadata = (this && this.__metadata) || function (k, v) {
  if (typeof Reflect === "object" && typeof Reflect.metadata === "function")
    return Reflect.metadata(k, v);
};

var __param = (this && this.__param) || function (paramIndex, decorator) {
  return function (target, key) {
    decorator(target, key, paramIndex);
  }
};

function forClass() {
  return (target) => {
    console.log('run @forClass');
  };
}

function forParamCtor() {
  return (target, propKey, paramIndex) => {
    console.log('run @forParamCtor', propKey, paramIndex);
  };
}

function forParamMethod() {
  return (target, propKey, paramIndex) => {
    console.log('run @forParamMethod', propKey, paramIndex);
  };
}

let Some = class Some {
  constructor(say) {
  }

  print(say) {
    console.log('print()');
  }
};
__decorate([
  __param(0, forParamMethod()),
  __metadata("design:type", Function),
  __metadata("design:paramtypes", [String]),
  __metadata("design:returntype", void 0)
], Some.prototype, "print", null);
Some = __decorate([
  forClass(),
  __param(0, forParamCtor()),
  __metadata("design:paramtypes", [String])
], Some);
```

результат работы кода:

```
"run @forParamMethod",  "print",  0
"run @forParamCtor",  undefined,  0
"run @forClass"
```
