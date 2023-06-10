if (!(Test-Path -Path "C:\Program Files\PowerShell\Scripts\")) {
    New-Item -Path "C:\Program Files\PowerShell\" -Name 'Scripts' -ItemType 'Directory' -Force
}
New-Item -Path $PSScriptRoot -Name 'Export' -ItemType 'Directory' -Force

$RawProfileContent = @'
$CustomVariables = Import-Clixml -Path ('C:\Program Files\PowerShell\Scripts\OC\Export\CusVars.xml')
$CustomVariables.GetEnumerator() | ForEach-Object -Process { New-Variable -Name $_.Name -Value $_.Value -Option AllScope -Scope Global -Force }
'@
Add-Content -Path $PROFILE -Value ""
Add-Content -Path $PROFILE -Value $RawProfileContent
$VarHash = @{}
$VarHash | Export-Clixml -Path ($PSScriptRoot + '\Export\CusVars.xml')