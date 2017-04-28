#!/usr/bin/python3

#This script takes an assembly program constaining SUBLEQ and MULTI instructions, and converts it to machine code for my picoMIPS implementation

import io
import re
import datetime
import sys

#Constant dictionary
const_dict = dict([
	('CONST_MOV_ZERO', 8),
])

#Label dictionary
label_dict = dict()

#Register dictionary
reg_dict = dict([
    ('R1', 0), # General purpose reg 1
    ('R2', 1), # General purpose reg 2
    ('R3', 2), # General purpose reg 3
    ('R4', 3), ('LED', 3),  # General purpose reg 4 (mapped to LEDs)
    ('U', 4), # Unity register
    ('Z', 5), # Zero register
    ('SW17', 6), # Switches 1-7
    ('SW8', 7), # Switch 8
])

# Take a raw input file and strip it of labels and constants
# Labels and constants will be added to the global dictionary
# Input is an IO type buffer
# Output is an list of strings
def get_numerical_data(in_buf):
    line = in_buf.readline()

    # Add all constants to a dictionary
    # Return 0 if line is not a constant declaration
    while process_constants(line):
        line = in_buf.readline()

    # All lines from now on define an instruction
    # Therefore add all labels to dictionary
    stripped_lines = []
    while line:  # While not at end of file
        stripped_lines.append(process_labels(line, len(stripped_lines)))
        line = in_buf.readline()

    # For each line, convert the text format to a numrical tuple of arguments
    prog_data = []
    for i in range(0,len(stripped_lines)):
        prog_data.append(process_cmd(stripped_lines[i],i))

    return prog_data

# Check if a line defines a constant, if so, add it to the dictionary
def process_constants(line):
    global const_dict
    line = line.strip('\n')  # Remove newline
    args = re.split(' +', line)

    if(args[0] == "CONST"):
        const_dict[args[1]] = int(args[2])
        return 1

    return 0


# Take a line, add any labels to the dictionary, convert command to array format
def process_labels(line, address):
    global const_dict
    global reg_dict
    global label_dict
    line = line.strip('\n')  # Remove newline
    args = re.split(' +', line)

    # If the current line has label(s), append to dictionary
    # If the line at any point is empty, return
    i = 0
    while i == 0:
        #If we have a label on our hands
        if args[i][-1] == ':':
            label_dict[args[i][:-1]] = address
            args.pop(i)
        else:
            i += 1

    # Make the args immutable and return them
    return args

def process_cmd(args, address):
    # Make sure we have one of the two supported types
    assert(len(args) > 1)

    if args[0] == 'SUBLEQ':
        args[0] = 0
    elif args[0] == 'MULTI':
        args[0] = 1
    else:
        print(args[0])
        assert(False)

    # Process arguments. Note that no checking is made for format. labels and consts with same name etc.
    for i in range(1,len(args)):
        # If the argument is a constant, replace it with the constant
        if args[i] in const_dict:
            args[i] = const_dict[args[i]]
        # Or if it is a register replace it with the register address
        elif args[i] in reg_dict:
            args[i] = reg_dict[args[i]]
        # Or if it is in the label dictionary replace it with the label
        elif args[i] in label_dict:
            args[i] = label_dict[args[i]]
        # The last argument is an empty string because the line terminates in a space
        elif args[i] == '' and i == (len(args) - 1):
            args.pop(i)
            break
        # There aren't any other possibilities!
        else:
            print(args[i])
            assert False

    # For a two argument subleq, append the next address as the branch address
    if (args[0] == 0) and (len(args) == 3):
        args.append(address + 1)

    assert(len(args) == 4)

    return tuple(args)

#Format is
# Instruction identifier (1 bit)
# Reg 1 addr (3 bits)
# Reg 2 addr (3 bits)
# Jump addr / immediate (6 bits)
def formatTuple(input):
    ident = format(input[0],'01b')
    reg1 = format(input[1], '03b')
    reg2 = format(input[2], '03b')
    addr = format(input[3], '05b')

    retstr = ident + reg1 + reg2 + addr

    assert(len(retstr) == 12)

    return retstr

# Output memory as an altera MIF file
def outputAlteraMif(filename, list, formatter):
    output = io.open(filename, 'w')
    output.write("-- Automatically generated memory map by python\n")
    output.write("-- {}\n\n".format(datetime.datetime.now().strftime("%I:%M%p on %B %d %Y")))
    output.write("DEPTH = {};\n".format(len(list)))
    output.write("WIDTH = {};\n".format( len(formatter(list[0]))))
    output.write("ADDRESS_RADIX = HEX;\n")
    output.write("DATA_RADIX = BIN;\n")
    output.write("CONTENT\n")
    output.write("BEGIN\n\n")

    for i in range(0, len(list)):
        output.write('{} : {};\n'.format(format(i,'02x'), formatTuple(list[i])))

    output.write("\nEND;\n")
    output.close()

# Output memory in a format readable by verilog $readmemb
def outputHex(filename, list, formatter):
    output = io.open(filename, 'w')
    output.write("//Automatically generated memory map by python\n")
    output.write("//{}\n".format(datetime.datetime.now().strftime("%I:%M%p on %B %d %Y")))

    for i in range(0, len(list)):
        output.write('{}\n'.format(formatTuple(list[i])))

    output.close()

#Begin main script


assert(len(sys.argv) == 3)  # We need both an input and output file specified
infilename = sys.argv[1]
outfilename = sys.argv[2]

inputFile = io.open(infilename, 'r')
lst = get_numerical_data(inputFile)
inputFile.close()

outputAlteraMif(outfilename, lst, formatTuple)

