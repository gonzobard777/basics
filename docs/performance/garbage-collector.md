- [garbage.collect() by Андрей Роенко](https://habr.com/ru/company/oleg-bunin/blog/433318/)
- [Trash talk: the Orinoco garbage collector](https://v8.dev/blog/trash-talk)
- [Description of Tools for developers trying to understand memory usage](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/memory/tools.md#real-world-leak-detector)
    - [MemoryInfra - where memory is being used in your system](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/memory-infra)
- [Chrome DevTools - Memory](https://developer.chrome.com/docs/devtools/#memory)

## Терминология

**Shared memory** - совместная память процесса - объем используемой процессом физической памяти, которая может использоваться совместно с другими процессами.  
**Private memory** - собственная память процесса - объем используемой процессом физической памяти, которая не может использоваться другими процессами.  
**JavaScript memory** - он же JS Heap - объем физической памяти, занимаемой js вообще и живыми объектами в частности.  
**Memory footprint** - предположительно включает в себя Private memory и JavaScript memory. Но это не точно.

# Известные кейсы

## JS Heap

### new ReplaySubject()

При вот таком создании `new ReplaySubject()` в `bufferSize` [назначется](https://github.com/ReactiveX/rxjs/blob/master/src/internal/ReplaySubject.ts) `Infinity`.  
Если использовать такой ReplaySubject в долгоживущих обектах, то это гарантированно приведет к росту JS Heap.

## Memory footprint

Замер на рост Memory footprint надо производить с закрытым DevTools!

### Transferable

При обмене между контекстами в `.postMessage` вторым аргументом можно передать массив объектов, на которые передаются права собственности контексту-получателю.  
Одной из причин значительного роста Memory footprint по отношению к росту JS Hep(а возможно даже и при полном отсутсвии его роста) является то, что контекст-отправитель при вызове `.postMessage` не на все [Transferable](https://developer.mozilla.org/en-US/docs/Glossary/Transferable_objects#supported_objects) объекты исходящего сообщения передал права.

### Уничтожаемые объекты

Для некоторых встроенных объектов разработчики предусмотрели способы по его уничтожению, например:

- `ImageBitmap.close()`;
- `createObjectURL()`, `revokeObjectURL()`;
- WebGL: `create`/`delete` `Program/Shader/Buffer/Texture/etc`;
- `indexDb.close()`.

Когда объект вам больше не нужен, то крайне желательно явно уничтожать такие объекты.  
