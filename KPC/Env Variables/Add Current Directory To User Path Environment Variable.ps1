#PS7
$ParseOCPath = Get-OCPath
Set-OCVars -CurrentDir $Env:Current_Dir
& pwsh -File (Join-Path $ParseOCPath 'Resources\KPC\Add-CurrentDirToEnvPath.ps1')