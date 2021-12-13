# Система типов TypeScript

## Думать о типах как о множестве(наборе) значений

Самое маленькое множество – это пустое множество, в котором нет значений. В TypeScript он соответствует типу `never`.

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

Разные множества можно объединять в одно:

```typescript
type AB = 'A' | 'B';
type AB12 = 'A' | 'B' | 12;
type ABnumber = 'A' | 'B' | number;
```

Во многих сообщениях об ошибках в TypeScript фигурирует слово assignable (может быть назначен). В контексте множеств значений это означает либо "member of" (для отношений между значением и типом), либо "subset of" (для отношений между двумя типами).  
Почти все, что делает средство проверки типов, – это проверяет, является ли одно множество подмножеством другого:

```typescript
// OK, "A" | "B" is a subset of "A" | "B":
const ab: AB = Math.random() < 0.5 ? 'A' : 'B';
const ab12: AB12 = ab; // OK, "A" | "B" is a subset of "A" | "B" | 12
declare let twelve: AB12;
const back: AB = twelve;
// Type 'AB12' is not assignable to type 'AB'
// Type '12' is not assignable to type 'AB'
```

| TypeScript term       | Set term               |
|-----------------------|------------------------|
| `never`               | ∅ (empty set)          |
| Literal type          | Single element set     |
| Value assignable to T | Value ∈ T (member of)  |
| T1 assignable to T2   | T1 ⊆ T2 (subset of)    |
| T1 extends T2         | T1 ⊆ T2 (subset of)    |
| T1 &#124;&#124; T2    | T1 ∪ T2 (union)        |
| T1 & T2               | T1 ∩ T2 (intersection) |
| `unknown`             | Universal set          |