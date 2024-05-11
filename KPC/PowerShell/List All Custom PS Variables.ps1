#PS7
$ParseOCPath = Get-OCPath
$CustomAddedVars = Import-Clixml (Join-Path $ParseOCPath 'Resources\KPC\Export\CusPSVars.xml')

$OGVResults = $CustomAddedVars | Out-GridView -Title "Select Vars To Edit!" -OutputMode Multiple

$OGVResults
