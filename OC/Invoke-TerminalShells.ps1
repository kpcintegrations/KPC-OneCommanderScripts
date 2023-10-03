try {
    $wtContentJson = Get-Content -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -ErrorAction Stop
}
catch {
    $wtContentJson = Get-Content -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
}
$wtContentObj = $wtContentJson | ConvertFrom-Json
$promptGuids = $wtContentObj.profiles.list.guid
$promptNames = $wtContentObj.profiles.list.name

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

[DPIAware]::SetProcessDpiAwarenessContext([DPIAware]::PER_MONITOR_AWARE_V2)

Add-Type -AssemblyName System.Drawing

$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Size = New-Object System.Drawing.Size(500,850)
$mainForm.StartPosition = "CenterScreen"

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Size = New-Object System.Drawing.Size(425,650)
$listBox.Location = New-Object System.Drawing.Size(25,25)
foreach ($promptName in $promptNames) {
$listBox.Items.Add($promptName)
}

$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "Launch Prompt"
$okButton.Size = New-Object System.Drawing.Size(100,50)
$okButton.Location = New-Object System.Drawing.Size(200,700)

$mainForm.Controls.Add($listBox)
$mainForm.Controls.Add($okButton)

$Global:LaunchTerminalCmd = {
    wt -p $promptGuids[$listBox.SelectedIndex]
    $mainForm.Close()
}

$okButton.Add_Click($Global:LaunchTerminalCmd)


$mainForm.ShowDialog()

