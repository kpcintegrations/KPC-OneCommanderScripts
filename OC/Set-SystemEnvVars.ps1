Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$SysEnvVars = [System.Environment]::GetEnvironmentVariables([System.EnvironmentVariableTarget]::Machine).GetEnumerator() | Sort-Object Key
$SysVarsKeysList = $SysEnvVars.Key



$MainForm = New-Object System.Windows.Forms.Form
$MainForm.Size = New-Object System.Drawing.Size(500,850)
$MainForm.StartPosition = "CenterScreen"
$Label1 = New-Object System.Windows.Forms.Label
$Label1.Text = "Select System Environment Variable To Edit"
$Label1.Size = New-Object System.Drawing.Size(400,25)
$Label1.Location = New-Object System.Drawing.Size(50,0)
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Size = New-Object System.Drawing.Size(400,350)
$listBox.Location = New-Object System.Drawing.Size(50,25)
$SetCurVarText = {
    $CurrentValue.Text = [System.Environment]::GetEnvironmentVariable($listBox.SelectedItem)
}
$listBox.Add_Click($SetCurVarText)
$SysVarsKeysList | ForEach-Object -Process {
    $listBox.Items.Add($_)
}
$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = "Current Variable Value"
$Label2.Size = New-Object System.Drawing.Size(400,25)
$Label2.Location = New-Object System.Drawing.Size(50,375)
$CurrentValue = New-Object System.Windows.Forms.TextBox
$CurrentValue.Size = New-Object System.Drawing.Size(450,100)
$CurrentValue.Location = New-Object System.Drawing.Size(25,400)
$Label3 = New-Object System.Windows.Forms.Label
$Label3.Text = "Enter New Variable Value (Will Overwrite, Not Append)"
$Label3.Size = New-Object System.Drawing.Size(400,25)
$Label3.Location = New-Object System.Drawing.Size(50,500)
$NewValue = New-Object System.Windows.Forms.TextBox
$NewValue.Size = New-Object System.Drawing.Size(450,100)
$NewValue.Location = New-Object System.Drawing.Size(25,525)
$Button = New-Object System.Windows.Forms.Button
$Button.Size = New-Object System.Drawing.Size(200,50)
$Button.Location = New-Object System.Drawing.Size(150,625)
$Button.Text = "Update Variable"
$MainForm.Controls.Add($Label1)
$MainForm.Controls.Add($listBox)
$MainForm.Controls.Add($Label2)
$MainForm.Controls.Add($CurrentValue)
$MainForm.Controls.Add($Label3)
$MainForm.Controls.Add($NewValue)
$MainForm.Controls.Add($Button)
$UpdateVarScript = {
    [System.Environment]::SetEnvironmentVariable($listBox.SelectedItem,$NewValue.Text,"Machine")
    $MainForm.Close()
}
$Button.add_Click($UpdateVarScript)

$MainForm.ShowDialog()