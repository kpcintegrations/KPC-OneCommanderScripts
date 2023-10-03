$OCVars = Import-Clixml -Path ($PSScriptRoot + "\Export\Vars.xml")
$CurDir = $OCVars.CurrentDir
$UserPath = [System.Environment]::GetEnvironmentVariable("PATH","User")
$UserPath | Out-File -FilePath "C:\KyleTemp\BackUserPath.txt"
$NewUserPath = ($UserPath + ";" + $CurDir)
[System.Environment]::SetEnvironmentVariable("PATH",$NewUserPath,"User")

