$OCVars = Import-Clixml -Path ($PSScriptRoot + "\Export\Vars.xml")
$CurrentDir = $OCVars.CurrentDir
if (Test-Path -Path (Join-Path $PSScriptRoot "\Export\CusPSVars.xml")) {
$VarHash = Import-Clixml -Path (Join-Path $PSScriptRoot "\Export\CusPSVars.xml")
}
else {
    $VarHash = @{}
}
$DirName = (Get-Item -Path $CurrentDir -Force).Name
$VarHash += @{
    $DirName=$CurrentDir
}
$VarHash | Export-Clixml -Path ($PSScriptRoot + "\Export\CusPSVars.xml") -Force