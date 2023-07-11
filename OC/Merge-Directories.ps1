Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$VarClixml = Import-Clixml -Path "$PSScriptRoot\Export\Vars.xml"
$CurDir = $VarClixml["CurrentDir"]
$OpDir = $VarClixml["OppositeDir"]


$MainForm = New-Object System.Windows.Forms.Form
$MainForm.Size = New-Object System.Drawing.Size(500,300)

$Label = New-Object System.Windows.Forms.Label
$Label.Size = New-Object System.Drawing.Size(300,25)
$Label.Location = New-Object System.Drawing.Size(100,0)
$Label.Text = "Enter A Folder Path To Merge Directories To"

$TextBox = New-Object System.Windows.Forms.TextBox
$TextBox.Size = New-Object System.Drawing.Size(300,50)
$TextBox.Location = New-Object System.Drawing.Size(100,25)

$Button = New-Object System.Windows.Forms.Button
$Button.Size = New-Object System.Drawing.Size(100,50)
$Button.Location = New-Object System.Drawing.Size(200,100)
$DoItNow = {
    $Folder = $TextBox.Text
    if (Test-Path $Folder) {
    Copy-Item -Path (Join-Path $CurDir *) -Destination $Folder -Recurse
Copy-Item -Path (Join-Path $OpDir *) -Destination $Folder -Recurse}
else {
    
}
}
$Button.add_Click($DoItNow)
$MainForm.Controls.Add($Label)
$MainForm.Controls.Add($TextBox)
$MainForm.Controls.Add($Button)
$MainForm.ShowDialog()

