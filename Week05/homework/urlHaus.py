# Import the below libraries
import csv, re

# Creating function to search through .csv file
def windows(filename,searchTerms):
# Fix: Since this all needs to be in the function I indented all of the below code
    # Fix: Changed the While to With
    # Fix: Removed '' around filename

    # Open the file
    with open(filename) as f:
        # Fix: Indented line to be in the with statement
        # Fix: Removed one of the = signs.
        # Fix: changed csv.review to csv.reader
        # Fix: changed filename to f inside ()

        # Reading the file and saving as contents
        contents = csv.reader(f)

        # Skip over the first 9 lines
        for _ in range(9):
            # Fix: Indented line to be in the statement

            # Process the remaining lines
            next(contents)

        # Fix: Indented to put statement inside of the above statement
        # Fix: Removed the s on the end of searchTerms
        # Fix: Switched this loop with the loop below

        # Loop through each line in contents
        for eachLine in contents:

            # Fix: Indented to put statement inside of the above statement
            # Fix: Switched this loop with the loop above

            # Loop through the terms and search for the keyword
            for keyword in searchTerms:
                
                # Fix: Indented to put statement inside of the above statement.
                # Fix: I also imported 're' in line 2.
                # Fix: also added '' in proper places.
                x = re.findall(r''+keyword+'',eachLine[2])
                for _ in x:

                    
                # Don't edit this line. It is here to show how it is possible
                # to remove the "tt" so programs don't convert the malicious
                # domains to links that an be accidentally clicked on.

                    # Fix: Indented to put into above for loop

                    # Prints out each url and src in a nice format
                    the_url = eachLine[2].replace("http","hxxp")
                    the_src = eachLine[7]

                    # Fix: changed +60 to *60
                    # Fix: added {} and value inside for the 3 format fields

# The 3 "" are a here doc and inside that indentation does not matter
                    print("""
URL: {0}
Info: {1}
{2}""".format(the_url, the_src,"*"*60))