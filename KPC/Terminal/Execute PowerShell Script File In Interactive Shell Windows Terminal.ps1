#PS7
$SelectedFiles = $Env:Selected_Files -split "\n" 
$SelectedFiles | ForEach-Object {pwsh -Interactive -NoExit -File $_}
