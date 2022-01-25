import LinuxLogCheck
import importlib
importlib.reload(LinuxLogCheck)

# SSH users being authenticated (session opened)
def ssh_success(filename, searchTerms):

    # Call LinuxLogCheck and return the results
    is_found = LinuxLogCheck._LinuxLog(filename,searchTerms)

    # found list
    found = []

    # Loop through the results
    for eachFound in is_found:
        
        # Split the results
        sp_results = eachFound.split(" ")

        # Append the split value to the found list
        found.append(sp_results[5])

    # Remove duplicates by using set
    usernames = set(found)

    # Print results
    for user in usernames:
        
        print(user)