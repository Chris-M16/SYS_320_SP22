cls
# Login to a remote SSH server
#New-SSHSession -AcceptKey -ComputerName '192.168.6.71' -Credential (Get-Credential christopher.mchugh) -Port 2222

# Get-SSHSession = check ssh sessions shows if connected
<#
while ($true) {

    # Add a prompt to run commands
    $the_cmd = Read-Host -Prompt "Please enter a command"


    # Run comand on remote SSH server
    (Invoke-SSHCommand -index 0 $the_cmd).Output

}
#>

# Send file from my computer to remote computer
Set-SCPItem -Computername '192.168.6.71' -Port 2222 -Credential (Get-Credential christopher.mchugh) `
-Path 'C:\Users\chris.mchugh-adm\Desktop\scripting\SYS_320_SP22\Week11\class\idk.txt' -Destination '/home/christopher.mchugh'