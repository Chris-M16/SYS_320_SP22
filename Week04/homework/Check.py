# Create and interface to search through access log file
import re, sys, yaml


# Open the Yaml file
try:

    with open('attacks.yml', 'r') as yf:
        keywords = yaml.safe_load(yf)

except EnvironmentError as e:
    print(e.strerror)

   

def attackLogs(filename, service):
    # Gathers all information on specific service
    
    everyTerm = keywords[service]
    listOfKeywords = []
    # Loops through every term in specified Service
    for term in everyTerm:
        
        # Gathers the value of specified term
        values = keywords[service][term]
        listOfKeywords.append(values)
        # Opens a file
        with open(filename) as f:
            # Read the file and saves it to a variable
            contents = f.readlines()

        results = []

        for line in contents:
            for eachValue in listOfKeywords:

                x = re.findall(r''+eachValue+'', line)

                for found in x:

                    results.append(found)

    # Sort the list
    results = sorted(results)

    file=filename.split("\\")
    print('\n'+'\n'+'File: '+file[1]+'\n')
    return results
            