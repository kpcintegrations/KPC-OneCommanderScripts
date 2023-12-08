using namespace System.Windows.Forms
using namespace System.Drawing

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$OCVars = Import-Clixml -Path "$PSScriptRoot\Export\Vars.xml"
$CurDir = $OCVars.CurrentDir
$OpDir = $OCVars.OpDir
$SelectedItems = $OCVars.SelectedFiles

$DefaultFont =  [FontDialog]::new()
$DefaultFont.ShowDialog()

$Global:CurFolPath = "/sdcard/"
$adbInitFolders = & "$PSScriptRoot\Tools\adb.exe" "shell" "ls" "$($Global:CurFolPath)"

$form = [Form]::new()
$form.Size = [Size]::new(1000,900)
$form.BackColor = [Color]::White
$form.StartPosition = [FormStartPosition]::CenterScreen
$form.Font = $DefaultFont.Font

$page1MenuButton1Image = [Image]::FromFile("$PSScriptRoot\Assests\uparrow.png")
$page1MenuButton2Image = [Image]::FromFile("$PSScriptRoot\Assests\checkbox.png")

$page1MenuButton1 = [Button]::new()
$page1MenuButton1.Size = [Size]::new(50,50)
$page1MenuButton1.Image = $page1MenuButton1Image

$page1MenuButton2 = [Button]::new()
$page1MenuButton2.Size = [Size]::new(50,50)
$page1MenuButton2.Location = [Point]::new(50,0)
$page1MenuButton2.Image = $page1MenuButton2Image

$page1Panel = [Panel]::new()
$page1Panel.Dock = [DockStyle]::Fill

$page2Panel = [Panel]::new()
$page2Panel.Dock = [DockStyle]::Fill

$page3Panel = [Panel]::new()
$page3Panel.Dock = [DockStyle]::Fill

$page1MenuPanel = [Panel]::new()
$page1MenuPanel.Dock = "Top"
$page1MenuPanel.Height = 50
$page1MenuPanel.BackColor = [Color]::Black
$page1MenuPanel.Padding = [Padding]::new(0)
$page1MenuPanel.Margin = [Padding]::new(0)
$page1MenuPanel.Controls.Add($page1MenuButton1)
$page1MenuPanel.Controls.Add($page1MenuButton2)


$lvImageList = [ImageList]::new()
$lvImageList.Images.Add([Image]::FromFile("$PSScriptRoot\Assests\folder.png"))
$lvImageList.Images.Add([Image]::FromFile("$PSScriptRoot\Assests\file.png"))
$lvImageList.ImageSize = [Size]::new(50,50)

$listView = [ListView]::new()
$listView.BorderStyle = [BorderStyle]::None
$listView.Dock = [DockStyle]::Fill
$listView.View = [View]::LargeIcon
$listView.BackColor = [Color]::Black
$listView.ForeColor = [Color]::White
$listView.LargeImageList = $lvImageList
foreach ($Item in $adbInitFolders) {
    $listView.Items.Add($Item,0)
}

$listView.Add_DoubleClick({
    Write-Host "In The DoubleClick"
    Write-Host "$($listView.SelectedItems[0].Text)"
    $Folder = $listView.SelectedItems[0].Text
    $Global:CurFolPath = $Global:CurFolPath + $Folder + "/"
    $Items = adb shell ls $Global:CurFolPath
    $listView.Clear()
    foreach ($Item in $Items) {
        if (!($Item -like "*.*")) {
        $ListItem = [ListViewItem]::new($Item, 0)
        $listView.Items.Add($ListItem)
        }
    
    else {
        $ListItem = [ListViewItem]::new($Item, 1)
        $listView.Items.Add($ListItem)
    }
}
    $listView.Refresh()
}
)

$listViewWrapperPanel = [Panel]::new()
$listViewWrapperPanel.Location = [Point]::new(50,50)
$listViewWrapperPanel.Dock = "Fill"
$listViewWrapperPanel.Padding = [Padding]::new(0)
$listViewWrapperPanel.Controls.Add($listView)

$mainMenuButton1 = [Button]::new()
$mainMenuButton1.MinimumSize = [Size]::new(200,50)
$mainMenuButton1.Text = "Browse Phone"

$mainMenuButton2 = [Button]::new()
$mainMenuButton2.MinimumSize = [Size]::new(200,50)
$mainMenuButton2.Location = [Point]::new(0,50)
$mainMenuButton2.Text = "Install Apk(s)"

$mainMenuButton3 = [Button]::new()
$mainMenuButton3.MinimumSize = [Size]::new(200,50)
$mainMenuButton3.Location = [Point]::new(0,100)
$mainMenuButton3.Text = "Get Apk Common Names"

$mainMenu = [Panel]::new()
$mainMenu.Margin = [Padding]::new(0,0,5,0)
$mainMenu.Dock = "Left"
$mainMenu.BackColor = [Color]::Black
$mainMenu.ForeColor = [Color]::White
$mainMenu.Controls.Add($mainMenuButton1)
$mainMenu.Controls.Add($mainMenuButton2)
$mainMenu.Controls.Add($mainMenuButton3)

$page1BottomButton1 = [Button]::new()
$page1BottomButton1.Dock = "Top"
$page1BottomButton1.Text = "Select Folder To Transfer Files To"

$page1BottomButton2 = [Button]::new()
$page1BottomButton2.Dock = "top"
$page1BottomButton2.Text = "Transfer To Current Directory"

$page1BottomButton3 = [Button]::new()
$page1BottomButton3.Dock = "Top"
$page1BottomButton3.Text = "Transfer To Opposite Directory"

$page1BottomButton4 = [Button]::new()
$page1BottomButton4.Dock = "Top"
$page1BottomButton4.Text = "Transfer Selected Files To Open Phone Directory"

$page1BottomButton1.Add_Click(
    {
        $fbd = [FolderBrowserDialog]::new()
        $fbd.ShowDialog()
        Start-Sleep -Milliseconds 50
        $listView.SelectedItems.Text | ForEach-Object -Process {
            if ($_ -like "*.*") {
              & "$PSScriptRoot\Tools\adb.exe" pull ($Global:CurFolPath + $_) $fbd.SelectedPath
            }
            else {
                & "$PSScriptRoot\Tools\adb.exe" pull ($Global:CurFolPath + $_ + "/") $fbd.SelectedPath
            }
        }
        Start-Sleep -Milliseconds 50
            [MessageBox]::Show("All Files Have Transfered Successfully","Sucess!","Ok")
    }
)

$page1BottomButton2.Add_Click(
    {
        $listView.SelectedItems.Text | ForEach-Object -Process {
            if ($_ -like "*.*") {
              & "$PSScriptRoot\Tools\adb.exe" pull ($Global:CurFolPath + $_) $CurDir
            }
            else {
                & "$PSScriptRoot\Tools\adb.exe" pull ($Global:CurFolPath + $_ + "/") $CurDir
            }
        }
        Start-Sleep -Milliseconds 50
            [MessageBox]::Show("All Files Have Transfered Successfully","Sucess!","Ok")
    }
)

$page1BottomButton3.Add_Click(
    {
        $listView.SelectedItems.Text | ForEach-Object -Process {
            if ($_ -like "*.*") {
              & "$PSScriptRoot\Tools\adb.exe" pull ($Global:CurFolPath + $_) $OpDir
            }
            else {
                & "$PSScriptRoot\Tools\adb.exe" pull ($Global:CurFolPath + $_ + "/") $OpDir
            }
        }
        Start-Sleep -Milliseconds 50
            [MessageBox]::Show("All Files Have Transfered Successfully","Sucess!","Ok")
    }
)

$page1BottomButton4.Add_Click(
    {
        $SelectedItems | ForEach-Object -Process {
            & "$PSScriptRoot\Tools\adb.exe" push $_ ($Global:CurFolPath + $_ + "/")
            }
        Start-Sleep -Milliseconds 50
            [MessageBox]::Show("All Files Have Transfered Successfully","Sucess!","Ok")
    }
)


$page1BottomPanel = [Panel]::new()
$page1BottomPanel.Dock = "Bottom"
$page1BottomPanel.AutoSize = $true
$page1BottomPanel.Controls.Add($page1BottomButton1)
$page1BottomPanel.Controls.Add($page1BottomButton2)
$page1BottomPanel.Controls.Add($page1BottomButton3)
$page1BottomPanel.Controls.Add($page1BottomButton4)


$page1Panel.Controls.Add($listViewWrapperPanel)
$page1Panel.Controls.Add($page1MenuPanel)
$page1Panel.Controls.Add($page1BottomPanel)


$page2Button1 = [Button]::new()
$page2Button1.AutoSize = $true
$page2Button1.Dock = "Top"
$page2Button1.Text = "Select Apke(s) To Install"

$page2BottomPanelButton = [Button]::new()
$page2BottomPanelButton.AutoSize = $true
$page2BottomPanelButton.Dock = "Fill"
$page2BottomPanelButton.Text = "Install Apk(s) To Connected Phone"

$page2BottomPanel = [Panel]::new()
$page2BottomPanel.Dock = "Bottom"
$page2BottomPanel.Height = 100
$page2BottomPanel.Controls.Add($page2BottomPanelButton)


$page2ListBoxSelectedFiles = [listbox]::new()
$page2ListBoxSelectedFiles.Dock = "Fill"
$page2ListBoxSelectedFiles.Top = 50
$page2ListBoxSelectedFiles.HorizontalScrollbar = $true
$page2ListBoxSelectedFiles.Height = 700

$page2FileSelectDialog = [OpenFileDialog]::new()
$page2FileSelectDialog.Multiselect = $true


$page2Panel.Controls.Add($page2ListBoxSelectedFiles)
$page2Panel.Controls.Add($page2Button1)
$page2Panel.Controls.Add($page2BottomPanel)



$page1MenuButton1.Add_Click(
    {
            $Global:PrePath = $Global:CurFolPath
            if ($Global:PrePath -ne "/sdcard/") {
            $TempList = $Global:PrePath | Split-String -Separator "/" -RemoveEmptyStrings
            $RepText = $TempList[-1]
            $Global:PrePath = ($Global:PrePath).Replace("$RepText/","")
            $Items = & "$PSScriptRoot\Tools\adb.exe" "shell" "ls" "$($Global:PrePath)"
            $Global:CurFolPath = $Global:PrePath
            $ListView.Clear()
            foreach ($Item in $Items) {
                if (!($Item -like "*.*")) {
                    $ListItem = [ListViewItem]::new($Item, 0)
                    $listView.Items.Add($ListItem)
                    }
                
                else {
                    $ListItem = [ListViewItem]::new($Item, 1)
                    $listView.Items.Add($ListItem)
                }
            }
            $ListView.Refresh()
        }
            else {
                [MessageBox]::Show("You are already at top level!","No Further To Go!",[MessageBoxButtons]::OK)
            }
    }
)

$page1MenuButton2.Add_Click(
    {
        if ($listView.CheckBoxes -eq $true){
            $listView.CheckBoxes = $false
        }
        else {
            $listView.CheckBoxes = $true
        }
    }
)

$page2Button1.Add_Click(
    {
        $results = $page2FileSelectDialog.ShowDialog()
        if ($results -eq "OK") {
            Write-Host "We're In!"
        $page2ListBoxSelectedFiles.Items.Clear()
        Start-Sleep -Milliseconds 50
        foreach ($File in $page2FileSelectDialog.FileNames) {
            $page2ListBoxSelectedFiles.Items.Add(($File))
        }
    }
    else {
        Write-Host "Dialog Canceled"
    }

    }
)

$page2BottomPanelButton.Add_Click(
    {
        foreach ($FileName in $page2FileSelectDialog.FileNames) {
            & "$PSScriptRoot\Tools\adb.exe" install $FileName
        }
        [MessageBox]::Show("Apk(s) Sucessfully Installed","Sucess!","Ok")
        $page2ListBoxSelectedFiles.Items.Clear()
    }
)

$mainMenuButton1.Add_Click(
    {
        $form.Controls.Clear()
        Start-Sleep -Milliseconds 50
        $form.Controls.Add($page1Panel)
        $form.Controls.Add($mainMenu)
    }
)

$mainMenuButton2.Add_Click(
    {
        $form.Controls.Clear()
        Start-Sleep -Milliseconds 50
        $form.Controls.Add($page2Panel)
        $form.Controls.Add($mainMenu)
    }
)

$form.Controls.Add($page1Panel)
$form.Controls.Add($mainMenu)

$form.ShowDialog()