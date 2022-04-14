# Create commandline parameters to copy a file and place into an evidence directory
param(

    [Parameter(Mandatory = $true)]
    [int]$reportNo,

    [Parameter(Mandatory = $true)]
    [string]$filepath

)

# Create a directory with the report number
$reportDir = "rpt$reportNo"

# Creating a new directory
mkdir $reportDir

# Copy the file into the new directory
Copy-Item $filepath $reportDir