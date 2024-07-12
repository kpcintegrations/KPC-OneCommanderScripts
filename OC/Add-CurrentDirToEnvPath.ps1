$OCVars = Get-OCVars
$CurDir = $OCVars.CurrentDir
$UserPath = [System.Environment]::GetEnvironmentVariable("PATH","User")
$UserPath | Out-File -FilePath "D:\KyleTemp\BackUserPath.txt"
$NewUserPath = ($UserPath + ";" + $CurDir)
[System.Environment]::SetEnvironmentVariable("PATH",$NewUserPath,"User")

