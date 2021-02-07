#Requires -RunAsAdministrator

$ExposedPorts=@(80,443,8443,3000,9000)

# Find WSL Machine IP
$WSLIP = bash.exe -c "ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
if(!($WSLIP -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}')) {
    Write-Host "The Script Exited, the ip address of WSL 2 cannot be found"
    exit
}

$RuleName='WSL 2 Port Forward'
$ListenAddr = "0.0.0.0"
Remove-NetFireWallRule -DisplayName $RuleName -ErrorAction SilentlyContinue
New-NetFireWallRule -DisplayName $RuleName -Direction Outbound -LocalPort $ExposedPorts -Action Allow -Protocol TCP
New-NetFireWallRule -DisplayName $RuleName -Direction Inbound -LocalPort $ExposedPorts -Action Allow -Protocol TCP

Foreach ($port in $ExposedPorts) {
    netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$ListenAddr
    netsh interface portproxy add v4tov4 listenport=$port listenaddress=$ListenAddr connectport=$port connectaddress=$WSLIP
}