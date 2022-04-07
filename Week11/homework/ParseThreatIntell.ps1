# Array of websites containing threat intell
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

# Loop through the URLs for the rules list
foreach ($u in $drop_urls) {

    # Extract the filename
    $temp = $u.split("/")
    
    # The last element in the array plucked off is the filename
    $file_name = 'C:\Users\chris.mchugh-adm\Desktop\scripting\SYS_320_SP22\Week11\homework\'+$temp[-1]

    if (Test-Path $file_name) {

        Continue
    } else {
        # Download the rules list
        Invoke-WebRequest -Uri $u -OutFile $file_name

    } # close if statement

} # closes foreach

# Array containing the filename
$input_paths = @('C:\Users\chris.mchugh-adm\Desktop\scripting\SYS_320_SP22\Week11\homework\compromised-ips.txt','C:\Users\chris.mchugh-adm\Desktop\scripting\SYS_320_SP22\Week11\homework\emerging-botcc.rules')

# Extract the IP addresses.
#108.191.2.72
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'


# Append the IP addresses to the temporary IP list
select-string -Path $input_paths -Pattern $regex_drop | `
ForEach-Object { $_.Matches } | `
ForEach-Object { $_.Value } | Sort-Object | Get-Unique | `
Out-File -FilePath "C:\Users\chris.mchugh-adm\Desktop\scripting\SYS_320_SP22\Week11\homework\ips-bad.tmp"

# User input for Windows Firewall or IPTables
$var = Read-Host -Prompt "Please enter Windows or IPTables"

switch ( $var ) {
    # Get the IP addresses discovered, loop through and replace the beginning of the line with the IPTables syntax
    # After the IP address, add the remaining IPTables syntax and save the results to a file.
    # iptables -A INPUT -s 108.191.2.72 -j DROP
    IPTables { $result = (Get-Content -Path "C:\Users\chris.mchugh-adm\Desktop\scripting\SYS_320_SP22\Week11\homework\ips-bad.tmp") | % `
    { $_ -replace "^","iptables -A INPUT -s " -replace "$", " -j DROP" } | `
    Out-File -FilePath "C:\Users\chris.mchugh-adm\Desktop\scripting\SYS_320_SP22\Week11\homework\iptables.bash"}


    # Do the same as above but for Windws Firewall Rule
    Windows { $result = (Get-Content -Path "C:\Users\chris.mchugh-adm\Desktop\scripting\SYS_320_SP22\Week11\homework\ips-bad.tmp") | % `
    { $_ -replace "^",'New-NetFirewallRule -DisplayName "BLACKLIST" -Direction inbound -Profile Any -Action Block -RemoteAddress ' } | `
    Out-File -FilePath "C:\Users\chris.mchugh-adm\Desktop\scripting\SYS_320_SP22\Week11\homework\Windows-Firewall.ps1"}

}
$result
