#PS7
$ParseOCPath = Get-OCPath
Set-OCVars -CurrentDir $Env:Current_Dir -OpDir $Env:Current_Dir_Inactive
& pwsh -File (Join-Path $ParseOCPath 'Resources\KPC\Merge-Directories.ps1')