# Декоратор Accessor property класса

```typescript
declare type AccessorDecorator = <T>(target: Object, propertyKey: string | symbol, descriptor: TypedPropertyDescriptor<T>) => TypedPropertyDescriptor<T> | void;
```

[**Accessor Decorator**](https://www.typescriptlang.org/docs/handbook/decorators.html#accessor-decorators)

```typescript
function forAccessorProperty() {
  return (target: object, propName: string | symbol, propDescr: PropertyDescriptor) => {
    console.log('run @forAccessorProperty');
  };
}

class Some {

  @forAccessorProperty()
  get age() {
    return 21;
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

function forAccessorProperty() {
  return (target, propName, propDescr) => {
    console.log('run @forAccessorProperty');
  };
}

class Some {
  get age() {
    return 21;
  }
}

__decorate([
  forAccessorProperty(),
  __metadata("design:type", Object),
  __metadata("design:paramtypes", [])
], Some.prototype, "age", null);
```
