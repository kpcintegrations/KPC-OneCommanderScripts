. "$PSScriptRoot\Tools\adb.exe" "devices"
if ($LASTEXITCODE -eq 0) {
    $DeviceList = & "$PSScriptRoot\Tools\adb.exe" "devices" | Select-Object -Skip 1
    $DeviceList = $DeviceList | ForEach-Object {
        $_.Replace("device", "").TrimEnd()
    }
    $DeviceList | Out-File -FilePath "$PSScriptRoot\Export\adbdevices.txt" -Encoding utf8
}
else {
    Write-Host "No Device Found, or Other ADB Error!"
}