$OCVars = Import-Clixml -Path ($PSScriptRoot + "\Export\Vars.xml")
$SelectedFiles = $OCVars.MultiSelection
$SelectedFiles | ForEach-Object -Process {
    $SelFileMD5Hash = Get-FileHash -LiteralPath $_ -Algorithm MD5
    $SplitPathLeaf = Split-Path -Path $_ -Leaf
    Set-Clipboard -Value "$SplitPathLeaf - $($SelFileMD5Hash.Hash)"
    Start-Sleep -Milliseconds 250
}