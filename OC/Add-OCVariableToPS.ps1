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

$OCVars = Import-Clixml -Path ($PSScriptRoot + "\Export\Vars.xml")
$CurrentDir = $OCVars.CurrentDir

if (Test-Path -Path (Join-Path $PSScriptRoot "\Export\CusPSVars.xml")) {
$VarHash = Import-Clixml -Path (Join-Path $PSScriptRoot "\Export\CusPSVars.xml")
}
else {
    $example = @{}
    $example.Add("ExampleVarPath","C:\Windows\System32\drivers\etc\")
    $example | Export-Clixml -Path (Join-Path $PSScriptRoot "\Export\CusPSVars.xml") -Force
    $VarHash = Import-Clixml -Path (Join-Path $PSScriptRoot "\Export\CusPSVars.xml")
}

$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Size = New-Object System.Drawing.Size(500,200)
$mainForm.StartPosition = "CenterScreen"

$label =  New-Object System.Windows.Forms.Label
$label.Size =  New-Object System.Drawing.Size(400,25)
$label.Location =  New-Object System.Drawing.Size(50,25)
$label.Text = "Enter Variable Name Without Preceding '$'"

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Size = New-Object System.Drawing.Size(400,25)
$textBox.Location = New-Object System.Drawing.Size(50,50)
$textBox.Text = (Get-Item -Path $OCVars.CurrentDir).Name

$okButton = New-Object System.Windows.Forms.Button
$okButton.Size = New-Object System.Drawing.Size(100,50)
$okButton.Location = New-Object System.Drawing.Size(200,100)
$okButton.Text = "OK"

$mainForm.Controls.Add($label)
$mainForm.Controls.Add($textBox)
$mainForm.Controls.Add($okButton)

New-Variable -Name "DirName" -Value "" -Scope "Global"

$ButtonClickScript = {
        Set-Variable -Name "DirName" -Scope "Global" -Value $textBox.Text
try {
        $VarHash.Add((Get-Variable -Name "DirName" -Scope "Global" -ValueOnly),$CurrentDir)
        $VarHash | Export-Clixml -Path (Join-Path $PSScriptRoot "\Export\CusPSVars.xml") -Force
        $mainForm.Close()
}
catch {
    $ButtonType = [System.Windows.Forms.MessageBoxButtons]::YesNo

$MessageIcon = [System.Windows.Forms.MessageBoxIcon]::Warning

$MessageBody = "A Varible With That Name Already Exists In Your Custom Collection. Do You Wish To Overwrite It?"

$MessageTitle = "Duplicate Variable Name Detected"

$Result = [System.Windows.Forms.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)

if ($Result -eq "Yes") {
    $VarHash.Add((Get-Variable -Name "DirName" -Scope "Global" -ValueOnly),$CurrentDir)
    $VarHash | Export-Clixml -Path (Join-Path $PSScriptRoot "\Export\CusPSVars.xml") -Force
    $mainForm.Close()
}
else {
    $ButtonType2 = [System.Windows.Forms.MessageBoxButtons]::Ok

$MessageIcon2 = [System.Windows.Forms.MessageBoxIcon]::Information

$MessageBody2 = "Please Replace Variable Name With A Different Name."

$MessageTitle2 = "Replace Name"

[System.Windows.Forms.MessageBox]::Show($MessageBody2,$MessageTitle2,$ButtonType2,$MessageIcon2)
}

}

}

$okButton.Add_Click($ButtonClickScript)

$mainForm.ShowDialog()

