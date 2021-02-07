#Requires -RunAsAdministrator
Add-Type -AssemblyName PresentationFramework
[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

# TODO Future Projects: Clear Windows Bloatware, SSO for all installed applications (Do via MDM and Executor), DNS Over HTTPS
# TODO Add to script: ComputerName is asked to be changed twice (after script is rebooted), Enable Hibernation Option, Map WSL as a network drive

$BaseSoftware = 'googlechrome', 'spotify', 'google-backup-and-sync', 'bitwarden', 'eartrumpet', 'discord', 'slack', 'microsoft-windows-terminal', 'office365proplus'
$ExtSoftware = 'zerotier-one', 'autohotkey', 'barrier', 'vscode', 'github-desktop', 'postman', 'vcxsrv', 'arduino', 'burp-suite-free-edition', 'steam', 'epicgameslauncher'
$DesktopShortcutsToRemove = 'Google Chrome.lnk', 'Spotify.lnk', 'Discord.lnk', 'Postman.lnk', 'Github Desktop.lnk', 'Google Docs.lnk', 'Google Sheets.lnk', 'Google Slides.lnk', 'Steam.lnk', 'Bitwarden.lnk', 'Visual Studio Code.lnk', 'Arduino.lnk', 'Epic Games Launcher.lnk', 'XLaunch.lnk'

if ($env:ComputerName -like ("Desktop-*")) {
    Write-Host "Detected Default Computer Name. Changing..."
    $newComputerName = [Microsoft.VisualBasic.Interaction]::InputBox('A defaut computer name was detected. Please set a new one!', 'My System Deploy')
    if ($newComputerName -eq "") {
        Write-Host "No computer name was specified by the user. Keeping default!"
    } else {
        Write-Host "Setting Computer Name to: " + $newComputerName
        Rename-Computer -NewName $newComputerName
    }
}

If(!(Test-Path -Path "$env:ProgramData\Chocolatey")) {
    Write-Host 'Installing Chocolatey!'
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host 'Chocolatey has been installed! Restarting script!'
    powershell.exe -NoExit -NoLogo -ExecutionPolicy Bypass -File $($PSCommandPath)
    exit
}

Write-Host "Installing Base Software"
ForEach ($PackageName in $BaseSoftware) {
    choco install $PackageName -y
}

Write-Host "Installing Extended Software"
ForEach ($PackageName in $ExtSoftware) {
    choco install $PackageName -y
}

Write-Host "Clearing Default Shortcuts From Desktop"
ForEach ($ShortcutName in $DesktopShortcutsToRemove) {
    $ShortcutName = "C:\Users\*\Desktop\" + $ShortcutName
    Remove-Item -Path $ShortcutName -ErrorAction SilentlyContinue
}

$ShareName = "Dropbox"
$ShareDescription = "A folder for easily sharing data between my machines!"
$ShareDirectory = [Environment]::GetFolderPath("MyDocuments")
$SharePath = $ShareDirectory + "\" + $ShareName
if(!(Get-SMBShare -Name $ShareName -ea 0)){
    Write-Host "Creating Dropbox"
    New-Item -Path $ShareDirectory -Name $ShareName -ItemType "directory" -ErrorAction SilentlyContinue | Out-Null
    New-SmbShare -Name $ShareName -Description $ShareDescription -Path $SharePath -ChangeAccess "Authenticated Users" -FullAccess "Administrators"
} else {
    Write-Host "Dropbox Found. Skipping Creation..."
}

Write-Host "Configuring Start Menu and Taskbar Using Layout File"
# Generate Start Menu Layout Using Command: Export-StartLayout .\startlayout.xml
$StartMenuLayoutFile = $PSScriptRoot + "\startlayout.xml"
Import-StartLayout -LayoutPath $StartMenuLayoutFile -MountPath "C:\"
New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows" -Name "Explorer" -ErrorAction SilentlyContinue
Reg Add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V LockedStartLayout /T REG_DWORD /D 1 /F
Reg Add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V StartLayoutFile /T REG_EXPAND_SZ /D $StartMenuLayoutFile /F
Stop-Process -ProcessName explorer
Start-Sleep -s 10 # Give Explorer time to restart
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "LockedStartLayout" -Force
Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "StartLayoutFile" -Force
Stop-Process -ProcessName explorer

Write-Host "Configuring WSL Features"
# TODO: Use the Powershell version of these commands
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Write-Host "Configuring Timezone"
Set-TimeZone "W. Australia Standard Time"
net start w32time
W32tm /resync /force

Write-Host "Disable Lock Screen Hints"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name ContentDeliveryAllowed -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name RotatingLockScreenEnabled -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name RotatingLockScreenOverlayEnabled -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SubscribedContent-338387Enabled -Value 0

Write-Host "Set Powershell Execution Policy To Be Unrestricted"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force

# TODO: These need to be automated
# Import-Module PowerShellGet
# Install-Module -Name BurntToast

Write-Host "Configure WSL Port Forwarding"
$wslPFAction = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-NoLogo -WindowStyle Hidden -File C:\Users\oscar\Documents\cfg\apps\WSL-PortForward.ps1'
$wslPFTrigger = New-ScheduledTaskTrigger -AtStartup
$TaskName = "WSL Port Forward"
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
Register-ScheduledTask -TaskName $TaskName -Description "Makes WSL2 Ports Accessible to Network!" -Action $wslPFAction -Trigger $wslPFTrigger -RunLevel Highest
Start-ScheduledTask -TaskName $TaskName

Write-Host "Automated Installation Complete..."
Write-Host "Please login to all of your installed applications!"
Write-Host "You must install the following from the Windows Store: Facebook Messenger, Ubuntu"
$popupOut = [System.Windows.MessageBox]::Show('Deployment Complete. Would you like to restart?', 'My System Deploy', 'YesNo', 'Warning')
if ($popupOut -eq 'Yes') {
    Write-Host "Restarting Machine..."
    Start-Sleep -s 5
    Restart-Computer
}