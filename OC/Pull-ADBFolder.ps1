$OCVars = (Import-Clixml -Path $PSScriptroot'\Export\Vars.xml' )
$CurDir = $OCVars["CurrentDir"]
$ADBFolder = Read-Host -Prompt "Enter the User folder you wish to copy to the current directory"
adb pull $ADBFolder $CurDir