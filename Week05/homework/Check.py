# Import the below libraries
import csv, re, yaml

# Open the Yaml file
try:

    with open('detections.yml', 'r') as yf:
        keywords = yaml.safe_load(yf)

except EnvironmentError as e:
    print(e.strerror)

# Creating function to search through .csv file
def windows(filename,service):

    # Gather the terms in specified service
    everyTerm = keywords[service]

    # Creates a blank list to store all terms
    listOfKeywords = []

    # Loops through every term in specified Service
    for term in everyTerm:
        
        # Gathers the value of specified term
        values = keywords[service][term]

        # Appends the values of each term
        listOfKeywords.append(values)

        # Open the file
        with open(filename, 'r', encoding="utf8") as f:

            # Reading the file and saving as contents
            contents = csv.reader(f)

            # Skip over the first line
            for _ in range(1):

                # Process the remaining lines
                next(contents)

            # Blank list to store results in
            lineOfAttack = []

            # Loop through each line in contents
            for line in contents:

                # Loop through the terms and search for the keyword
                for eachValue in listOfKeywords:
                    
                    # Loop through every line in the loaded file
                    for i in range (len(line)):
                        
                        x = re.findall(r''+eachValue+'',line[i])

                        # Loop through the findings and then append each value
                        for _ in x:
                    
                            lineOfAttack.append(line[0])
                            lineOfAttack.append(line[1])
                            lineOfAttack.append(line[2])
                            lineOfAttack.append(line[3])
                            lineOfAttack.append(line[4])
                            lineOfAttack.append(line[5])
                            lineOfAttack.append(line[6])
        # Return the values
        return lineOfAttack