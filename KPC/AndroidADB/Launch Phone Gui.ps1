#PS7
$ParseOCPath = Get-OCPath
Set-OCVars -CurrentDir $Env:Current_Dir -SelMultiple $Env:Selected_Files -OpDir $Env:Current_Dir_Inactive
& (Join-Path $ParseOCPath 'Resources\KPC\Invoke-PhoneGui.ps1')