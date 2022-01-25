import LinuxLogCheck
import importlib
importlib.reload(LinuxLogCheck)

# SSH authentication failures
def klogind_fail(filename, searchTerms):

    # Call LinuxLogCheck and return the results
    is_found = LinuxLogCheck._LinuxLog(filename,searchTerms)

    # found list
    found = []

    # Loop through the results
    for eachFound in is_found:
        
        # Split the results
        sp_results = eachFound.split(" ")

        # Append the split value to the found list
        found.append(sp_results[4])

    # Remove duplicates by using set
    hosts = set(found)

    # Print results
    for eachHost in hosts:
        
        print(eachHost)