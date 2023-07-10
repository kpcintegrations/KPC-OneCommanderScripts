# Installs OC Scripts and PS Scripts that accompany the OC Scripts
# Must Have OneCommander Running While Installing
if (!(Get-Command wt.exe -CommandType Application -ErrorAction SilentlyContinue)) {
    winget install Microsoft.WindowsTerminal --silent
}
else {
    Write-Host "WT Already Installed"
}
if (!(Test-Path -Path "C:\Program Files\PowerShell\7\pwsh.exe")) {
    winget install Microsoft.PowerShell --scope machine --silent
}
$OCPath = (Get-Process OneCommander).Path
$ParseOCPath = $OCPath.Replace("OneCommander.exe","") + 'Resources\Scripts\'
Write-Host $ParseOCPath
<#
Copy-Item -Recurse -Path ($PSScriptRoot + '\KPC\') -Destination $OCResourcesScriptsPath -Force
Copy-Item -Recurse -Path ($PSScriptRoot + '\OC\') -Destination "C:\Program Files\PowerShell\Scripts\" -Force
. "C:\Program Files\PowerShell\Scripts\OC\Invoke-OCInit.ps1"#>