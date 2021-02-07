; HotkeyGoodness V2, Created By Oscar Beaumont
#NoEnv
#SingleInstance Force
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%

; Shortcuts
:*:o@::oscar@otbeaumont.me
:*:otb@::oscartbeaumont@gmail.com
:*:ob@::oscar.beaumont@student.bcgs.wa.edu.au
:*:04@::0475424548

; Spotify Playlists
^1::Run spotify:playlist:5OVtD4wy9P1XeNqjt1WWml
^2::Run spotify:playlist:6kuJcLtvBKVKLIUecIoAb3
^3::Run spotify:playlist:4AodDRuQ1xtpPdD0whmJNn
^4::Run spotify:playlist:36MMDw2HLtdXucwxho6mtV
^5::Run spotify:playlist:21huMPFR7rU8rp3qBfuxOG
^6::Run spotify:playlist:0rt7WFw5i0Gqu8XQ1fN6bk

#if A_ComputerName = "047485793753"
{
	Home::
	    KeyWait, Home, T0.5
	    If ErrorLevel {
	        Run https://github.com
	        KeyWait, Home
	    } Else {
	        Run https://google.com.au
	    }
	Return

	End::
	    KeyWait, End, T0.5
	    If ErrorLevel {
	        Run "onenote:https://bcgs-my.sharepoint.com/personal/oscar_beaumont_student_bcgs_wa_edu_au/Documents/School`%202020/General.one#Home`&section-id={D4C56A79-C2DD-4348-A2A9-3296D29270B4}&page-id={DEBBF322-6314-470B-80BC-D9889D68F318}`&end"
	        KeyWait, End
	    } Else {
	        Run https://learn.bcgs.wa.edu.au
		}
	Return

	PrintScreen::
	    KeyWait, PrintScreen, T0.5
	    If ErrorLevel {
	        showSpotifyButton()
	        KeyWait, PrintScreen
	    } Else {
	        hideSpotifyButton()
		}
	Return
	
	; Turn off screen
	^Delete::SendMessage, 0x112, 0xF140, 0,, Program Manager
}

#if A_ComputerName = "OscarsBox"
{
	NumpadHome::Run chrome.exe "https://gmail.com"
	NumpadLeft::Run chrome.exe "https://mail.bcgs.wa.edu.au"
	NumpadClear::Run chrome.exe "https://google.com"
	NumpadRight::Run chrome.exe "https://github.com"
	NumpadUp::Run "onenote:https://bcgs-my.sharepoint.com/personal/oscar_beaumont_student_bcgs_wa_edu_au/Documents/School`%202020/General.one#Home`&section-id={D4C56A79-C2DD-4348-A2A9-3296D29270B4}&page-id={DEBBF322-6314-470B-80BC-D9889D68F318}`&end"
	NumpadPgUp::Run fb-messenger://
	
	Insert:: showSpotifyButton()
	Home:: hideSpotifyButton()
	End::WinMinimize, A
}

; Find Spotify Window Helper
getSpotifyWindow() {
	WinGet, winInfo, List, ahk_exe Spotify.exe
	Loop, %winInfo%
	{
		thisID := winInfo%A_Index%
		WinGetTitle, Title, ahk_id %thisID%
		if (title == "") {
			continue
		}
		if (InStr(Title, "-") || InStr(Title, "Spotify")) {
			return %thisID%
		}
	}
	return ""
}

hideSpotifyButton() {
	DetectHiddenWindows, On
	winID := getSpotifyWindow()
	if (winID == "") {
		MsgBox, "Spotify not detected!"
		return
	}
	WinMinimize, ahk_id %winID%
}

showSpotifyButton() {
	DetectHiddenWindows, On
	IfWinActive, ahk_exe Spotify.exe
	{
		Send {Alt down}{tab}{Alt up}
	} else {
		winID := getSpotifyWindow()
		if (winID == "") {
			MsgBox, "Spotify not detected!"
			return
		}
		WinActivate, ahk_id %winID%
	}
}

; TODO: Menu for reassigning quick songs
; TODO: Use Loop for all of them 1 thru 6
; ^!1::
; winID := getSpotifyWindow()
; Run "spotify:track:00oHRduz7cW4vFKCuwBF2W?context=spotify`%3Aplaylist`%3A5OVtD4wy9P1XeNqjt1WWml";
; if (winID == "") {
; 	Sleep, 5300
; } else {
; 	Sleep, 1000
; }
; winID := getSpotifyWindow()
; if (winID == "") {
; 	MsgBox, "Spotify not detected!"
; 	return
; }
; WinActivate, ahk_id %winID%
; Sleep, 300
; Send {Enter}{Enter}
; WinMinimize, ahk_id %winID%
; return

; NumpadPgUp::
; ; Steam
; Run "steam://open/games"
; WinMove, Steam, , 0, 0, 1920, 1080
; WinMaximize, Steam
; ; Discord
; DetectHiddenWindows, On
; WinGet, winInfo, List, ahk_exe Discord.exe
; Loop, %winInfo%
; {
; 	thisID := winInfo%A_Index%
; 	WinGetTitle, Title, ahk_id %thisID%
; 	if (title == "") {
; 		continue
; 	}
; 	if (InStr(Title, "Discord")) {
; 		WinActivate, ahk_id %thisID%
; 		WinMove, ahk_id %thisID%, , 1912, 57, 1616, 876
; 		WinMaximize, ahk_id %thisID%
; 	}	
; }
; return
