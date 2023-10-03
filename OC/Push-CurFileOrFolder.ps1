Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$OCVars = Import-Clixml -Path "$PSScriptRoot\Export\Vars.xml"

$DevicesAvaialable = Get-Content -Path "$PSScriptRoot\Export\adbdevices.txt"

$MainForm = New-Object System.Windows.Forms.Form
$MainForm.StartPosition = "CenterScreen"
$MainForm.Size = New-Object System.Drawing.Size(500,800)

$Label1 = New-Object System.Windows.Forms.Label
$Label1.Size = New-Object System.Drawing.Size(400,25)
$Label1.Location = New-Object System.Drawing.Size(50,0)
$Label1.Text = "Choose Device To Push File-Folder To"
$MainForm.Controls.Add($Label1)

$InputTextBox = New-Object System.Windows.Forms.ListBox
$InputTextBox.Size = New-Object System.Drawing.Size(400,100)
$InputTextBox.Location = New-Object System.Drawing.Size(50,25)
$DevicesAvaialable | ForEach-Object {
    $InputTextBox.Items.Add($_)
}

$adbPath = "$PSScriptRoot\platform-tools\adb.exe"

$MainForm.Controls.Add($InputTextBox)

$Label2 = New-Object System.Windows.Forms.Label
$Label2.Size = New-Object System.Drawing.Size(400,25)
$Label2.Location = New-Object System.Drawing.Size(50,150)
$Label2.Text = "Choose Device Folder To Push To"
$MainForm.Controls.Add($Label2)



$InputTextBox2 = New-Object System.Windows.Forms.ListBox
$InputTextBox2.Size = New-Object System.Drawing.Size(400,300)
$InputTextBox2.Location = New-Object System.Drawing.Size(50,175)
$MainForm.Controls.Add($InputTextBox2)

$SelectedDevice = {
    $InputTextBox2.Items.Clear()
    & $adbPath -s $InputTextBox.SelectedItem shell ls /sdcard/ |
        ForEach-Object { $InputTextBox2.Items.Add($_) }
    $InputTextBox2.Refresh()
}
$InputTextBox.add_SelectedIndexChanged($SelectedDevice)

$PushButton = New-Object System.Windows.Forms.Button
$PushButton.Text = "Push"
$PushButton.Size = New-Object System.Drawing.Size(100,50)
$PushButton.Location = New-Object System.Drawing.Size(200,500)
$MainForm.Controls.Add($PushButton)

$Global:PushTheFiles = ""
if ($OCVars.MultiSelection -ne "") {
    $Global:PushTheFiles = {
        $OCVars.MultiSelection | ForEach-Object {
        & $adbPath -s $InputTextBox.SelectedItem push $_ ("/sdcard/" + $InputTextBox2.SelectedItem)
    }
    $MainForm.Close()
}
}
else {
$Global:PushTheFiles = {
    & $adbPath -s $InputTextBox.SelectedItem.Text push $OCVars.CurrentDir ('/sdcard/' + $InputTextBox2.SelectedItem)
    $MainForm.Close()
}
}
$PushButton.Add_Click($Global:PushTheFiles)
$MainForm.ShowDialog()