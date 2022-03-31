# Storyline:

# Prerequisites
Set-ExecutionPolicy Bypass -Scope CurrentUser
#ignore red text just says that it will only be set for current shell which is all we want
# To block the user from worrying about this we clear the terminal with the below
cls

# Task 1

# Copy powershell.exe to home directory
Copy-Item -Path "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Destination "C:\Users\chris.mchugh-adm"

# Create a random number to add to the file.
$sbRand = Get-Random -Minimum 1000 -Maximum 9876

# Create the location to save the bot
$newName = "EnNoB-" + $sbRand + ".exe"

# Rename the powershell.exe file 
Rename-Item -Path "C:\Users\chris.mchugh-adm\powershell.exe" -NewName $newName

# Check that the file exists

# If statement checks the return of the command
if (dir -path C:\Users\chris.mchugh-adm\$newName){

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

# Task 2

# Create Readme.READ file
$ransom = "If you want your files restored, please contact me at christopher.mchugh@mymail.champlain.edu. I look forward to doing business with you."

$ransom | Out-File -FilePath C:\Users\chris.mchugh-adm\Readme.READ

# Check that the Readme.READ file exists

if (dir -path C:\Users\chris.mchugh-adm\Readme.READ){

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