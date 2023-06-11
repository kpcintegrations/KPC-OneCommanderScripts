Write-Host "Enter A Folder Path To Merge Directories To"
$Folder = Read-Host
$VarClixml = Import-Clixml -Path "C:\Program Files\PowerShell\Scripts\OC\Export\Vars.xml"
$CurDir = $VarClixml["CurrentDir"]
$OpDir = $VarClixml["OpDir"]
Copy-Item -Path "$CurDir + '\*'" -Destination $Folder -Recurse
Copy-Item -Path "$OpDir + '\*'" -Destination $Folder -Recurse
