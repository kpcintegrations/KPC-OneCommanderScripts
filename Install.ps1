# Installs OC Scripts and PS Scripts that accompany the OC Scripts
# Must Have OneCommander Running While Installing
if (!(Get-Command wt.exe -CommandType Application -ErrorAction SilentlyContinue)) {
    winget install Microsoft.WindowsTerminal --scope machine --silent
}
else {
    Write-Host "WT Already Installed"
}
if (!(Get-Command pwsh.exe -CommandType Application -ErrorAction SilentlyContinue)) {
    winget install Microsoft.PowerShell --scope machine --silent
}
else {
    Write-Host "PowerShell 7 Already Installed"
}
$OCPath = (Get-Process OneCommander).Path
$ParseOCPath = (Get-Item -LiteralPath $OCPath).Directory.FullName + '\Resources\Scripts\'
$ParseParseOCPath = ($ParseOCPath | Join-Path -ChildPath "..\KPC\")
    New-Item -Path $ParseOCPath -ItemType Directory -Force
    Copy-Item -Recurse -Path  "$PSScriptRoot\KPC\" -Destination $ParseOCPath -Force
    Copy-Item -Recurse -Path "$PSScriptRoot\OC\" -Destination $ParseParseOCPath -Force
    . "$ParseParseOCPath\Invoke-OCInit.ps1"