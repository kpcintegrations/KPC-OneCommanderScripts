# KPC-OneCommanderScripts
A collection of scripts for the alternative file manager OneCommander. Offers various features such as executing powershell scripts or batach files in an interactive prompt so that errors and messages can be seen, rather than the default of a hidden or auto closing Windows Powershell instance. Open current dir in any installed shell that is selected via a gui. Android functionality like pulling or pushing files via adb
# Installation Instructions
1. Clone the repository to any location
2. Run the Install.ps1 for a first time Installation and wait for the script to finish. This will create a KPC folder in the Scripts Folder with the Initial Scripts you will see in OC's script menu. It will also create a folder name KPC in the Resources OC folder with additional scripts that are invoked by the OC script menu scripts. This is due to limitations with how scripting is implemented in OC.
3. Run the Update.ps1 for when you want to update the scripts. Note: You will have to delete and reclone this repository before running Update.ps1. What this avoids is creating duplicate entries in your powershell profile file.
4. That's it, I'll be implementing gui's for most complex tasks but easy task will be done using the currently selected files and current/opposite dirs open.
# Support
If you have questions or would like to contribute to this script pack email me at admin@kpcintegrations.com and I will respond as soon as I have time.
