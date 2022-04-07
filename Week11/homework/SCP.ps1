# Send file from my computer to remote computer
Set-SCPItem -Computername '192.168.6.71' -Port 2222 -Credential (Get-Credential christopher.mchugh) `
-Path 'C:\Users\chris.mchugh-adm\Desktop\scripting\SYS_320_SP22\Week11\homework\Windows-Firewall.ps1' -Destination '/home/christopher.mchugh'