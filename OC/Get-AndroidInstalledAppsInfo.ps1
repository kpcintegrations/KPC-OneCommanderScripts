adb -d shell pm list packages -3 -f | Out-File -FilePath "$PSScriptRoot\Export\adbpackages.txt"
$NewLineSplitPackages = Get-Content -Path "$PSScriptRoot\Export\adbpackages.txt"
$ParsedADBPaths = @()
$ParsedADBPackageNames = @()
foreach ($line in $NewLineSplitPackages) {
    $ParsedPath1 = ($line -replace '^package:' -replace '(?<=base\.apk).*')
    $PackageName = ($line -split "=")[-1].ToString()
    $ParsedADBPaths += $ParsedPath1
    $ParsedADBPackageNames += $PackageName
}
New-Item -Path "$PSScriptRoot\Export\ApkFiles\" -ItemType Directory -Force
for ($i = 0; $i -lt $ParsedADBPaths.Count; $i++) {
    & adb pull $ParsedADBPaths[$i] "$PSScriptRoot\Export\ApkFiles\$($ParsedADBPackageNames[$i]).apk"
}
$GetApks = Get-ChildItem -Path "$PSScriptRoot\Export\ApkFiles\" -File -Force
$CommonNames = @{}
foreach ($apk in $GetApks) {
    $RawAAPT2Dump = . "$PSScriptRoot\Tools\aapt2.exe" dump badging $apk.FullName
    $ParsedDump = $RawAAPT2Dump | Select-String "(?<=application-label:')[^']+" | ForEach-Object { $_.Matches.Value }
    $CommonNames.Add($apk.BaseName,$ParsedDump)
}
$SortedApksByCommonName = $CommonNames.GetEnumerator() | Sort-Object -Property Value
$SortedApksByCommonName | Out-GridView -Title "Apks & Names"