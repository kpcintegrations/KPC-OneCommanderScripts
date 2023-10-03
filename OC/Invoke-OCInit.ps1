New-Item -Path $PSScriptRoot -Name 'Export' -ItemType 'Directory' -Force
$Path = "$PSScriptRoot\Export\"
$RawProfileContent = @'
$CustomVariables = Import-Clixml -Path "$Path\CusVars.xml"
$CustomVariables.GetEnumerator() | ForEach-Object -Process { New-Variable -Name $_.Name -Value $_.Value -Option AllScope -Scope Global -Force }
'@
if (Test-Path $PROFILE) {
Add-Content -Path $PROFILE -Value ""
Add-Content -Path $PROFILE -Value $RawProfileContent.Replace('$Path',$Path)
}
else {
    New-Item -Path $PROFILE -Value $null -ItemType File -Force
    Add-Content -Path $PROFILE -Value ""
Add-Content -Path $PROFILE -Value $RawProfileContent
}
$VarHash = @{}
$VarHash | Export-Clixml -Path "$Path\Vars.xml"