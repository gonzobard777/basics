# Windows terminal

Установка:

- [Windows terminal](https://apps.microsoft.com/search?query=windows+terminal)
- [PowerShell](https://apps.microsoft.com/search?query=powershell)

## Настройки

Заменить этими [настройками](./settings.json) существующие:  
Settings -> Open JSON file

## Профиль

Открыть профиль:

```shell
notepad $PROFILE
```

если нет, то создать:

```shell
New-Item -Path $PROFILE -ItemType File -Force
```

Содержимое:

```shell
#function prompt { "$PWD> " }
#
#function prompt {
#  "$(Split-Path -Leaf $PWD)> "
#}

function prompt {
  $path = Get-Location
  Write-Host ""
  Write-Host "$path" -ForegroundColor DarkGray
  return "> "
}

# Prefer newer PSReadLine from CurrentUser over built-in
Remove-Module PSReadLine -Force -ErrorAction SilentlyContinue
Import-Module PSReadLine -MinimumVersion 2.2.0 -Force

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
```
