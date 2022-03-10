# Create an interface to search through Linux_2k.log file
import re, sys

def _LinuxLog(filename,listOfKeywords):

    # Open a file
    with open(filename) as f:

        # read in the file and save it to a variable
        contents = f.readlines()

    # Lists to store the results
    results = []
    # Loop through the list returned. Each element is a line from the Linux_2k.log file
    for line in contents:

        # Loop through the list of keywords.
        for eachKeyword in listOfKeywords:

            # Searches and reurns results using a regular expression search
            x = re.findall(r''+eachKeyword+'', line)
            
            for found in x:
                # Append the returned keywords the the results list
                results.append(found)

    # Check to see if there are results
    if len(results) == 0:
        print("No Results")
        sys.exit(1)

    # Sort the list
    results = sorted(results)

    return results