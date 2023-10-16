New-Item -Path $PSScriptRoot -Name 'Export' -ItemType 'Directory' -Force
$Path = "$PSScriptRoot\Export\"
$ProfileContents = Get-Content -Path $PROFILE -Raw
$RawProfileContent = @'
$CustomVariables = Import-Clixml -Path "$Path\CusPSVars.xml"
$CustomVariables.GetEnumerator() | ForEach-Object -Process { New-Variable -Name $_.Name -Value $_.Value -Option AllScope -Scope Global -Force }
'@
$RawProfileParsed = $RawProfileContent.Replace('$Path',$Path)

$SB = {if (Test-Path $PROFILE) {
    if (!($ProfileContents.Contains($RawProfileParsed))) {
Add-Content -Path $PROFILE -Value ""
Add-Content -Path $PROFILE -Value $RawProfileParsed
    }
}
else {
    New-Item -Path $PROFILE -Value $null -ItemType File -Force
    if ($ProfileContents -notcontains $RawProfileParsed) {
    Add-Content -Path $PROFILE -Value ""
Add-Content -Path $PROFILE -Value $RawProfileParsed
    }
}
}

if ($PSVersionTable["PSVersion"].Major -eq 5) {
    Write-Host "Switching to PS 7"
    & pwsh.exe -Command $SB
}
else {
    Invoke-Command -ScriptBlock $SB
}
$VarHash = @{}
$VarHash | Export-Clixml -Path "$Path\Vars.xml"