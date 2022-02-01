import logCheck
import importlib
importlib.reload(logCheck)

# proxy events
def proxy_events(filename, service, term):

    # Call logCheck and return the results
    is_found = logCheck._logs(filename, service, term)

    #  found list
    found = []

    # Loop through the results
    for eachFound in is_found:
        
        # Split the results
        sp_results = eachFound.split(" ")

        # Append the split value to the found list
        found.append(sp_results[0] + " - " + sp_results[2])

    # Remove duplicates by using set
    # and convert the list to a dictionary
    getValues = set(found)

    # Print results
    for eachValue in getValues:
        
        print(eachValue)
        