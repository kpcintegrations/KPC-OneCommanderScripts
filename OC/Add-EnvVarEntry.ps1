Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


$MainForm = New-Object System.Windows.Forms.Form
$MainForm.Size = New-Object System.Drawing.Size(500,350)
$Label1 = New-Object System.Windows.Forms.Label
$Label1.Text = "Enter ENV Var Name"
$Label1.Size = New-Object System.Drawing.Size(300,25)
$Label1.Location = System.Drawing.Size(100,0)
$Input1 = New-Object System.Windows.Forms.TextBox
$Input1.Size = New-Object System.Drawing.Size(300,25)
$Input1.Location = New-Object System.Drawing.Size(100,25)
$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = "Enter ENV Var Value"
$Label2.Size = New-Object System.Drawing.Size(300,25)
$Label2.Location = System.Drawing.Size(100,50)
$Input2 = New-Object System.Windows.Forms.TextBox
$Input2.Size = New-Object System.Drawing.Size(300,25)
$Input2.Location = New-Object System.Drawing.Size(100,75)
$Button = New-Object System.Windows.Forms.Button
$Button.Size = New-Object System.Drawing.Size(200,50)
$Button.Location = New-Object System.Drawing.Size(150,100)
$MainForm.Controls.Add($Label1)
$MainForm.Controls.Add($Input1)
$MainForm.Controls.Add($Label2)
$MainForm.Controls.Add($Input2)
$MainForm.Controls.Add($Button)
$Button.add_Click($OCSB)
$OCSB = { [System.Environment]::GetEnvironmentVariable($Input1.Text)
$CurEnvVarArray = $OCSB | Split-String -Separator ';' -RemoveEmptyStrings
if ($CurEnvVarArray.Count -gt 1){
$CurEnvVarArray.Add("`;$Input2.Text")
[System.Environment]::SetEnvironmentVariable("$Input1.Text",$CurEnvVarArray,'Machine')
}
else {
    [System.Environment]::SetEnvironmentVariable($Input1.Text,$Input2.Text,'Machine')
}