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

## Цель замера

Замер на рост Memory footprint надо производить с закрытым DevTools.  
