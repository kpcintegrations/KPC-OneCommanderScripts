Add-Type -AssemblyName System.Windows.Forms
Add-Type -TypeDefinition '
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;

public class DPIAware {
    public static readonly IntPtr UNAWARE              = (IntPtr) (-1);
    public static readonly IntPtr SYSTEM_AWARE         = (IntPtr) (-2);
    public static readonly IntPtr PER_MONITOR_AWARE    = (IntPtr) (-3);
    public static readonly IntPtr PER_MONITOR_AWARE_V2 = (IntPtr) (-4);
    public static readonly IntPtr UNAWARE_GDISCALED    = (IntPtr) (-5);

    [DllImport("user32.dll", EntryPoint = "SetProcessDpiAwarenessContext", SetLastError = true)]
    private static extern bool NativeSetProcessDpiAwarenessContext(IntPtr Value);

    public static void SetProcessDpiAwarenessContext(IntPtr Value) {
        if (!NativeSetProcessDpiAwarenessContext(Value)) {
            throw new Win32Exception();
        }
    }
}
'
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Size = New-Object System.Drawing.Size(650,250)
$mainForm.StartPosition = "CenterScreen"

$label = New-Object System.Windows.Forms.Label
$label.Size = New-Object System.Drawing.Size(600,25)
$label.Location = New-Object System.Drawing.Size(25,25)
$label.Text = "Select which packages to list"

$checkbox1 = New-Object System.Windows.Forms.CheckBox
$checkbox1.Size = New-Object System.Drawing.Size(200,25)
$checkbox1.Location = New-Object System.Drawing.Size(100,75)
$checkbox1.Text = "Third Party Packages"

$checkbox2 = New-Object System.Windows.Forms.CheckBox
$checkbox2.Size = New-Object System.Drawing.Size(200,25)
$checkbox2.Location = New-Object System.Drawing.Size(350,75)
$checkbox2.Text = "System Packages"

$button = New-Object System.Windows.Forms.Button
$button.Size = New-Object System.Drawing.Size(200,50)
$button.Location = New-Object System.Drawing.Size(225,125)
$button.Text = "OK"
New-Variable -Name "ADBArgs" -Value "" -Scope Global
$buttonSB = {
    if ($checkbox1.Checked -and $checkbox2.Checked) {
        Set-Variable -Name "ADBArgs" -Value "-d", "shell", "pm", "list", "packages", "-a", "-f" -Scope Global
    }
    elseif ($checkbox1.Checked -and !($checkbox2.Checked)) {
        Set-Variable -Name "ADBArgs" -Value "-d", "shell", "pm", "list", "packages", "-3", "-f" -Scope Global
    }
    elseif (!($checkbox1.Checked) -and $checkbox2.Checked) {
        Set-Variable -Name "ADBArgs" -Value "-d", "shell", "pm", "list", "packages", "-s", "-f" -Scope Global
    }
    else {
        Write-Host "No Selection Made!"
    }
    $mainForm.Close()
}
$button.Add_Click($buttonSB)


$mainForm.Controls.Add($label)
$mainForm.Controls.Add($checkbox1)
$mainForm.Controls.Add($checkbox2)
$mainForm.Controls.Add($button)

$mainForm.ShowDialog()

$Args2 = Get-Variable -Name "ADBArgs" -ValueOnly -Scope Global
& "$PSScriptRoot\Tools\adb.exe" @Args2 | Out-File -FilePath "$PSScriptRoot\Export\adbpackages.txt"
$NewLineSplitPackages = Get-Content -Path "$PSScriptRoot\Export\adbpackages.txt"
$ParsedADBPaths = @()
$ParsedADBPackageNames = @()
foreach ($line in $NewLineSplitPackages) {
    $ParsedPath1 = ($line -replace '^package:' -replace '(?<=base\.apk).*')
    $PackageName = ($line -split "=")[-1].ToString()
    $ParsedADBPaths += $ParsedPath1
    $ParsedADBPackageNames += $PackageName
}
if (Test-Path "$PSScriptRoot\Export\ApkFiles\") {
    Remove-Item -Path "$PSScriptRoot\Export\ApkFiles\" -Recurse -Force
}
New-Item -Path "$PSScriptRoot\Export\ApkFiles\" -ItemType Directory -Force
for ($i = 0; $i -lt $ParsedADBPaths.Count; $i++) {
    $Args3 = "pull", "$($ParsedADBPaths[$i])", "$PSScriptRoot\Export\ApkFiles\$($ParsedADBPackageNames[$i]).apk"
    & "$PSScriptRoot\Tools\adb.exe" @Args3
}
$GetApks = Get-ChildItem -Path "$PSScriptRoot\Export\ApkFiles\" -File -Force
$CommonNames = @{}
foreach ($apk in $GetApks) {
    $Args4 = "dump", "badging", "$($apk.FullName)"
    $RawAAPT2Dump = & "$PSScriptRoot\Tools\aapt2.exe" @Args4
    $ParsedDump = $RawAAPT2Dump | Select-String "(?<=application-label:')[^']+" | ForEach-Object { $_.Matches.Value }
    $CommonNames.Add($apk.BaseName,$ParsedDump)
}
$SortedApksByCommonName = $CommonNames.GetEnumerator() | Sort-Object -Property Value
$SortedApksByCommonName | Out-GridView -Title "Apks & Names"