$action = New-ScheduledTaskAction -Execute "shutdown" -Argument "/r /t 0"
$trigger = New-ScheduledTaskTrigger -Daily -At "00:00"
$principal = New-ScheduledTaskPrincipal -GroupID "BUILTIN\Users" -RunLevel Highest
Register-ScheduledTask -TaskName "NightlyReboot" -Action $action -Trigger $trigger -Principal $principal