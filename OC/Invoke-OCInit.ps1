New-Item -Path $PSScriptRoot -Name 'Export' -ItemType 'Directory' -Force
$Path = ($PSScriptRoot | Join-Path '\Export\')
$RawProfileContent = @'
$CustomVariables = Import-Clixml -Path ("$Path\CusVars.xml"
$CustomVariables.GetEnumerator() | ForEach-Object -Process { New-Variable -Name $_.Name -Value $_.Value -Option AllScope -Scope Global -Force }
'@
Add-Content -Path $PROFILE -Value ""
Add-Content -Path $PROFILE -Value $RawProfileContent
$VarHash = @{}
$VarHash | Export-Clixml -Path "$PSScriptRoot\Export\CusVars.xml"