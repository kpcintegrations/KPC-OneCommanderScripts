#PS7
$SelectedFiles = $Env:Selected_Files -split "\n"
$SelectedFiles | ForEach-Object {cmd /K $_}
