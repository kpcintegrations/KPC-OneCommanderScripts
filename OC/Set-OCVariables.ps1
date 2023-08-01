param(
    [Parameter(Mandatory = $true,
        HelpMessage = 'OC Current Directory Variable/Path ($CurrentDir)')]
    [string]
    $CurrentDir,
    [Parameter(Mandatory = $false,
        HelpMessage = 'OC Current Selected Files ($SelMultiple)')]
    [string]
    $SelMultiple,
    [Parameter(Mandatory = $false,
        HelpMessage = 'OC Opposite Directory Variable/Path ($OpDir)')]
    [string]
    $OpDir
)
$SelMultList = ($SelMultiple -split "\n")

$OCVarHash = @{
    CurrentDir     = $CurrentDir
    MultiSelection = $SelMultList
    OppositeDir    = $OpDir
}
$OCVarHash | Export-Clixml -Path "$PSScriptRoot\Export\Vars.xml" -Force

