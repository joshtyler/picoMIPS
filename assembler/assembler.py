import io
import uuid

filename = "input.asm"

# Process a buffer
# This may be an iterative process, so return a procCount
# A non zero proc count means that some elements are not of base operations
def processBuf(inBuf, outBuf):
    procCount = 0
    line = inBuf.readline()
    while line: #While not at end of file
        procCount =+ processCmd(line, outBuf)
        line = inBuf.readline()
    return procCount

def processCmd(line, outBuf):
    args = line.split(' ')

    # Iterate through list and remove all entries after a comment
    removeMode = False
    tmpList = []
    for item in args:
        if( item[0] == '/' and item[1] == '/'):
            removeMode = True
        if(not removeMode):
            tmpList.append(item)
    args = tmpList
    
    # If the list is now empty (line was just a comment. Return)
    if(len(args) == 0):
        return 0

    # If the current line has a label, append to output stream and continue as normal
    if(args[0][-1] == ':'):
        outBuf.write(args[0])
        outBuf.write(' ')
        args.pop(0)

    # If the list is now empty (line was just a label. Return)
    if(len(args) == 0):
        return 0

    # If command is already accepted type (or empty line). Write out verbatim
    if(args[0] == 'SUBLEQ' or args[0] == 'MULTI' or args[0] == '\n'):
        outBuf.write(line)
        return 0

    # Process command into acceptable type
    outBuf.write(cmdLookup(args))
    return 1

def cmdLookup(args):
    return {
        'JZ' : jzImp(args),
    }[args[0]]

#Format JZ [register to test], [address]
def jzImp(args):
    # From https://en.wikipedia.org/wiki/One_instruction_set_computer#Subtract_and_branch_if_less_than_or_equal_to_zero
    label1 = uuid.uuid4().hex + ":"
    label2 = uuid.uuid4().hex + ":"
    retstr = "//Begin JZ implementation\n"
    retstr += ("SUBLEQ " + args[1] + " Z " + label1 + "\n") #If 0 - arg[1] is less than or equal to 0, go to label1
    retstr += ("SUBLEQ " + "Z Z " + label2 + "\n") # Goto out
    retstr += (label1 + " SUBLEQ " + "Z " + args[1] + " " + args[2] + "\n")  #If arg[1] -0 is less than or equal to 0, branch
    retstr += (label2 + " ") # Out
    return retstr

#Format JNZ [register to test], [address]
def jnzImp(args):
    # From https://en.wikipedia.org/wiki/One_instruction_set_computer#Subtract_and_branch_if_less_than_or_equal_to_zero
    label1 = uuid.uuid4().hex + ":"
    label2 = uuid.uuid4().hex + ":"
    retstr = "//Begin JNZ implementation\n"
    retstr += ("SUBLEQ " + args[1] + " Z " + label1 + "\n") #If 0 - arg[1] is less than or equal to 0, go to label1
    retstr += ("JP " + args[2] + "\n") #If it's greater than zero, we've passed
    retstr += (label1 + " SUBLEQ " + "Z " + args[1] + " " + label2 + "\n")  # If arg[1] - 0 < 0. It must be zero
    retstr += ("JP " + args[2] + "\n")  # If it's less than zero, we've passed
    retstr += (label2 + " ") # Out
    return retstr

#Format JP [address]
def jpImp(args):
    return "//Begin JP implementation\n"SUBLEQ Z Z " + args[1] + "\n"

def movImp(args):
    retstr = "//Begin MOV implementation\n"


inputFile = io.open(filename, 'r')
tempBuf = io.StringIO()
processBuf(inputFile, tempBuf)
print(tempBuf.getvalue())
    
