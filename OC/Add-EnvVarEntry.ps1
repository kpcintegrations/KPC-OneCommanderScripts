param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]
    $EnvVarEntry,
    [Parameter(Mandatory = $true, Position = 1)]
    [string]
    $EnvVarName,
    [Parameter(Mandatory = $false, Position = 2)]
    [switch]
    $SingleEntry
)
if (!($SingleEntry)) {
$CurEnvVar = [System.Environment]::GetEnvironmentVariable($EnvVarName)
$CurEnvVarArray = $CurEnvVar | Split-String -Separator ';'
$CurEnvVarArray += $EnvVarEntry
New-Variable -Name "BuiltString" -Value "" -Scope Global
$CurEnvVarArray | ForEach-Object -Process {
    $TmpVar = (Get-Variable -Name "BuiltString" -ValueOnly -Scope Global)
    Set-variable -Name "BuiltString" -Value "$TmpVar$_`;" -Scope Global
}
$JustInCaseBuiltString = Get-Variable -Name "BuiltString" -ValueOnly -Scope Global
[System.Environment]::SetEnvironmentVariable("PATH",$JustInCaseBuiltString)
}
else {
    [System.Environment]::SetEnvironmentVariable($EnvVarName,$EnvVarEntry,'Machine')
}