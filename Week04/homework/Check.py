# Create and interface to search through access log file
import re, sys, yaml


# Open the Yaml file
try:

    with open('attacks.yml', 'r') as yf:
        keywords = yaml.safe_load(yf)

except EnvironmentError as e:
    print(e.strerror)

   
# Creating a function
def attackLogs(filename, service):
    # Gathers all terms in specific service
    everyTerm = keywords[service]

    # Creates a blank list to store all terms
    listOfKeywords = []

    # Loops through every term in specified Service
    for term in everyTerm:
        
        # Gathers the value of specified term
        values = keywords[service][term]

        # Appends the values of each term
        listOfKeywords.append(values)

        # Opens a file
        with open(filename) as f:

            # Reads the file and saves it to a variable
            contents = f.readlines()

        # Creates a blank list to store results
        results = []

        # Loops through every line in the specified contents(file)
        for line in contents:
            
            # Loops through every value in the list previously made
            for eachValue in listOfKeywords:

                # Searches and returns results using regular expression search
                x = re.findall(r''+eachValue+'', line)

                # Creates a loop for all values found in x
                for found in x:
                    
                    # Appends all of these found values to previously created list
                    results.append(found)

    # Sort the list
    results = sorted(results)

    # This is to split the filename from the path
    file=filename.split("\\")
    # This is to help display the information easier by breaking text up with blank lines and the filenames
    print('\n'+'\n'+'File: '+file[1]+'\n')
    # This returns the results
    return results
            