<#
.SYNOPSIS

This script will find OneDrive Shortcuts that have been added to OneDrive by using the Add Shortcut to OneDrive from OneDrive in the browser.


.DESCRIPTION

This script recursively goes through the default OneDrive location and checks the desktop.ini file for specific index numbers
These number are associated with OneDrive Shortcuts specifically

Author: Jon Witherspoon
Last Modified: 02/20/25


.PARAMETER SavetoFile
Optional parameter to allow the user to save the output to the current working directory

.INPUTS

None. You cannot pipe objects to this script.


.OUTPUTS
Outputs to the console by default
If Savetofile is used it outputs OneDriveShortcuts.txt to the current working directory


.EXAMPLE
.\Find-OneDriveShortcuts

.EXAMPLE
.\Find-OneDriveShortcuts -Savetofile
#>


param (
    [switch]$SaveToFile
)

# Get Folders in OneDrive
$OneDriveDirs = Get-ChildItem $env:OneDrive -Recurse -Directory

# Array of icon indexes
$indexes = 4,7,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67

$shortcut_folders = @()


foreach ($folder in $OneDriveDirs){
    if (Test-Path $folder\desktop.ini) {
        foreach ($index in $indexes){
            if ((Get-Content $folder\desktop.ini -Force) -match "IconResource=.*OneDrive.exe,$index") {
                $shortcut_folders += $folder
                break
                }

            }
            
        }
    }

# Output
if ($SaveToFile) {
    $shortcut_folders | Out-File -FilePath OneDriveShortcuts.txt
    Write-Host "File Saved to $PWD\OneDriveShortcuts.txt"
} else {
    $shortcut_folders.FullName
}