$MainHash = Import-Clixml -Path ($PSScriptRoot + "\Export\Vars.xml")
$CurrentDir = $MainHash["CurrentDir"]
if (Test-Path -Path ($PSScriptRoot + "\Export\CusVars.xml")) {
$VarHash = Import-Clixml -Path ($PSScriptRoot + "\Export\CusVars.xml")
}
else {
    $VarHash = @{}
}
$DirName = (Get-Item -Path $CurrentDir -Force).Name
$VarHash += @{
    $DirName=$CurrentDir
}
$VarHash | Export-Clixml -Path ($PSScriptRoot + "\Export\CusVars.xml") -Force