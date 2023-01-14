# Install macOS Monterey on VMware on Windows – PC

### [ISO образ macOS Monterey Final 12.0.1 (21A559) для VMware и VirtualBox](https://rutracker.org/forum/viewtopic.php?t=6130213)

### Разлочить VMware

1. [macOS Unlocker for VMware](https://github.com/paolo-projects/unlocker)
2. Закрыть VMware
3. В папке unlocker'а от имени Администратора запустить файл `win-install.cmd`

### Добавить новую VM

В списке осей теперь доступна Apple Mac OS X.  
Добавить macOS 12.

### Отредактировать VMX файл

1. В папке новой оси открыть в текстовом редакторе файл с расширением **vmx**
2. Добавить в самый конец строку:

```
smc.version = "0"
```

### Установить Ось

### Установить Tools

В теме исошника на rutracker'е есть ссылка на VMware Tools для macOS 10.11 and later: 11.2.0; 11.2.5; 11.3.0; 11.3.5.  
Подключить как диск и поставить.

### Расшаренная папка

Чтобы ее увидеть на рабочем столе надо в настройках Finder'а поставить галочку на "Подключенные серверы".

# Links

- [How to Install macOS Monterey on VMware on Windows – PC](https://www.wikigain.com/how-to-install-macos-monterey-on-vmware-on-windows-pc/)
