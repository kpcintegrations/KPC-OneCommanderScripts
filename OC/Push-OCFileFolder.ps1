Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$OCVars = Import-Clixml -Path "$PSScriptRoot\Export\Vars.xml"

$DevicesAvaialable = Get-Content -Path "$PSScriptRoot\adbdevices.txt"

$MainForm = New-Object System.Windows.Forms.Form
$MainForm.StartPosition = "CenterScreen"
$MainForm.Size = New-Object System.Drawing.Size(600,400)
$MainForm.Name = "Test"

$MainLabel = New-Object System.Windows.Forms.Label
$MainLabel.Location = New-Object System.Drawing.Point(100,25)
$MainLabel.Size = New-Object System.Drawing.Size(400,25)
$MainLabel.Text = "Select Device To Push To, And Select Folder To Push"
$MainForm.Controls.Add($MainLabel)

$SelectionBox = New-Object System.Windows.Forms.ListBox
$SelectionBox.Size = New-Object System.Drawing.Size(400,150)
$SelectionBox.Location = New-Object System.Drawing.Point(100,50)
$DevicesAvaialable | ForEach-Object {
    $SelectionBox.Items.Add($_.Replace(" ",""))
}
$MainForm.Controls.Add($SelectionBox)

$TextBoxForFolder = New-Object System.Windows.Forms.TextBox
$TextBoxForFolder.Size = New-Object System.Drawing.Size(400,25)
$TextBoxForFolder.Location = New-Object System.Drawing.Point(100,225)
$MainForm.Controls.Add($TextBoxForFolder)

$OkButton = New-Object System.Windows.Forms.Button
$OkButton.Text = "Select"
$OkButton.Location = New-Object System.Drawing.Point(150,300)
$OkButton.Size = New-Object System.Drawing.Size(100,50)
$OkButton.DialogResult = [System.Windows.Forms.DialogResult]::OK

$CanButton = New-Object System.Windows.Forms.Button
$CanButton.Text = "Cancel"
$CanButton.Location = New-Object System.Drawing.Point(300,300)
$CanButton.Size = New-Object System.Drawing.Size(100,50)
$CanButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

$SelButton = New-Object System.Windows.Forms.Button
$SelButton.Text = "Select Folder"
$SelButton.Location = New-Object System.Drawing.Point(450,300)
$SelButton.Size = New-Object System.Drawing.Size(100,50)
$SelButton.Add_Click($openFolderDialog)
$MainForm.Controls.Add($SelButton)

$MainForm.Controls.Add($OkButton)
$MainForm.Controls.Add($CanButton)

$openFolderDialog = {
    $FolderDialog = New-Object System.Windows.Forms.OpenFileDialog
    $FolderDialog.ShowDialog()
    $TextBoxForFolder.Text = $FolderDialog.FileName
}

$result = $MainForm.ShowDialog()

$Device = ""
$FolderSelection = ""

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $Device = $SelectionBox.SelectedItem
    $FolderSelection = $TextBoxForFolder.Text
}
. "$PSScriptRoot\platform-tools\adb.exe" -s $Device push $FolderSelection '/sdcard/Download'