Add-Type -AssemblyName System.Windows.Forms
Add-type -AssemblyName System.Drawing
powershell.exe -NoProfile -File "$PSScriptRoot\Get-CurrentClipBoardHistory.ps1"
$ClipHistList = Import-Clixml -Path "$PSScriptRoot\Export\ClipHist.xml"
$OCVars = Import-Clixml -Path "$PSScriptRoot\Export\Vars.xml"
$SelectedFile = $OCVars.SelectedFiles
$ClipHistForm = New-Object System.Windows.Forms.Form
$ClipHistForm.AutoSize = $true
$ClipHistForm.StartPosition = "CenterScreen"
$ClipHistForm.Margin = 50

$ListBox = New-Object System.Windows.Forms.ListBox
$ListBox.Size = New-Object System.Drawing.Size(800,800)
foreach ($ClipItem in $ClipHistList) {
    if ($null -ne $ClipItem -and $ClipItem -ne "") {
        if ($ClipItem.Length -gt 800) {
        $ListBox.Items.Add(("$($ClipItem.Substring(0,100))" + "..."))
        }
        else { 
            $ListBox.Items.Add($ClipItem)
        }
    }
}

$PasteButton = New-Object System.Windows.Forms.Button
$PasteButton.Text = "Paste!"
$PasteButton.Size = New-Object System.Drawing.Size(100,50)
$PasteButton.Location= New-Object System.Drawing.Size(300,900)
$PBSB = {
    $SelectedClipHistItem = $ListBox.SelectedItem.ToString()
    $OCSP = Start-Process -PassThru -FilePath (Get-Command OneCommander).Path -ArgumentList "-filePath $SelectedFile"
    $OCPID = $OCSP.MainWindowHandle
    $wshell = New-Object -ComObject wscript.shell;
    $wshell.AppActivate("$OCPID")
    Start-Sleep 1
    $wshell.SendKeys("{F2}")
    Start-Sleep 1
    $wshell.SendKeys("$SelectedClipHistItem")
    $ClipHistForm.Close()

}
$PasteButton.Add_Click($PBSB)


$ClipHistForm.Controls.Add($ListBox)
$ClipHistForm.Controls.Add($PasteButton)

$ClipHistForm.ShowDialog()
