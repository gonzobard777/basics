## Execution context – Контекст выполнения JS кода

JavaScript код выполняет [**агент**](https://tinyurl.com/2p8ptahb), используя данные специальной структуры – [**execution context**](https://tinyurl.com/se74cyxu). В спецификации execution context называется "a specification device", но я его представляю в виде простого объекта.

Новый execution context создается всякий раз, когда из исполняемого кода, ассоциированного с [**running execution context**](https://tinyurl.com/4fb79dy8), передается управление в исполняемый код с другим execution context.  
Только что созданный execution context кладется на вершину [**execution context stack**](https://tinyurl.com/2p8hxsdn) и становится running execution context.

В какой же момент движек решает передать управление в исполняемый код с другим execution context (и, соответственно, создать новый execution context)?  
Новый execution context создается всякий раз, когда (см. таблицу [29](https://tinyurl.com/2p96vb7a)):

- ScriptOrModule: **Script Record** – движек начинает выполнять код скрипта `<script>..</script>`;
- ScriptOrModule: **Module Record** – движек начинает выполнять код модуля `<script type="module">..</script>`;
- ScriptOrModule: **null** – движек начинает выполнять код не скрипта и не модуля;
- **Function** – движек начинает выполнять код функции `function fnId(..){..}`.

Для каждого execution context спецификация определяет обязательный набор полей (см. таблицы [29](https://tinyurl.com/2p96vb7a), [30](https://tinyurl.com/594urp28), [31](https://tinyurl.com/2p8tbzbk)).  
Вот некоторые из них:

- **LexicalEnvironment** – объект типа [Environment Record](https://tinyurl.com/ycncua2r), содержит созданные внутри execution context идентификаторы `let` и `const` переменных(и их значения), а также идентификаторы функций(и ссылку на их код);
- **VariableEnvironment** – объект типа [Environment Record](https://tinyurl.com/ycncua2r), содержит созданные внутри execution context идентификаторы `var` переменных(и их значения).
- **Realm** – объект типа [Realm Record](https://tinyurl.com/2p9ynr9p);

## Environment Record – Область видимости

**Environment Record** – это тип спецификации, используемый для определения связи идентификаторов с конкретными переменными и функциями на основе _лексической_ структуры js кода. Поэтому то, какие идентификаторы попадут в конкретный EnvironmentRecord определяется тем, где вы разместили переменные, функции и блоки кода во время написания программы.

Обычно EnvironmentRecord связан с определенными синтаксическими структурами js кода: [FunctionDeclaration](https://tinyurl.com/y7kvzjem), [BlockStatement](https://tinyurl.com/2cz4c58s) или Catch в [TryStatement](https://tinyurl.com/5x8ncsvk). Всякий раз, когда движку надо обработать одну из этих структур, создается новый обект EnvironmentRecord для хранения привязок идентификаторов, созданных этим кодом.

Каждый EnvironmentRecord содержит поле `[[OuterEnv]]`, значение которого либо равно `null`, либо указывает на внешний EnvironmentRecord.
