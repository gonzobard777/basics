# О компиляции в ES модули средствами TypeScript

1. Если по коду встречается `require` импорты, то они так и останутся `require` импортами в результирующих ES модулях. И такой модуль невозможно запустить в среде Node.js, когда она ожидает ES модули - нода просто не поймет `require`.
2. При запуске в среде Node.js он может начать ругаться, что не может импортировать модуль `./some/file`. Дело в том, что при импорте ноде необходимо наличие расширения файла, а по умолчанию все кодят не указывая расширение. Выход - это указывать расширение на все импортируемые ts-файлы, например: `import {hello} from './some/file.js'` - расширение `.js` здесь не ошибка, получается придется импортировать ts-файл с `.js` расширением и после компиляции это расширение файла останется.