# KPC-OneCommanderScripts
A collection of scripts for the alternative file manager OneCommander. Offers various features such as executing powershell scripts or batach files in an interactive prompt so that errors and messages can be seen, rather than the default of a hidden or auto closing Windows Powershell instance. Open current dir in any installed shell that is selected via a gui. Android functionality like pulling or pushing files via adb
# Installation Instructions
1. Clone the repository to any location
2. Make Sure OneCommander is running.
3. Run the Install.ps1 for a first time Installation and wait for the script to finish. This will create a KPC folder in the Scripts Folder with the Initial Scripts you will see in OC's script menu. It will also create a folder name KPC in the Resources OC folder with additional scripts that are invoked by the OC script menu scripts. This is due to limitations with how scripting is implemented in OC. I updated the Install.ps1 script to check to see if this repo is already installed, so when updating just run Install.ps1 again.
4. That's it, I'll be implementing gui's for most complex tasks but easy task will be done using the currently selected files and current/opposite dirs open.
# Features
-ADB Scripts:
  -Phone GUI - This lets you browse an mtp device like an android phone and do various things with it. You must have the phone connected to the computer and turn on usb debuggging under developer tools. If you don't know what that means you probably don't need this or should do some Googling first.
    1. Makeshift File Browser & Features - I made a gui to browse main storage on android and select one or multiple files. You can then transfer the selected phone files to the current directory, the opposite pane directory, or a custom folder through a folder picking dialog.
    2. Install And Apk - With this tool you can install apks from your computer directly to your phone with adb's aideloading capabilities
    3. Get Apk And Common Names - As far as I know this tool is the only one for windows that will get the common names of apps OneCommander next to the packagename like com.onecommander.com. You can then select as many packages and hit okay and the following can be done. Uninstall selected programs, clear cached for selected programs, clear data for selected program
-Environment Variable Scripts:
  -Add Current Path To User Environment Path Variable - This one is useful for when you use a lot of portable packages to add custom paths to the PATH USER Environment. Add the active pane's path to the USER PATH environment variable.
-PowerShell Scripts:
  -Add Custom PowerShell Var Containing Current OC Directory - Add's a custom variable that's loaded via the powershell profile at each start letting you save the current path to a customly named var that be accessed with a $ infront of what you named the variable. "cd $NamedVar" for example.
  -List and Remove Custom Powershell Vars - A way to organize and remove customly set var's from this script pack. Might have to restart shell for it to reset the variables. 
-Terminal Scripts:
  -Execute .bat or .cmd file interactively - This will attempt to open the selected batch or cmd file in windows terminal under the command prompt profile
  -Execute .ps1 interactively - Let's you select a .ps1 file and run this script to start it in an interactive pwsh prompt.
  -Open All Terminals Here - Get's a list of installed shells from Windows Terminal and then lets you select and launch that shell in the current directory in the active pane.
# Support
- If you have questions or would like to contribute to this script pack email me at admin@kpcintegrations.com and I will respond as soon as I have time.
- Any bugs can be reported on the OC google group, or added as an issue to this repo!
