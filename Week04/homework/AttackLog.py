import Check
import importlib
importlib.reload(Check)

# Apache events
def attacks(filename, service):

    # Call logCheck and return the results
    is_found = Check.attackLogs(filename, service)

    #  found list
    found = []

    # Loop through the results
    for eachFound in is_found:
        
        print (eachFound)
        print(len(is_found))
        # Split the results
        sp_results = eachFound.split(" ")

        # Append the split value to the found list
        found.append(sp_results[3] + " " + sp_results[0] + " " + sp_results[1])

    # Remove duplicates by using set
    # and convert the list to a dictionary
    getValues = set(found)

    # Print results
    for eachValue in getValues:
        print(eachValue)