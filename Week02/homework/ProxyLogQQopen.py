import ProxyLogCheck
import importlib
importlib.reload(ProxyLogCheck)

# Proxy events
def QQ_open(filename, searchTerms):

    # Call ProxyLogCheck and return the results
    is_found = ProxyLogCheck._ProxyLog(filename, searchTerms)

    #  found list
    found = []

    # Loop through the results
    for eachFound in is_found:
        
        # Split the results
        sp_results = eachFound.split(" ")

        # Append the split value to the found list
        found.append(sp_results[0] + " - " + sp_results[2] + " - " + sp_results[6] + " - " + sp_results[7])

    # Remove duplicates by using set
    # and convert the list to a dictionary
    getValues = set(found)

    # Print results
    print("Format:\nFilename - Host - Proxy - Protocol\n")
    for eachValue in getValues:
        
        print(eachValue)
        