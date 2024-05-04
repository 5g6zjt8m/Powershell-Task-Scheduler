$action = New-ScheduledTaskAction -Execute "%ProgramFiles%\Google\Chrome\Application\chrome.exe" -Argument '--user-data-dir="%userprofile%\AppData\Local\Google\Chrome\User Data\monitor2" "https://github.com/5g6zjt8m" --kiosk --window-position=5000,0'
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -GroupID "BUILTIN\Users" -RunLevel Highest
Register-ScheduledTask -TaskName "AutoLaunchChrome" -Action $action -Trigger $trigger -Principal $principal