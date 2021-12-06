# Контекст выполнения JS кода

JavaScript код выполняется [**агентом**](https://tinyurl.com/2p8ptahb) в рамках [**execution context**](https://tinyurl.com/se74cyxu).

Execution context бывают:

- Script;
- Module;
- Function.

Новый execution context создается всякий раз, когда из исполняемого кода, ассоциированного с [**running execution context**](https://tinyurl.com/4fb79dy8), передается управление в исполняемый код с другим execution context. Только что созданный execution context кладется на вершину [**execution context stack**](https://tinyurl.com/2p8hxsdn) и становится running execution context.

Из js кода невозможно напрямую обратиться к execution context.

