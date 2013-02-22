import sys, subprocess, getopt

# keys we'll be using when talking with splunk.
USERNAME    = "username"
USERTYPE    = "role"
SUCCESS     = "--status=success"
FAILED      = "--status=fail"

# read the inputs coming in and put them in a dict for processing.
def readInputs():
   optlist, args = getopt.getopt(sys.stdin.readlines(), '', ['username=', 'password='])

   returnDict = {}
   for name, value in optlist:
      returnDict[name[2:]] = value.strip()

   return returnDict