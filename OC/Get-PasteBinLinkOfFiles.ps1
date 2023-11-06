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

try {
    $devApiKey = Get-Content -Path (Join-Path $PSScriptRoot "\Export\pastebindevapikey.txt") -ErrorAction Stop -Encoding utf8
}
catch {
    
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Size = New-Object System.Drawing.Size(300,200)
$mainForm.StartPosition = "CenterScreen"

$label = New-Object System.Windows.Forms.Label
$label.Size = New-Object System.Drawing.Size(200,25)
$label.Location = New-Object System.Drawing.Size(50,25)
$label.Text = "Paste Dev Api Key Here:"

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Size = New-Object System.Drawing.Size(200,25)
$textBox.Location = New-Object System.Drawing.Size(50,75)

$button = New-Object System.Windows.Forms.Button
$button.Size = New-Object System.Drawing.Size(50,30)
$button.Location = New-Object System.Drawing.Size(125,125)
$button.Text = "OK"

$mainForm.Controls.Add($label)
$mainForm.Controls.Add($textBox)
$mainForm.Controls.Add($button)

$devApiKey = ""

$buttonSB = {
    $devApiKey = $textBox.Text
    $devApiKey | Out-File -FilePath (Join-Path $PSScriptRoot "\Export\pastebindevapikey.txt")
    $mainForm.Close()
}

$button.Add_Click($buttonSB)

$mainForm.ShowDialog()
}

$OCVars = Import-Clixml -Path ($PSScriptRoot + "\Export\Vars.xml")
$CurrentDir = $OCVars.CurrentDir
$SelectedFiles = $OCVars.SelectedFiles
$FilesInCurDir = Get-ChildItem -Path $CurrentDir -File -Force
$FilesNames = $FilesInCurDir.Name -join "`n"
if($SelectedFiles -ne ""){
$ParsedSelectedFiles = $SelectedFiles | ForEach-Object -Process {
    Split-Path -Path $_ -Leaf
}
}
$StringFiles = $ParsedSelectedFiles -join "`n"

if ($SelectedFiles -ne "") {
$Body = @{
    api_dev_key = $devApiKey
    api_option = "paste"
    api_paste_code = $StringFiles
}
}
else {
    $Body = @{
        api_dev_key = $devApiKey
        api_option = "paste"
        api_paste_code = $FilesNames
    }
}
$Result = Invoke-RestMethod -Uri "https://pastebin.com/api/api_post.php" -Method Post -Body $Body
Set-Clipboard -Value $Result