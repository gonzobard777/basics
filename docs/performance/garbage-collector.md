- [garbage.collect() by Андрей Роенко](https://habr.com/ru/company/oleg-bunin/blog/433318/)
- [Trash talk: the Orinoco garbage collector](https://v8.dev/blog/trash-talk)
- [Chrome DevTools - Memory](https://developer.chrome.com/docs/devtools/#memory)
- [Description of Tools for developers trying to understand memory usage](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/memory/tools.md)
    - [MemoryInfra - where memory is being used in your system](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/memory-infra)

## Терминология

**Shared memory** - совместная память процесса - объем используемой процессом физической памяти, которая может использоваться совместно с другими процессами.  
**Private memory** - собственная память процесса - объем используемой процессом физической памяти, которая не может использоваться другими процессами.  
**JavaScript memory** - он же JS Heap - объем физической памяти, занимаемой js вообще и живыми объектами в частности.  
**Memory footprint** - предположительно включает в себя Private memory и JS Heap. Но это не точно.

# Известные кейсы / подходы

## JS Heap

### new ReplaySubject(), shareReplay()

При таком создании: `new ReplaySubject()` – в `bufferSize` [назначится](https://github.com/ReactiveX/rxjs/blob/master/src/internal/ReplaySubject.ts) `Infinity`.  B долгоживущих обектах это гарантированно приведет к росту JS Heap.  
[Аналогичная ситуация](https://github.com/ReactiveX/rxjs/blob/master/src/internal/operators/shareReplay.ts) при таком использовании оператора: `shareReplay()` – без указания `bufferSize`.

### Объект без корня

Если в Summary снапшота значение в колонке [Distance](https://developer.chrome.com/docs/devtools/memory-problems/memory-101/#retained_size) отлично от числового, то объект повис в каком-то контексте и GC не сможет его убрать, например:

![Отсутствует Distance](./data/distance-.png)

## Memory footprint

Замер на рост Memory footprint производить с закрытым DevTools, потому что сам DevTools активно создает объекты, которые могут занимать немало места в Memory footprint.

### Уничтожаемые объекты

Для некоторых встроенных объектов разработчики предусмотрели способы по их уничтожению, например:

- `ImageBitmap.close()`;
- `createObjectURL()`, `revokeObjectURL()` – [...As long as the mapping exist the Blob can’t be garbage collected](https://w3c.github.io/FileAPI/#url-intro);
- WebGL: `create`/`delete` `Program/Shader/Buffer/Texture/etc` – [...Mark for deletion the texture object contained in the passed WebGLTexture](https://www.khronos.org/registry/webgl/specs/latest/1.0/#5.14.8);
- `indexDb.close()`[...Set connection’s close pending flag to true](https://w3c.github.io/IndexedDB/#close-a-database-connection).

Когда объект больше не нужен, то его явное уничтожение поможет избежать неожиданного роста занимаемой памяти.  

### Transferable

При обмене между контекстами (например, обмен Воркер `<->` Main-thread) в `.postMessage` вторым аргументом можно передать массив объектов, на которые передаются права собственности контексту-получателю.  
Одной из причин значительного роста Memory footprint по отношению к росту JS Heap(либо при отсутствии его роста) является то, что контекст-отправитель при вызове `.postMessage` передал права не на все [Transferable](https://developer.mozilla.org/en-US/docs/Glossary/Transferable_objects#supported_objects) объекты исходящего сообщения.
