# Контекст выполнения JS кода

## Execution context

JavaScript код выполняет [**агент**](https://tinyurl.com/2p8ptahb), используя данные специальной сущности – [**execution context**](https://tinyurl.com/se74cyxu). В спецификации execution context называется "a specification device", но я его представляю в виде простого объекта.

Новый execution context создается всякий раз, когда из исполняемого кода, ассоциированного с [**running execution context**](https://tinyurl.com/4fb79dy8), передается управление в исполняемый код с другим execution context.  
Только что созданный execution context кладется на вершину [**execution context stack**](https://tinyurl.com/2p8hxsdn) и становится running execution context.

В какой же момент движек решает передать управление в исполняемый код с другим execution context (и, соответственно, создать новый execution context)?  
Новый execution context создается всякий раз, когда (см. [таблицу 29](https://tinyurl.com/2p96vb7a)):

- ScriptOrModule: **Script Record** – движек начинает выполнять код скрипта `<script>..</script>`;
- ScriptOrModule: **Module Record** – движек начинает выполнять код модуля `<script type="module">..</script>`;
- ScriptOrModule: **null** – движек начинает выполнять код не скрипта и не модуля;
- **Function** – движек начинает выполнять код функции `function fnId(..){..}`.

Для каждого execution context спецификация определяет обязательный набор полей, вот некоторые из них:

- **Realm** – объект типа [Realm Record](https://tinyurl.com/2p9ynr9p);
- **LexicalEnvironment** – объект типа [Environment Record](https://tinyurl.com/ycncua2r), используется для разрешения ссылок на идентификаторы, созданные кодом внутри execution context;
- **VariableEnvironment** – объект типа [Environment Record](https://tinyurl.com/ycncua2r), содержит идентификаторы переменных(и их значения), созданные при помощи `var` внутри execution context.

## Environment Record
