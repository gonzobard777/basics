# Codex

## Команды

| Команда              | Описание                                                                            |
|----------------------|-------------------------------------------------------------------------------------|
| `codex resume --all` | Список всех интерактивных сессий                                                    |
| `codex login`        | Authenticate Codex using ChatGPT OAuth, device auth, or an API key piped over stdin |
| `codex logout`       | Remove stored authentication credentials                                            |

https://developers.openai.com/codex/cli/reference#command-overview

## Установка

1. [Настроить терминал](../windows/windows-terminal/README.md)
2. [Установить/переустновить Ubuntu на wsl](../windows/wsl.md)

```shell
sudo apt update

# Node.js + npm
sudo apt install nodejs npm -y

# codex
sudo npm install -g @openai/codex
```

Назначить прокси:

```shell
nano ~/.bashrc

# Добавить переменные
export HTTP_PROXY=http://xx.xx.xx.xx:3128
export HTTPS_PROXY=http://xx.xx.xx.xx:3128

# Применить переменные без перезапуска
source ~/.bashrc
```

При первом запуске надо залогиниться в ChatGPT.  
Кодекс откроет ссылку в браузере по умолчанию, он по-идее тоже должен работать через прокси.  
