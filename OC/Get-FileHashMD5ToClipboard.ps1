$OCVars = Import-Clixml -Path ($PSScriptRoot + "\Export\Vars.xml")
$SelectedFiles = $OCVars.SelectedFiles
$SelectedFiles | ForEach-Object -Process {
    $SelFileMD5Hash = Get-FileHash -LiteralPath $_ -Algorithm MD5
    $SplitPathLeaf = Split-Path -Path $_ -Leaf
    if ($_.Count -gt 1) {
        Set-Clipboard -Value "$SplitPathLeaf - $($SelFileMD5Hash.Hash)"
    }
    else {
        Set-Clipboard -Value "$($SelFileMD5Hash.Hash)"
    }
    Start-Sleep -Milliseconds 250
}