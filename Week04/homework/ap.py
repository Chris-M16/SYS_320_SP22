# File to traverse a given directory and it's subdirs and retrieve all the files
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

rootdir = args.directory
service = args.service

# Get information from the commandline
#print(sys.argv)

# Directory to traverse
#rootdir = sys.argv[1]

#print(rootdir)

# In our story, we wil traverse a directory

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

for file in fList:
    is_found = Check.attackLogs(file, service)

    found = []
    if len(is_found) == 0:
        print("No Attacks Detected")
    else:
        for eachFound in is_found:
            sp_results = eachFound.split(" ")

            found.append("Status Code: " + sp_results[8] + "  Bytes: " + sp_results[9] + "  Path:" + sp_results[6] + " ")

        getValues = set(found)

        
        for eachValue in getValues:
            print(eachValue)
        