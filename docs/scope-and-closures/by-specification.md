# Термины и определения

### Execution context – Контекст выполнения JS кода

JavaScript код выполняет [**агент**](https://tinyurl.com/2p8ptahb), используя данные специальной структуры – [**ExecutionContext**](https://tinyurl.com/se74cyxu). В спецификации ExecutionContext называется "a specification device", но я его представляю в виде простого объекта.

Новый ExecutionContext создается всякий раз, когда из исполняемого кода, ассоциированного с [**running execution context**](https://tinyurl.com/4fb79dy8), передается управление в исполняемый код с другим ExecutionContext.  
Только что созданный ExecutionContext кладется на вершину [**execution context stack**](https://tinyurl.com/2p8hxsdn) и становится [**running execution context**](https://tinyurl.com/4fb79dy8).

В какой же момент движек решает передать управление в исполняемый код с другим ExecutionContext (и, соответственно, создать новый ExecutionContext)?  
Новый ExecutionContext создается всякий раз, когда (см. таблицу [29](https://tinyurl.com/2p96vb7a)):

- ScriptOrModule: **Script Record** – движек начинает выполнять код скрипта `<script>..</script>`;
- ScriptOrModule: **Module Record** – движек начинает выполнять код модуля `<script type="module">..</script>`;
- ScriptOrModule: **null** – движек начинает выполнять код не скрипта и не модуля;
- **Function** – движек начинает выполнять код функции `function fnId(..){..}`.

Для каждого ExecutionContext спецификация определяет обязательный набор полей (см. таблицы [29](https://tinyurl.com/2p96vb7a), [30](https://tinyurl.com/594urp28), [31](https://tinyurl.com/2p8tbzbk)).  
Вот некоторые из них:

- **LexicalEnvironment** – объект типа [Environment Record](https://tinyurl.com/ycncua2r), содержит созданные внутри ExecutionContext идентификаторы `let` и `const` переменных(и их значения), а также идентификаторы функций(и ссылку на их код);
- **VariableEnvironment** – объект типа [Environment Record](https://tinyurl.com/ycncua2r), содержит созданные внутри ExecutionContext идентификаторы `var` переменных(и их значения).
- **Realm** – объект типа [Realm Record](https://tinyurl.com/2p9ynr9p);

### Environment Record – Область видимости

**[Environment Record](https://tinyurl.com/ycncua2r)** – это тип спецификации, используемый для определения связи идентификаторов с конкретными переменными и функциями на основе _лексической_ структуры js кода. Поэтому то, какие идентификаторы попадут в конкретный EnvironmentRecord определяется тем, где вы разместили переменные, функции и блоки кода во время написания программы.

Обычно EnvironmentRecord связан с определенными синтаксическими структурами js кода: [FunctionDeclaration](https://tinyurl.com/y7kvzjem), [BlockStatement](https://tinyurl.com/2cz4c58s) или Catch в [TryStatement](https://tinyurl.com/5x8ncsvk). Всякий раз, когда движку надо обработать одну из этих структур, создается новый объект EnvironmentRecord для хранения привязок идентификаторов, созданных этим кодом.

Каждый EnvironmentRecord содержит поле `[[OuterEnv]]`, значение которого либо равно `null`, либо указывает на внешний EnvironmentRecord.

# Алгоритмы

Чтобы лучше понять (либо окончательно запутаться), надо смотреть соответствующие алгоритмы, описанные в спецификации.

## 1. Скрипт

[ScriptEvaluation](https://tinyurl.com/3mkhsjt8)

## 2. Модуль

1. [InitializeEnvironment](https://tinyurl.com/mr2rnb3y)
2. [ExecuteModule](https://tinyurl.com/ctsespxy)

## 3. Функция

1. [PrepareForOrdinaryCall](https://tinyurl.com/442udm6b)
2. [FunctionDeclarationInstantiation](https://tinyurl.com/2p98cp79)
3. [InstantiateOrdinaryFunctionExpression](https://tinyurl.com/35ahwb7u)
4. [InstantiateArrowFunctionExpression](https://tinyurl.com/5n7884p2)
5. [InstantiateGeneratorFunctionExpression](https://tinyurl.com/mr3tw5wn)
6. [ClassDefinitionEvaluation](https://tinyurl.com/bd2cjyx7)

## 4. Блок кода

1. [Блок кода](https://tinyurl.com/mw4acsde)
    1. [ForLoopEvaluation](https://tinyurl.com/2p8j6en9)
    2. [ForInOfLoopEvaluation](https://tinyurl.com/2z2ry52j)
    3. [switch](https://tinyurl.com/yckk5zs3)
    4. [CatchClauseEvaluation](https://tinyurl.com/3baphpzn)
    5. [with](https://tinyurl.com/kc3s4ayh)

## Особый случай – `eval`

[PerformEval](https://tinyurl.com/36ccnz5c)

----

## Как движек находит идентификатор?

[ResolveBinding](https://tinyurl.com/2p9bx6h8)

## Как движек находит `this`?

[ResolveThisBinding](https://tinyurl.com/4saxf737)
