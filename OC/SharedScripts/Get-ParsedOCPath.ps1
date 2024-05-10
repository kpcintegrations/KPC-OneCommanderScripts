function Get-OCPath {
$OCPath = (Get-Process OneCommander).Path
if ($OCPath.Contains('WindowsApp')) {
    $ParseOCPath = (Join-Path $Env:USERPROFILE '\OneCommander\')
}
elseif ($OCPath.Contains('Program Files')) {
    $ParseOCPath = (Join-Path $Env:LOCALAPPDATA '\OneCommander\')
}
else {
$ParseOCPath = (Get-Item -LiteralPath $OCPath).Directory.FullName
}
return $ParseOCPath
}