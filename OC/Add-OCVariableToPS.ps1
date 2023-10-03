Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$OCVars = Import-Clixml -Path ($PSScriptRoot + "\Export\Vars.xml")
$CurrentDir = $OCVars.CurrentDir
if (Test-Path -Path (Join-Path $PSScriptRoot "\Export\CusPSVars.xml")) {
$VarHash = Import-Clixml -Path (Join-Path $PSScriptRoot "\Export\CusPSVars.xml")
}
else {
    $example = (New-Object System.Collections.Generic.Dictionary("ExampleVarPath","C:\Windows\System32\drivers\etc\"))
    $VarHash = $example | Export-Clixml -Path (Join-Path $PSScriptRoot "\Export\CusPSVars.xml") -Force
}

$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Size = New-Object System.Drawing.Size(500,200)
$mainForm.StartPosition = "CenterScreen"

$label =  New-Object System.Windows.Forms.Label
$label.Size =  New-Object System.Drawing.Size(500,25)
$label.Location =  New-Object System.Drawing.Size(0,0)
$label.Text = "Enter Variable Name Without Preceding '$'"

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Size = New-Object System.Drawing.Size(400,25)
$textBox.Location = New-Object System.Drawing.Size(50,50)
$textBox.PlaceholderText = "Name Goes Here Then Click Ok Button"

$okButton = New-Object System.Windows.Forms.Button
$okButton.Size = New-Object System.Drawing.Size(100,50)
$okButton.Location = New-Object System.Drawing.Size(200,100)
$okButton.Text = "OK"

$mainForm.Controls.Add($label)
$mainForm.Controls.Add($textBox)
$mainForm.Controls.Add($okButton)

New-Variable -Name "DirName" -Value "" -Scope "Global"

$ButtonClickScript = {
    if ($textBox.Text -ne "") {
        Set-Variable -Name "DirName" -Scope "Global" -Value $textBox.Text
    }
    else {
            Set-Variable -Name "DirName" -Scope "Global" -Value ((Get-Item -Path $CurrentDir).Name)
        }
try {
        $VarHash.Add($DirName,$CurrentDir)
}
catch [ArgumentException] {
    $ButtonType = [System.Windows.Forms.MessageBoxButtons]::YesNo

$MessageIcon = [System.Windows.Forms.MessageBoxIcon]::Warning

$MessageBody = "A Varible With That Name Already Exists. Do You Wish To Overwrite It? (Be careful with accidentally overwriting built-in variables.)"

$MessageTitle = "Duplicate Variable Name Detected"

$Result = [System.Windows.Forms.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)

if ($Result -eq "Yes") {
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

$okButton.add_Click($ButtonClickScript)

$mainForm.ShowDialog()