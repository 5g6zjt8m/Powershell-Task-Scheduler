if ($(Get-ScheduledTask -TaskName "AutoLaunchChrome" -ErrorAction SilentlyContinue).TaskName -eq "AutoLaunchChrome") {
    exit 0 
}
exit 1