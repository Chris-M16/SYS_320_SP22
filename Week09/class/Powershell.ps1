# Get a list of running processes

# Get list of members
#Get-Process | get-member

# Get a list of processes: name, id, path
#Get-Process | Select-Object ProcessName, ID, Path

# Save the output to a CSV file
#Get-Process | Select-Object ProcessName, ID, Path | Export-Csv -Path `
#"C:\Users\chris.mchugh-adm\Desktop\processes.csv"


$outputName = "C:\Users\chris.mchugh-adm\Desktop\RunningServices.csv"

# System Services and properties
#Get-Service | Get-Member

# BinaryPathName was not there for me
#Get-Service | Select-Object Status, Name, DisplayName, BinaryPathName | Export-Csv -Path `
#$outputName

# Get a list of running services
Get-Service | Where-Object { $_.Status -eq "Running" } | Select-Object Name, DisplayName, BinaryPathName | Export-Csv -Path `
$outputName

# Check to see if file exists
if ( Test-Path $outputName ) {

    Write-Host -BackgroundColor "Green" -ForegroundColor "White" "Services File was created!"
} else {

    Write-Host -BackgroundColor "Red" -ForegroundColor "White" "Services File was NOT created!"
}