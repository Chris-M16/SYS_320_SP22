# List the files in a directory
# List all files and print the full path
#Get-ChildItem -Recurse -Include *.docx,*.pdf,*.txt -Path .\Documents | Select FullName

#Get-ChildItem -Recurse -Include *.docx,*.pdf,*.txt -Path .\Documents | Export-Csv `
#-Path files.csv

# Import CSV file.
$fileList = Import-Csv -Path .\files.csv #-Header FullName

# Loop through the results
foreach ($f in $fileList) {

    Get-ChildItem -Path $f.FullName


}