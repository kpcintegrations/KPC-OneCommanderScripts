New-Item -Path $PSScriptRoot -Name 'Export' -ItemType 'Directory' -Force
$Path = ($PSScriptRoot | Join-Path -ChildPath '.\Export\')
$RawProfileContent = @'
$CustomVariables = Import-Clixml -Path "{0}\CusVars.xml"
$CustomVariables.GetEnumerator() | ForEach-Object -Process { New-Variable -Name $_.Name -Value $_.Value -Option AllScope -Scope Global -Force }
'@ -f $Path
if (Test-Path $PROFILE) {
Add-Content -Path $PROFILE -Value ""
Add-Content -Path $PROFILE -Value $RawProfileContent
}
else {
    New-Item -Path $PROFILE -Value $null -ItemType File -Force
    Add-Content -Path $PROFILE -Value ""
Add-Content -Path $PROFILE -Value $RawProfileContent.Replace('$Path',"$Path")
}
$VarHash = @{}
$VarHash | Export-Clixml -Path "$Path\CusVars.xml"