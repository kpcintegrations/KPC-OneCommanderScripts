$adbOuput = Start-Process -PassThru -Wait -FilePath "$PSScriptRoot\Tools\adb.exe" -ArgumentList 'devices'
if ($adbOuput.ExitCode -eq 0) {
    Start-Process -NoNewWindow -Wait -FilePath "$PSScriptRoot\Tools\adb.exe" -ArgumentList 'devices' -RedirectStandardOutput "$PSScriptRoot\Export\adbdevicesout.txt"
    $OutputDevices = Get-Content -Path "$PSScriptRoot\Export\adbdevicesout.txt" -Force
    Remove-Item -Path "$PSScriptRoot\Export\adbdevicesout.txt"
    [Collections.Generic.List[Object]]$DeviceList = @()
    for ($i = 0; $i -lt $OutputDevices.Length; $i++) {
        if ($i -eq 0 -or $i -eq ($OutputDevices.Length - 1)) {}
        else {
            $DeviceList.Add(($OutputDevices[$i]))
        }
    }
}
else {
    Write-Host "No Devices To List Or Other adb.exe Problem"
}
$DeviceList = $DeviceList | ForEach-Object {
    $_.Replace("device", "").TrimEnd()
}
$DeviceList | Out-File -FilePath "$PSScriptRoot\Export\adbdevices.txt" -Encoding utf8