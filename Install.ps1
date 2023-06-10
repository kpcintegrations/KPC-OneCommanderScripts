# Installs OC Scripts and PS Scripts that accompany the OC Scripts
# Must Supply Path to OneCommander Resources Scripts Folder
param (
    [Parameter(Mandatory=$true,Position=0)]
    [string]
    $OCResourcesScriptsPath
)
if (!(Test-Path -Path "C:\Program Files\PowerShell\7\pwsh.exe")) {
    winget install Microsoft.PowerShell --scope machine --silent
}
Copy-Item -Recurse -Path ($PSScriptRoot + '\KPC\') -Destination $OCResourcesScriptsPath -Force
Copy-Item -Recurse -Path ($PSScriptRoot + '\OC\') -Destination "C:\Program Files\PowerShell\Scripts\" -Force
. "C:\Program Files\PowerShell\Scripts\OC\Invoke-OCInit.ps1"