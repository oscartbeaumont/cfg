Import-Module ./windows-helpers.psm1

echo "Provisioning Machine"
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

$ShouldInstallApplications = Read-Host -Prompt "Install Store Applications [n]"
if ($ShouldInstallApplications -ne "n") {
    start "ms-windows-store://pdp?productId=9NCBCSZSJRSB"
    Read-Host -Prompt "Spotify Installed..."

    start "ms-windows-store://pdp?productId=9WZDNCRF0083"
    Read-Host -Prompt "Messenger Installed..."

    # TODO: Everything Else
}

# Set Wallpaper
$WallpaperURL = "https://otbeaumont.me/assets/wallpaper.jpeg"
$WallpaperPath = [Environment]::GetFolderPath("MyPictures") + "\Wallpaper.jpeg"
Invoke-WebRequest -Uri $WallpaperURL -OutFile $WallpaperPath
Set-WallPaper -Image $WallpaperPath

# Remove lock screen hints
Set-ItemProperty -path 'HKCU:Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'ContentDeliveryAllowed' -value '1'
Set-ItemProperty -path 'HKCU:Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenEnabled' -value '1'
Set-ItemProperty -path 'HKCU:Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenOverlayEnabled' -value '0'
Set-ItemProperty -path 'HKCU:Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338387Enabled' -value '0'

# Setup Dropbox
$SharePath = [Environment]::GetFolderPath("MyDocuments")+"\Dropbox"
if(!(Test-Path -path $SharePath)) {  
    New-Item -Path $SharePath -ItemType "directory"
}
New-SmbShare -Name Dropbox -Path $SharePath -FullAccess 'Everyone' 

# Remove Default Applications
Remove-AppxPackage -Package "Microsoft.WindowsMaps_10.2009.2.0_x64__8wekyb3d8bbwe"
Remove-AppxPackage -Package "Microsoft.People_10.1909.10841.0_x64__8wekyb3d8bbwe"
Remove-AppxPackage -Package "Microsoft.XboxApp_48.70.21001.0_x64__8wekyb3d8bbwe"
# TODO: Rest of them

# CAN'T: Set Chrome as Default Browser
# DNS Over HTTPS
# Chrome default browser