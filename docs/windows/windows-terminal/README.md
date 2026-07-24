# Windows terminal

Установка:

- [Windows terminal](https://apps.microsoft.com/search?query=windows+terminal)
- [PowerShell](https://apps.microsoft.com/search?query=powershell)

## Настройки

Заменить этими [настройками](./settings.json) существующие:  
Settings -> Open JSON file

## Профиль

Сначала обнови повершел, а затем сделай так в нем:

```shell
if (-not (Test-Path $PROFILE)) {
  New-Item -Path $PROFILE -ItemType File -Force | Out-Null
  Write-Host "Профиль создан: $PROFILE"
} else {
  Write-Host "Профиль уже существует: $PROFILE"
}
```

Проверить.   
Для PS 7 путь должен быть `...\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`   
(не WindowsPowerShell — это профиль старого PS 5)

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

# Цвета под белый фон (по умолчанию рассчитаны на тёмный, поэтому
# подсказка-подсветка бледная и почти не читается на белом)
Set-PSReadLineOption -Colors @{
    InlinePrediction = '#7CA0AA'
    Command          = '#B58900'
    Parameter        = '#268BD2'
    Operator         = '#859900'
    Comment          = '#93A1A1'
}
```

Тему в Windows 10 можно переключить через реестр. Для белой (светлой) темы нужно установить два ключа в 1:

```shell
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name AppsUseLightTheme -Value 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name SystemUsesLightTheme -Value 1
```
