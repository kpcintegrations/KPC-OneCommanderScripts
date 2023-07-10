# Installs OC Scripts and PS Scripts that accompany the OC Scripts
# Must Have OneCommander Running While Installing
if (!(Get-Command wt.exe -CommandType Application -ErrorAction SilentlyContinue)) {
    winget install Microsoft.WindowsTerminal --silent
}
else {
    Write-Host "WT Already Installed"
}
if (!(Test-Path -Path "C:\Program Files\PowerShell\7\pwsh.exe") -or !(Test-Path -Path "C:\Program Files\PowerShell\7-preview\pwsh.exe")) {
    winget install Microsoft.PowerShell --scope machine --silent
}
else {
    Write-Host "PowerShell 7 Already Installed"
}
$OCPath = (Get-Process OneCommander).Path
$ParseOCPath = $OCPath.Replace("onecommander.exe","") + 'Resources\Scripts\'
if (Test-Path $ParseOCPath) {
    Copy-Item -Recurse -Path  "$PSScriptRoot\KPC\" -Destination $ParseOCPath -Force
    Copy-Item -Recurse -Path "$PSScriptRoot\OC\" -Destination ($ParseOCPath | Join-Path -ChildPath "..\KPC\") -Force
    #. "C:\Program Files\PowerShell\Scripts\OC\Invoke-OCInit.ps1"
}
else {
    New-Item -Path $ParseOCPath -ItemType Directory -Force
    Copy-Item -Recurse -Path  "$PSScriptRoot\KPC\" -Destination $ParseOCPath -Force
    Copy-Item -Recurse -Path "$PSScriptRoot\OC\" -Destination ($ParseOCPath | Join-Path -ChildPath "..\KPC\") -Force
    #. "C:\Program Files\PowerShell\Scripts\OC\Invoke-OCInit.ps1"
}