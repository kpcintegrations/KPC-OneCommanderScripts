$OCVars = Import-Clixml -Path ($PSScriptRoot + "\Export\Vars.xml")
$SelectedFiles = $OCVars.MultiSelection
if ($SelectedFiles.Count -gt 1) {
    foreach ($File in $SelectedFiles) {
        $SelFileMD5Hash = Get-FileHash -Path $File -Algorithm MD5
        $SplitPathLeaf = Split-Path -Path $File -Leaf
        Set-Clipboard -Value "$SplitPathLeaf - $($SelFileMD5Hash.Hash)"
    }
}
else {
    $SelFileMD5Hash = Get-FileHash -Path $SelectedFiles -Algorithm MD5
    $SplitPathLeaf = Split-Path -Path $SelectedFiles -Leaf
    Set-Clipboard -Value "$SplitPathLeaf - $($SelFileMD5Hash.Hash)"
}