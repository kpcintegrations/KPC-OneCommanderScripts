Add-Type -AssemblyName PresentationFramework
        $adbOuput = Start-Process -PassThru -Wait -FilePath "adb" -ArgumentList 'devices'
        if ($adbOuput.ExitCode -eq 0) {
            Start-Process -NoNewWindow -Wait -FilePath "adb.exe" -ArgumentList 'devices' -WorkingDirectory $PSScriptRoot -RedirectStandardOutput 'adbdevicesout.txt'
            New-Variable -Scope Global -Name "OutputDevices" -Value (Get-Content -Path ($PSScriptRoot + '\adbdevicesout.txt') -Force) -Force
        }
        else { 
        Invoke-WebRequest -Uri "https://dl.google.com/android/repository/platform-tools_r34.0.3-windows.zip" -OutFile ".\platform-tools2.zip"
        }
        $messageText = $OutputDevices[0] + "`n" + $OutputDevices[1]
        [System.Windows.MessageBox]::Show("$messageText","","OK") 