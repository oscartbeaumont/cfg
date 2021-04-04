; HotkeyGoodness V3, Created By Oscar Beaumont
#NoEnv
#SingleInstance Force
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%

; Environment Detection
isDesktop() {
	return A_ComputerName = "OSCARS-BOX" ? true : false
}

isLaptop() {
	return A_ComputerName = "OSCARS-XPS-13" ? true : false
}

UNI_ONENOTE_URI = "onenote://#base-path=https://d.docs.live.net/4af92b359279dbe8/Documents/Computer`%20Science/General.one#section-id={7F82945D-9DDC-4A73-9904-1A528A0DFE8C}"

; Shortcuts
:*:o@::oscar@otbeaumont.me
:*:otb@::oscartbeaumont@gmail.com
:*:ob@::oscar.beaumont@student.curtin.edu.au
:*:205@::20556729@student.curtin.edu.au
:*:04@::0475424548

; Application Quick Launch
^1::focusOrLaunch("ahk_exe WindowsTerminal.exe", "shell:AppsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App")
^2::focusOrLaunch("ahk_exe Code.exe", "C:\Program Files\Microsoft VS Code\Code.exe")
^3::focusOrLaunch("ahk_exe GitHubDesktop.exe", "C:\Users\oscar\AppData\Local\GitHubDesktop\GitHubDesktop.exe")
^4::focusOrLaunch("ahk_exe Postman.exe", "C:\Users\oscar\AppData\Local\Postman\Postman.exe")

; Window Management Helpers
#if isDesktop() = true
	^Up::WinMaximize, A
	^Down::WinMinimize, A
	
	^Right::
		WinRestore, A
		WinMove, A, , 1920, 150
		WinMaximize, A
	return

	^Left::
		WinRestore, A
		WinMove, A, , 50, 100
		WinMaximize, A
	return
#If

; Desktop Shortcuts
#if isDesktop() = true
	NumpadHome::Run chrome.exe "https://google.com"
	NumpadUp::Run chrome.exe "https://gmail.com"
	NumpadPgUp::Run chrome.exe "https://outlook.office.com"
	NumpadLeft::Run chrome.exe "https://github.com"
	NumpadClear::Run %UNI_ONENOTE_URI%
	NumpadRight::Run chrome.exe "https://keep.google.com"
	NumpadEnd::Run chrome.exe "https://calendar.google.com"
	NumpadDown::Run "fb-messenger://"
	NumpadPgDn::Run "discord://"
#If isLaptop() = true
	F9::
	    KeyWait, F9, T0.5
	    If ErrorLevel {
	        Run %UNI_ONENOTE_URI%
	        KeyWait, F9
	    } else {
	        Run https://lms.curtin.edu.au
		}
	return
#If

; Custom Spotify Button
#if isDesktop() = true
Insert::
	If (WinActive("ahk_exe spotify.exe")) {
		GroupAdd, spotify, ahk_exe spotify.exe
		WinMinimize, ahk_group spotify
	} else {
		focusOrLaunch("ahk_exe spotify.exe", "C:\Users\oscar\AppData\Roaming\Spotify\Spotify.exe")
		WinWaitActive, ahk_exe spotify.exe
	}
return

;;;;;;;; Helpers ;;;;;;;;

; Focus or Launch Helper
focusOrLaunch(window, launchPath) {
	IfWinNotExist %window%
		Run, %launchPath%
	WinWait, %window%
	winactivate, %window%
}