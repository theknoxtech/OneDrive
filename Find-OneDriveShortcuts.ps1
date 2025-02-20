# Parameter help description
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