$ParseOCPath = Get-OCPath
Set-OCVars -CurrentDir $Env:Current_Dir -$SelMultiple $Env:Selected_Files
& (Join-Path $ParseOCPath 'Resources\KPC\Add-OCVariableToPS.ps1')