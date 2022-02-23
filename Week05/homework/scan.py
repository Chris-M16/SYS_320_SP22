# File to traverse a given directory and retrieve all the files
import os, argparse, importlib, csv
import Check
importlib.reload(Check)

# parser
parser = argparse.ArgumentParser(

    description="Traverses a directory and builds a forensic body file",
    epilog="developed by Chris McHugh 20220222"

)

# Add argument to pass to the program
parser.add_argument("-d", "--directory", required="True", help="Directory that you want to traverse.")
parser.add_argument("-s", "--service", required="True", help="Service you want to search for.")

# Parse the arguments
args = parser.parse_args()

# Name the args
rootdir = args.directory
service = args.service

# Check, if the argument is a directory
if not os.path.isdir(rootdir):
    print("Invalid Directory => {}".format(rootdir))
    exit()

# List to save files
fList = []

# Crawl through the provided directory
for root, subfolders, filenames in os.walk(rootdir):

    for f in filenames:

        #print(root + "/" + f)
        fileList = root + "/" + f
        #print(fileList)
        fList.append(fileList)


# The three below if statements are to detect which service is in use

    # If the service is script it will display the proper attack and description of attack
    if service == "script":
        attack = "Processes Running JavaScript Or VBScript"
        description = "Adversaries may use scripts to aid in operations and perform multiple actions that would otherwise be manual. Scripting is useful for speeding up operational tasks and reducing the time required to gain access to critical resources. Some scripting languages may be used to bypass process monitoring mechanisms by directly interacting with the operating system at an API level instead of calling other programs. Common scripting languages for Windows include VBScript and PowerShell but could also be in the form of command-line batch scripts."
        print("""
{2}
{0}
{2}
Description:
{1}
{2}""".format(attack,description,'='*50))
    
    # If the service is credentialCollection it will display the proper attack and description of attack
    elif service == "credentialCollection":
        attack = "Signs Of Credentials Collection In The Registry"
        description = """
The Windows Registry stores configuration information that can be used by the system or other programs. Adversaries may query the Registry looking for credentials and passwords that have been stored for use by other programs or services. Sometimes these credentials are used for automatic logons.
Adversaries could also inject malicious DLLs into registry keys that are loaded after reboot. When a user authenticates the DLLs have a routine that captures their credentials after login."""
        print("""
{2}
{0}
{2}
Description:
{1}
{2}""".format(attack,description,'='*50))
    
    # If the service is powershellExecutions it will display the proper attack and description of attack
    elif service == "powershellExecutions":
        attack = "Powershell executions"
        description = "PowerShell is a powerful interactive command-line interface and scripting environment included in the Windows operating system. Adversaries can use PowerShell to perform a number of actions, including discovery of information and execution of code. Examples include the Start-Process cmdlet which can be used to run an executable and the Invoke-Command cmdlet which runs a command locally or on a remote computer."
        print("""
{2}
{0}
{2}
Description:
{1}
{2}""".format(attack,description,'='*50))
    
    # If the service is none of the above it will pass
    else:
        pass
    # Loop through every file in fList
    for file in fList:
        
        # Calls Check and gathers the returned value
        is_found = Check.windows(file, service)

        # Creates a blank list to store the filtered values
        CleanList = []

        # If statement to avoid error of value out of index when there is nothing returned for a file.
        if len(is_found) != 0:

            # Loop through each list from the returned values
            for eachList in range (len(is_found)):

                # If statement to check if specified list is in the cleanlist and appends them if they
                if is_found[eachList] not in CleanList:
                    CleanList.append([is_found[eachList]])
                if len(CleanList) == 7:
                    num = CleanList[0]
                    argument = CleanList[1]
                    hostname = CleanList[2]
                    name = CleanList[3]
                    path = CleanList[4]
                    pid = CleanList[5]
                    username = CleanList[6]
                    print("""
Argument: {0}
Hostname: {1}
Name: {2}
Path: {3}
PID: {4}
Username: {5}                
{6}""".format(*argument,*hostname,*name,*path,*pid,*username,'-'*50))
                    CleanList = []          

        else:
            pass