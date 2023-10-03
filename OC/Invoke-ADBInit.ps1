        try {
            $adbOuput = Start-Process -PassThru -Wait -FilePath "$PSScriptRoot\platform-tools\adb.exe" -ArgumentList 'devices'
        }
        catch {
            Write-Host "ADB Not Installed! Installing Now..."
            Invoke-WebRequest -Uri "https://dl.google.com/android/repository/platform-tools_r34.0.3-windows.zip" -OutFile "$PSScriptRoot\platform-tools.zip"
            Microsoft.PowerShell.Archive\Expand-Archive -Path "$PSScriptRoot\platform-tools.zip" -DestinationPath $PSScriptRoot -Force
            Remove-Item -Path "$PSScriptRoot\platform-tools.zip" -Force
            $adbOuput = Start-Process -PassThru -Wait -FilePath "$PSScriptRoot\platform-tools\adb.exe" -ArgumentList 'devices'
        }
        if ($adbOuput.ExitCode -eq 0) {
            Start-Process -NoNewWindow -Wait -FilePath "$PSScriptRoot\platform-tools\adb.exe" -ArgumentList 'devices' -RedirectStandardOutput "$PSScriptRoot\Export\adbdevicesout.txt"
            $OutputDevices = Get-Content -Path "$PSScriptRoot\Export\adbdevicesout.txt" -Force
            Remove-Item -Path "$PSScriptRoot\Export\adbdevicesout.txt"
            [Collections.Generic.List[Object]]$DeviceList = @()
            for ($i=0;$i -lt $OutputDevices.Length;$i++) {
                if ($i -eq 0 -or $i -eq ($OutputDevices.Length -1)) {}
                else {
                    $DeviceList.Add(($OutputDevices[$i]))
                }
            }
        }
        else {
            Write-Host "No Devices To List Or Other adb.exe Problem"
        }
$DeviceList = $DeviceList | ForEach-Object {
    $_.Replace("device","").TrimEnd()
}
$DeviceList | Out-File -FilePath "$PSScriptRoot\Export\adbdevices.txt" -Encoding utf8