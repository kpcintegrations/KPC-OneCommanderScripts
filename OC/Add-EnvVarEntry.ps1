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
$CurEnvVar = [System.Environment]::GetEnvironmentVariable($EnvVarToAddTo)
$CurEnvVarArray = $CurEnvVar | Split-String -Separator ";"
$CurEnvVarArray += $PathToAdd
$NewEnvVar = $CurEnvVarArray | Join-String -Separator ";"
[System.Environment]::SetEnvironmentVariable("PATH",$NewEnvVar)
