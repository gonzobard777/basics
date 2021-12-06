# Контекст выполнения JS кода

JavaScript код выполняет [**агент**](https://tinyurl.com/2p8ptahb), используя данные специального объекта [**execution context**](https://tinyurl.com/se74cyxu).

Новый execution context создается всякий раз, когда из исполняемого кода, ассоциированного с [**running execution context**](https://tinyurl.com/4fb79dy8), передается управление в исполняемый код с другим execution context. Только что созданный execution context кладется на вершину [**execution context stack**](https://tinyurl.com/2p8hxsdn) и становится running execution context.

А в какой момент движек решит передать управление в исполняемый код с другим execution context (соответственно создать новый execution context)?  
Новый execution context создается всякий раз, когда:

- **Script** – движек выполняет код скрипта `<script>..</script>`;
- **Module** – движек выполняет код модуля `<script type="module">..</script>`;
- **Function** – движек выполняет код функции `function fnId(..){..}`.



