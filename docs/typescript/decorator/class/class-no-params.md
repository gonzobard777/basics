# Декоратор Class'а без параметров

```typescript
function forClass() {
  return (target: object) => {
    console.log('run @forClass');
  };
}

@forClass()
class Some {
}
```

преобразуется в:

```javascript
'use strict';
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
  var c = arguments.length;
  var r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
  if (typeof Reflect === 'object' && typeof Reflect.decorate === 'function')
    r = Reflect.decorate(decorators, target, key, desc);
  else {
    for (var i = decorators.length - 1; i >= 0; i--) {
      if (d = decorators[i])
        r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    }
  }
  return c > 3 && r && Object.defineProperty(target, key, r), r;
};

function forClass() {
  return (target) => {
    console.log('run @forClass');
  };
}

let Some = class Some {
}
Some = __decorate([
  forClass()
], Some);
```
