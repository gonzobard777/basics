# Декоратор Method'а класса

```typescript
declare type MethodDecorator = <T>(target: Object, propertyKey: string | symbol, descriptor: TypedPropertyDescriptor<T>) => TypedPropertyDescriptor<T> | void;
```

[**Method Decorator**](https://www.typescriptlang.org/docs/handbook/decorators.html#method-decorators)

```typescript
function forMethod() {
  return (target: object, propName: string | symbol, propDescr: PropertyDescriptor) => {
    console.log('run @forMethod');
  };
}

class Some {
  @forMethod()
  print() {
    console.log();
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

function forMethod() {
  return (target, propName, propDescr) => {
    console.log('run @forMethod');
  };
}

class Some {
  print() {
    console.log();
  }
}

__decorate([
  forMethod(),
  __metadata("design:type", Function),
  __metadata("design:paramtypes", []),
  __metadata("design:returntype", void 0)
], Some.prototype, "print", null);
```
