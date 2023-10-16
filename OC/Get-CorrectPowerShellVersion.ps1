if ($PSVersionTable["PSVersion"].Major -eq 5) {
    Write-Host "Switching to PS 7"
    & pwsh.exe -File "$PSScriptRoot\Invoke-OCInit.ps1"
}
else {
    . "$PSScriptRoot\Invoke-OCInit.ps1"
}