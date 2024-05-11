#PS7
$ParseOCPath = Get-OCPath
$CustomAddedVars = Import-Clixml (Join-Path $ParseOCPath 'Resources\KPC\Export\CusPSVars.xml')

$SelectedVars = $CustomAddedVars | Out-GridView -Title "Select Vars To Remove!" -OutputMode Multiple

foreach ($VarKey in $SelectedVars.Key) {
        $CustomAddedVars.Remove("$VarKey")
}
$CustomAddedVars | Export-Clixml (Join-Path $ParseOCPath 'Resources\KPC\Export\CusPSVars.xml') -Force