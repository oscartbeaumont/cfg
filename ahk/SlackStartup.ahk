SendMode Input
SetWorkingDir %A_ScriptDir%

Run, %USERPROFILE%\AppData\Local\Microsoft\WindowsApps\slack.exe, , Hide

WinWait, ahk_exe slack.exe

Loop, 50
{
    WinClose, ahk_exe slack.exe
    Sleep, 50
}

ExitApp