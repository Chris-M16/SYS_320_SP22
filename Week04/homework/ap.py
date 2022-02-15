# File to traverse a given directory and retrieve all the files
from msilib.schema import Directory
import os, argparse, importlib
import Check
importlib.reload(Check)

# parser
parser = argparse.ArgumentParser(

    description="Traverses a directory and builds a forensic body file",
    epilog="developed by Chris McHugh 20220210"

)

# Add argument to pass to the fs.py program
parser.add_argument("-d", "--directory", required="True", help="Directory that you want to traverse.")
parser.add_argument("-s", "--service", required="True", help="Service you want to search for.")

# Parse the arguments
args = parser.parse_args()

# Name the args
rootdir = args.directory
service = args.service

# Check, if the argument is a directory
if not os.path.isdir(rootdir):
    print("Invalid Directory => {}".format(rootdir))
    exit()

# List to save files
fList = []

# Crawl through the provided directory
for root, subfolders, filenames in os.walk(rootdir):

    for f in filenames:

        #print(root + "/" + f)
        fileList = root + "\\" + f
        #print(fileList)
        fList.append(fileList)

# Loop through every file in fList
for file in fList:
    
    # Calls Check and returns the results
    is_found = Check.attackLogs(file, service)

    # Creates a blank list
    found = []

    # This below if statement is used to display files with no detected attacks
    if len(is_found) == 0:
        print("No Attacks Detected")
    else:
        # Loop through the results
        for eachFound in is_found:

            # Splits the results to help with formatting
            sp_results = eachFound.split(" ")

            # Appends the split values together in desired formatting to the found list
            found.append("Status Code: " + sp_results[8] + "  Bytes: " + sp_results[9] + "  Path:" + sp_results[6] + " ")

        # Removes duplicates by using set and converts the list back to a dictionary
        getValues = set(found)

        # Prints all of the results
        for eachValue in getValues:
            print(eachValue)
        