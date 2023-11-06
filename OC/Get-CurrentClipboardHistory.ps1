Add-Type -AssemblyName System.Runtime.WindowsRuntime
$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
function Await($WinRtTask, $ResultType) {
    $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
    $netTask = $asTask.Invoke($null, @($WinRtTask))
    $netTask.GetAwaiter().GetResult() | Out-Null
    $netTask.Result
}
$null = [Windows.ApplicationModel.DataTransfer.Clipboard, Windows.ApplicationModel.DataTransfer, ContentType = WindowsRuntime]
$op = [Windows.ApplicationModel.DataTransfer.Clipboard]::GetHistoryItemsAsync()

$ClipHistResultsRaw = Await ($op) ([Windows.ApplicationModel.DataTransfer.ClipboardHistoryItemsResult])

try {
$ClipHistResults = $ClipHistResultsRaw.Items.Content.GetTextAsync()
$ClipHistList = foreach ($ClipItem in $ClipHistResults) { Await($ClipItem) ([String]) }
}
catch {
    Write-Host "Non Text On Clipboard History"
}