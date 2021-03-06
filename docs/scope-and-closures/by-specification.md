Читал спецификацию ECMA-262 и конспектировал.  
Целевые темы: ExecutionContext и EnvironmentRecord.

# Как движек находит идентификатор?

[ResolveBinding](https://tinyurl.com/2p9bx6h8)

# Термины и определения

## ExecutionContext – Контекст выполнения JS кода

JavaScript код выполняет [**агент**](https://tinyurl.com/2p8ptahb), используя данные специальной структуры – [**ExecutionContext**](https://tinyurl.com/se74cyxu). В спецификации ExecutionContext называется "a specification device", но я его представляю в виде простого объекта.

Новый ExecutionContext создается всякий раз, когда из исполняемого кода, ассоциированного с [**running execution context**](https://tinyurl.com/4fb79dy8), передается управление в исполняемый код с другим ExecutionContext.  
Только что созданный ExecutionContext кладется на вершину [**execution context stack**](https://tinyurl.com/2p8hxsdn) и становится [**running execution context**](https://tinyurl.com/4fb79dy8).

В какой же момент движек решает передать управление в исполняемый код с другим ExecutionContext (и, соответственно, создать новый ExecutionContext)?  
Новый ExecutionContext создается всякий раз, когда (см. таблицу [29](https://tinyurl.com/2p96vb7a)):

- движек проводит инициализацию – ScriptOrModule: **null**;
- движек собирается выполнять код скрипта `<script>..</script>` – ScriptOrModule: [**ScriptRecord**](https://tinyurl.com/fcc6mw94);
- движек собирается выполнять код модуля `<script type="module">..</script>` – ScriptOrModule: [**ModuleRecord**](https://tinyurl.com/y6wud8sj);
- движек собирается выполнять код функции `function BindingIdentifier ( FormalParameters ) { FunctionBody }` – заполнено поле **Function**.

Для каждого ExecutionContext спецификация определяет обязательный набор полей (см. таблицы [29](https://tinyurl.com/2p96vb7a), [30](https://tinyurl.com/594urp28), [31](https://tinyurl.com/2p8tbzbk)).  
Вот некоторые из них:

- **LexicalEnvironment** – объект типа [EnvironmentRecord](https://tinyurl.com/ycncua2r), содержит созданные внутри ExecutionContext идентификаторы `let` и `const` переменных(и их значения), а также идентификаторы функций(и ссылку на их код);
- **VariableEnvironment** – объект типа [EnvironmentRecord](https://tinyurl.com/ycncua2r), содержит созданные внутри ExecutionContext идентификаторы `var` переменных(и их значения).
- **Realm** – объект типа [RealmRecord](https://tinyurl.com/2p9ynr9p);

## EnvironmentRecord – Область видимости

**[EnvironmentRecord](https://tinyurl.com/ycncua2r)** – это тип спецификации, используемый для определения связи идентификаторов с конкретными переменными и функциями на основе _лексической_ структуры js кода. Поэтому то, какие идентификаторы попадут в конкретный EnvironmentRecord определяется тем, где вы разместили переменные, функции и блоки кода во время написания программы.

Обычно EnvironmentRecord связан с определенными синтаксическими структурами js кода: [FunctionDeclaration](https://tinyurl.com/y7kvzjem), [BlockStatement](https://tinyurl.com/2cz4c58s) или Catch в [TryStatement](https://tinyurl.com/5x8ncsvk). Всякий раз, когда движку надо обработать одну из этих структур, создается новый объект EnvironmentRecord для хранения привязок идентификаторов, созданных этим кодом.

Каждый EnvironmentRecord содержит поле `[[OuterEnv]]`, значение которого либо равно `null`, либо указывает на внешний EnvironmentRecord.

Существует несколько видов EnvironmentRecord:

- [**GlobalEnv**](https://tinyurl.com/2p8cmejn), создается операцией [NewGlobalEnvironment(obj, thisValue)](https://tinyurl.com/2p8jr9dp);
- [**ModuleEnv**](https://tinyurl.com/2p9banf3), создается операцией [NewModuleEnvironment(outerEnv)](https://tinyurl.com/2p968uux);
- [**FunctionEnv**](https://tinyurl.com/yckt9zuj), создается операцией [NewFunctionEnvironment(functionObj, newTarget)](https://tinyurl.com/3um4x7my);
- [**DeclarativeEnv**](https://tinyurl.com/5fduhfzd), создается операцией [NewDeclarativeEnvironment(outerEnv)](https://tinyurl.com/3fbb74wa);
- [**ObjectEnv**](https://tinyurl.com/2p964csh), создается операцией [NewObjectEnvironment(obj, IsWithEnvironment, outerEnv)](https://tinyurl.com/bdpxwttj).

# Алгоритмы

## 1. Инициализация

Перед тем, как выполнить скрипт/модуль, движек должен убедиться, что существует нужный realm.  
Если realm не найден, то действием [InitializeHostDefinedRealm()](https://tinyurl.com/bddv3smu) новый realm создается и инициализируется:

1. Создается [Realm](https://tinyurl.com/ycytpr73).
    1. Поле `realm.[[Intrinsics]]` заполняется [встроенными значениями](https://tinyurl.com/3z34we6x).
2. Создается ExecutionContext, кладется на вершину [execution context stack](https://tinyurl.com/2p8hxsdn) и становится [running execution context](https://tinyurl.com/4fb79dy8).
3. Переменным globalObj и thisValue могут быть определены какие-то специфичные значения.
4. Операция [SetRealmGlobalObject(realm, globalObj, thisValue)](https://tinyurl.com/2kjrjwhz):
    1. если `globalObj === undefined`, то `globalObj = OrdinaryObjectCreate(intrinsics.[[%Object.prototype%]])`;
    2. если `thisValue === undefined`, то `thisValue = globalObj`.
    3. в поле `realm.[[GlobalObject]]` назначется globalObj.
    4. в поле `realm.[[GlobalEnv]]` назначается результат [NewGlobalEnvironment(globalObj, thisValue)](https://tinyurl.com/2p8jr9dp).
5. Операция [SetDefaultGlobalBindings(realm)](https://tinyurl.com/5e97fvwx):
    1. объект в поле `realm.[[GlobalObject]]` заполняется всеми значениями, предусмотренными в главе [19](https://tinyurl.com/jc992yvr).

Самое главное, что на выходе гарантированно будут определены следующие сущности:

- [**GlobalEnv**](https://tinyurl.com/2p8cmejn) – **эта область видимости шарится между всеми `<script>` элементами конкретного realm'а и является корнем всех последующих областей видимости, создающихся в ходе выполнения кода скрипта**, хранится по пути `realm.[[GlobalEnv]]`;
- [**globalThis**](https://tinyurl.com/2fsuj7hj) – хранится по пути `realm.[[GlobalEnv]].[[GlobalThisValue]]`;
- [**GlobalObject**](https://tinyurl.com/jc992yvr) – хранится по пути `realm.[[GlobalObject]]`, обычно на него указывает globalThis;
    - GlobalObject знает обо всем, что предусмотрено [здесь](https://tinyurl.com/jc992yvr)

## 2. Далее запускаются на выполнения все Скрипты и Модули

Порядок обработки скриптов и модулей может зависеть от режима: [defer](https://tinyurl.com/2p9ha6ez), [async](https://tinyurl.com/2p9f3u39).

Модули начинают выполняться после полной загрузки страницы, т.к. всегда выполняются в отложенном defer режиме.  
Обычные же скрипты запускаются сразу.

Скрипт `<script>..</script>`:

1. [ParseScript(sourceText, realm, hostDefined)](https://tinyurl.com/2p8j3927) `->` [ScriptRecord](https://tinyurl.com/fcc6mw94)
2. [ScriptEvaluation(scriptRecord)](https://tinyurl.com/3mkhsjt8)

Модуль `<script type="module">..</script>`:

1. [ParseModule(sourceText, realm, hostDefined)](https://tinyurl.com/mrys2s9u) `->` [Source Text ModuleRecord](https://tinyurl.com/mthf43ef)
2. [InitializeEnvironment()](https://tinyurl.com/mr2rnb3y)
3. [ExecuteModule([capability])](https://tinyurl.com/ctsespxy)

## 3. Функция

В процессе выполнения скрипта/модуля может попасться функция:

1. [[[Call]](thisArgument, argumentsList)](https://tinyurl.com/5yjn9p8s)
2. [[[Construct]](argumentsList, newTarget)](https://tinyurl.com/ycknwp3b)
3. [NamedEvaluation](https://tinyurl.com/mr25m4hc)

## 4. Блок кода

В процессе выполнения скрипта/модуля может попасться блок кода:

1. [Блок кода](https://tinyurl.com/mw4acsde)
    1. [ForLoopEvaluation](https://tinyurl.com/2p8j6en9)
    2. [ForInOfLoopEvaluation](https://tinyurl.com/2z2ry52j)
    3. [switch](https://tinyurl.com/yckk5zs3)
    4. [CatchClauseEvaluation](https://tinyurl.com/3baphpzn)
    5. [with](https://tinyurl.com/kc3s4ayh)

## Особый случай – `eval`

В процессе выполнения скрипта/модуля может попасться `eval`.  
[PerformEval(string, callerRealm, strictCaller, direct)](https://tinyurl.com/36ccnz5c)
