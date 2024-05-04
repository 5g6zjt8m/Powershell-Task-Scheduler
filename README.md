# Powershell-Task-Scheduler
This repository contains scripts that I implemented for kiosk-style setups and digital signage.

## What is this?
There are three Powershell scripts that are designed to be implemented in Intune. One creates a scheduled task once deployed, one detects the existence of the scheduled task, and the last of the bundle removes the created task. The fourth script is an example of a modification made, somewhat showcasing the power and versatility of task scheduler. The XML file that I configured demonstrates the style of system these scripts were deployed to.

## What are the most important things to know?

The context of the ``AutoLaunchChrome`` trio of scripts was to have a setup that will launch two Chrome windows on two displays. The goal was to open one instance of Chrome using the autolaunch configuration in the [AssignedAccess.xml](/AssignedAccess.xml), and another instance on a second display using a scheduled task. Three scripts were necessary to have a complete Intune deployment with proper detection and uninstallation.

## What do these examples do?

#### <ins>[AutoLaunchChrome.ps1](/AutoLaunchChrome.ps1)</ins>

Defines three variables so that the scheduled task can be created in a single line. ``$action`` depicts the action that the scheduled task will take. In this case, the action uses the ``%ProgramFiles%`` environment variable to run ``chrome.exe``. Here comes a quirk with opening up multiple instances of a Chromium based browser. If you want two separate windows to be opened using commands, they need to be using different browser profiles.

The issue that I kept running into at the end is that the script would execute, but it would just open an additional browser tab. I needed to specify another profile to launch Chrome with by using the ``--user-data-dir="%userprofile%\AppData\Local\Google\Chrome\User Data\monitor2`` argument, using the ``%userprofile%`` environment variable. Arguments that specify the website, kiosk mode, and window position are also passed through.

The next variable defined is ``$trigger``, which simply just defines when the scheduled task will be triggered. For this script, it triggers at user login.

``$principal`` defines the security context of how the scheduled task should be run. I defined it to be run under the context of ``BUILTIN\Users``, which should work for any authenticated user that logs in.

The final line brings everything together, and creates the scheduled task using those variables.

#### <ins>[AutoLaunchChromeDetection.ps1](/AutoLaunchChromeDetection.ps1)</ins>

Very simply checks to see if a scheduled task with the name ``AutoLaunchChrome`` exists. If the statement returns with the correct name, it successfully exits with code 0. If not, exits with code 1.

#### <ins>[AutoLaunchChromeUninstall.ps1](/AutoLaunchChromeUninstall.ps1)</ins>

One simple line that removes the scheduled task with the name ``AutoLaunchChrome``.

#### <ins>[OlReliable.ps1](/OlReliable.ps1)</ins>

This is an example of how versatile task scheduler is. This creates a scheduled task that will reboot the computer every night. This is almost a necessity in Windows 11, as stability can be an issue over long periods of time. Having something like this be so simple yet so effective reminded me of this [ol' reliable meme](ol-reliable.png) (very closely studied literature by every independent advisor on the Microsoft Community support forum).

#### <ins>[AssignedAccess.xml](/AssignedAccess.xml)</ins>

On the topic of poor stability in Windows 11, this configuration file demonstrates the frustration in getting a multi-app kiosk to run smoothly. In short, there were very radical changes made to the way AssignedAccess configurations work in Windows 11, and by "changes" I mean that it's almost completely broken.

If left alone for long enough, Windows will launch _something_ in the background that's supposed to be restricted from running, and so the entire display will get covered with a message stating that the application is blocked. Good amount of time spent in ``eventvwr`` tracking those applications down, because of course the initial message doesn't tell you what application is being blocked. This can only be cleared with manual input or a reboot. Terrible for digital signage. ``OlReliable.ps1`` is the saving grace.

There's a long list of applications that need to be allowed through, because Windows 11 will attempt to run them regardless.

Importantly though, this XML file demonstrates how [AutoLaunchChrome.ps1](/AutoLaunchChrome.ps1) can be paired with this AssignedAccess configuration. In the config, one instance of Chrome is already launched on the primary display. The scheduled task is necessary in getting another instance to launch on another display.