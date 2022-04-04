# Декоратор Class'а с параметрами

```typescript
function forClass() {
  return (target: object) => {
    console.log('run @forClass');
  };
}

@forClass()
class Some {
  constructor(private name: string) {
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

function forClass() {
  return (target) => {
    console.log('run @forClass');
  };
}

let Some = class Some {
  constructor(name) {
    this.name = name;
  }
};
Some = __decorate([
  forClass(),
  __metadata("design:paramtypes", [String])
], Some);
```
