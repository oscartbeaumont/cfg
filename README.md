# Configuration

This repository contains the Configuration and Settings for my Machines and software installed on it.

## Deploy My Windows Machine

To provision a new system copy the files and run the following command in an administrative Powershell session.

```powershell
powershell.exe -ExecutionPolicy Bypass .\deploy.ps1
```

Follow the guide [here](https://docs.microsoft.com/en-us/windows/wsl/install-win10) to upgrade the default to WSL 2 before installing [Ubuntu from the Windows Store](https://www.microsoft.com/en-au/p/ubuntu-2004-lts/9n6svws3rx71#activetab=pivot:overviewtab). Then run the following in bash.

```bash
./deploy-wsl.sh
```

