using namespace System.Windows.Forms
using namespace System.Drawing
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$mainForm = [Form]::new()
$mainForm.AutoSize = $true
$mainForm.StartPosition = "CenterScreen"
$mainForm.Text = "Browse MTP Phone Testing"

$FDialog = [FolderBrowserDialog]::new()
$FDialog.Multiselect = $true
$FDialog.RootFolder = "MyComputer"
$FDialog
$FDialog.ShowDialog()