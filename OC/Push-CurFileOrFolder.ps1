Add-Type -AssemblyName System.Windows.Forms

$OCVars = Import-Clixml -Path "$PSScriptRoot\Export\Vars.xml"

$DevicesAvaialable = Get-Content -Path "$PSScriptRoot\adbdevices.txt"

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

$InputTextBox.add_SelectedIndexChanged($SelectedDevice)
$SelectedDevice = {
    . "$PSScriptRoot\platform-tools\adb.exe" -s $InputTextBox.SelectedItem shell ls /sdcard/ |
        ForEach-Object { $InputTextBox2.Items.Add($_) }
    $InputTextBox2.Refresh()
}
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

$PushButton = New-Object System.Windows.Forms.Button
$PushButton.Text = "Push"
$PushButton.Size = New-Object System.Drawing.Size(100,50)
$PushButton.Location = New-Object System.Drawing.Size(200,500)
$MainForm.Controls.Add($PushButton)

$PushButton.Add_Click($PushTheFiles)
if ($OCVars.SelectedFiles -ne "") {
    $PushTheFiles = {
        $OCVars.SelectedFiles | ForEach-Object {
        . "$PSScriptRoot\platform-tools\adb.exe" -s $InputTextBox.SelectedItem push $_ $InputTextBox2.SelectedItem
    }
}
}
else {
$PushTheFiles = {
    . "$PSScriptRoot\platform-tools\adb.exe" -s $InputTextBox.SelectedItem push $OCVars.CurrentDir $InputTextBox2.SelectedItem
}
}

$MainForm.ShowDialog()