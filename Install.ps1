# Installs OC Scripts and PS Scripts that accompany the OC Scripts
# Must Supply Path to OneCommander Resources Scripts Folder
param (
    [Parameter(Mandatory=$true,Position=0)]
    [string]
    $OCResourcesScriptsPath
)
Move-Item -Path ($PSScriptRoot + '\KPC\') -Destination $OCResourcesScriptsPath -Force
Move-Item -Path ($PSScriptRoot + '\OC\') -Destination "C:\Program Files\PowerShell\Scripts\" -Force