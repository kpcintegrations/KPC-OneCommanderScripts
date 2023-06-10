# Installs OC Scripts and PS Scripts that accompany the OC Scripts
# Must Supply Path to OneCommander Resources Scripts Folder
param (
    [Parameter(Mandatory=$true,Position=0)]
    [string]
    $OCResourcesScriptsPath
)
git clone https://github.com/kpcintegrations/KPC-OneCommanderScripts.git "C:\Temp\KPC\"
Move-Item -Path "C:\Temp\KPC\KPC\" -Destination $OCResourcesScriptsPath -Force
Move-Item -Path "C:\Temp\KPC\OC\" -Destination "C:\Program Files\PowerShell\Scripts\" -Force