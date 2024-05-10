#Usings and Types For Forms
using namespace System.Windows.Forms
using namespace System.Drawing

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Code to return Serial Number of selected Device!
#-----------------------------------------------
function Get-ADBDevice {
#Calculations
$ADBDevices = . adb devices
$ADBDevicesParse = $ADBDevices | Select-Object -Skip 1 -SkipLast 1

#Main Form Box
$PhoneSelForm = [Form]::new()

$PhoneSelForm.AutoSize = $true
$PhoneSelForm.StartPosition = [FormStartPosition]::CenterScreen
$PhoneSelForm.BackColor = [Color]::Black
$PhoneSelForm.ForeColor = [Color]::White
$PhoneSelForm.Padding = 25
$PhoneSelForm.Text = "Select An ADB Device!"

#Label For Phone Serials
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Select One Device's Serial Number, or Network Address:Port and Select Okay"
$Label.Dock = "Top"
$Label.Height = 50

#ListBox For ADB Results
$Listbox = [ListBox]::new()
foreach ($Device in $ADBDevicesParse){
        $DeviceParse = $Device -split "device"
        $DeviceParseParse = $DeviceParse[0].Trim()
$Listbox.Items.Add($DeviceParseParse) | Out-Null
}
$Listbox.Dock = "Top"
$Listbox.SelectionMode = "One"

$OkButtonSB = {
    $PhoneSelForm.Close() | Out-Null
    
}

#OkButton
$OkButton = New-Object Button
$OkButton.Text = "Ok!"
$OkButton.BackColor = [Color]::Red
$OkButton.Add_Click($OkButtonSB)
$OkButton.Dock = "Bottom"
$PhoneSelForm.AcceptButton = $OkButton

#Adding up Controls
$PhoneSelForm.Controls.Add($Listbox)
$PhoneSelForm.Controls.Add($Label)
$PhoneSelForm.Controls.Add($OkButton)
$PhoneSelForm.ShowDialog() | Out-Null

#Returning SN from function...
return $Listbox.SelectedItem
}