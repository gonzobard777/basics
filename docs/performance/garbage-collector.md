- ["garbage.collect()" by Андрей Роенко](https://habr.com/ru/company/oleg-bunin/blog/433318/)
- ["Trash talk: the Orinoco garbage collector" by Peter Marshall](https://v8.dev/blog/trash-talk)
- [Chrome DevTools - Memory](https://developer.chrome.com/docs/devtools/#memory)
- [Description of Tools for developers trying to understand memory usage](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/memory/tools.md)
    - [MemoryInfra - where memory is being used in your system](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/memory-infra)

## Терминология

**Shared memory** – совместная память процесса – объем используемой процессом физической памяти, которая может использоваться совместно с другими процессами.  
**Private memory** – собственная память процесса – объем используемой процессом физической памяти, которая не может использоваться другими процессами.  
**JavaScript memory** – он же JS Heap – объем физической памяти, занимаемой js объектами, созданными в процессе работы программы (общий объем и отдельно размер по живым объектам).  
**Memory footprint** – предположительно включает в себя Private memory и JS Heap. Но это неточно.

# Известные кейсы / подходы

Кейсы от команды Chrome Developers: [Fix memory problems](https://developer.chrome.com/docs/devtools/memory-problems/).

### Освобождение удерживаемых ресурсов

- таймеры – `setInterval / clearInterval(intervalID)`; `setTimeout / clearTimeout(timeoutID)`;
- слушатели – `addEventListener / removeEventListener`;
- подписки – `Subscription.unsubscribe()`, `takeUntil`, `takeWhile`, `take`, `first`, `shareReplay({refCount: true, bufferSize})`;
- `createObjectURL(obj) / revokeObjectURL(url)` – [...As long as the mapping exist the Blob can’t be garbage collected](https://w3c.github.io/FileAPI/#url-intro);
- `ImageBitmap.close()`;
- `indexDb.close()`[...Set connection’s close pending flag to true](https://w3c.github.io/IndexedDB/#close-a-database-connection);
- WebGL: `create`/`delete` `Program/Shader/Buffer/Texture/etc` – [...Mark for deletion the texture object contained in the passed WebGLTexture](https://www.khronos.org/registry/webgl/specs/latest/1.0/#5.14.8).

## JS Heap

### Объект без корня

Если значение в колонке [Distance](https://developer.chrome.com/docs/devtools/memory-problems/memory-101/#retained_size) отлично от числового, то объект "повис" и GC не сможет его убрать:

![Отсутствует Distance](./data/distance-.png)

### Сравнение Snapshot'ов

Профайлер памяти хрома позволяет сравнить между собой два или три снепшота:

![Сравнение созданных](./data/allocated-between-3-snapshots.png)

На примере видно, что в результате трех последовательных замеров было создано 24_243 объекта PointerEvent, общий объем удерживаемой ими памяти 20MB и GC не может убрать эти объекты.

### Таймер удерживает большой ресурс

Таймеры `setInterval`, `setTimeout` всегда повисают в root-контексте (`Window`, `DedicatedWorkerGlobalScope` и т.д.), поэтому для них не важен Distance.  
Если в списке активных таймеров присутствует таймер, удерживающий большой кусок памяти, то скорее всего в нем произошла утечка – надо в коде найти этот таймер и в нужный момент вызвать для него `clearTimeout`:

![Таймер удерживает большой ресурс](./data/dom-timer-big.png)

Таймер может быть скрыт внутри используемой в проекте библиотеки.  
Например, [time based operators](https://www.learnrxjs.io/learn-rxjs/concepts/time-based-operators-comparison) в rxjs используют таймеры. И, чтобы освободить повисший в time based operator'е ресурс, надо явно отписаться от подписки.

### `new ReplaySubject()`, `shareReplay()`

При таком использовании: `new ReplaySubject()`, `shareReplay()` – в `bufferSize` назначится `Infinity`.  
B долгоживущих объектах это гарантированно приведет к росту JS Heap.

### `shareReplay` без явного `refCount: true`

По умолчанию `refCount = false` – это значит, что отписка от Источника не произойдет никогда. И, если в цепочке подписок есть таймер, слушатель и т.п., то после удаления объекта с таким `shareReplay` замкнутые контексты "повиснут", и соответственно произойдет утечка памяти.

## Memory footprint

При открытом DevTools активно создаются объекты, которые могут увеличивать объем Memory footprint, поэтому иногда есть смысл производить замер при закрытом DevTools.

### Transferable

При обмене между контекстами (например, обмен Воркер `<->` Main-thread) в `.postMessage` вторым аргументом можно передать массив объектов, на которые передаются права собственности контексту-получателю.  
Одной из причин значительного роста Memory footprint по отношению к росту JS Heap(либо при отсутствии его роста) является то, что контекст-отправитель при вызове `.postMessage` передал права не на все [Transferable](https://developer.mozilla.org/en-US/docs/Glossary/Transferable_objects#supported_objects) объекты исходящего сообщения.
