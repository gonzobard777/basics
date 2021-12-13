# Система типов TypeScript

## Думать о типах как о множестве значений (наборе значений)

| TypeScript term       | Set term               |
|-----------------------|------------------------|
| `never`               | ∅ (empty set)          |
| Literal type          | Single element set     |
| Value assignable to T | Value ∈ T (member of)  |
| T1 assignable to T2   | T1 ⊆ T2 (subset of)    |
| T1 extends T2         | T1 ⊆ T2 (subset of)    |
| T1 &#124; T2          | T1 ∪ T2 (union)        |
| T1 & T2               | T1 ∩ T2 (intersection) |
| `unknown`             | Universal set          |

Самое маленькое множество – это пустое множество, в котором нет значений – ∅. В TypeScript он соответствует типу `never`.

```typescript
const x: never = 'A';
// Type 'string' is not assignable to type 'never'.
```

Следующие наименьшие множества – это те, которые содержат одиночные значения. Они соответствуют литеральным типам в TypeScript, также известным как unit types:

```typescript
type A = 'A';
type B = 'B';
type Twelve = 12;
```

Один тип может объединять в себе несколько множеств:

```typescript
type AB = 'A' | 'B';
type AB12 = 'A' | 'B' | 12;
type ABnumber = 'A' | 'B' | number;
```

В сообщениях об ошибках в TypeScript часто фигурирует слово "assignable" (может быть назначен). В контексте множеств значений это означает:

- The Value is a **member of** the Set – для отношений между значением и типом;
- The SetB is a **subset of** the SetA – для отношений между двумя типами.

Почти все, что делает средство проверки типов, – это проверяет, является ли одно множество подмножеством другого:

```typescript
const a: AB = 'A'; // OK, "A" is a member of "A" | "B"
const ab: AB = Math.random() < 0.5 ? 'A' : 'B'; // OK, "A" | "B" is a subset of "A" | "B"
const ab12: AB12 = ab; // OK, "A" | "B" is a subset of "A" | "B" | 12
declare let twelve: AB12;
const back: AB = twelve;
// Type 'AB12' is not assignable to type 'AB'
// Type '12' is not assignable to type 'AB'
```
