#!/usr/bin/python
# This program takes an assembly program and converts it to only use SUBLEQ and MULTI commands

import io
import re
import sys

def gen_label_name():
    retstr = "label" + str(gen_label_name.number)
    gen_label_name.number += 1  # This is the closest python gets to a static variable. Init in main code
    return retstr


# Format JZ [register to test], [address]
def jz_imp(args):
    # From https://en.wikipedia.org/wiki/One_instruction_set_computer#Subtract_and_branch_if_less_than_or_equal_to_zero
    label1 = gen_label_name()
    label2 = gen_label_name()
    retstr = "//Begin JZ implementation\n"
    retstr += ("SUBLEQ " + args[1] + " Z " + label1 + "\n")  # If 0 - arg[1] is less than or equal to 0, go to label1. Z = -args[1]
    retstr += ("SUBLEQ " + "Z Z " + label2 + "\n")  # Goto out. Z = 0
    retstr += (label1 + ": SUBLEQ " + "Z Z\n")  # Clear Z
    retstr += ("SUBLEQ " + "Z " + args[1] + " " + args[2] + "\n")  # If arg[1] - 0 is <= 0, branch. N.B. arg[1] is unchanged because we subtract 0
    retstr += (label2 + ": \n")  # Out
    retstr += "//End JZ implementation\n"
    return retstr


# Format JNZ [register to test], [address]
def jnz_imp(args):
    # From https://en.wikipedia.org/wiki/One_instruction_set_computer#Subtract_and_branch_if_less_than_or_equal_to_zero
    label1 = gen_label_name()
    label2 = gen_label_name()
    retstr = "//Begin JNZ implementation\n"
    retstr += ("SUBLEQ " + args[1] + " Z " + label1 + "\n")  # If 0 - arg[1] is less than or equal to 0, go to label1. Z = -args[1]
    retstr += ("JP " + args[2] + "\n")  # If it's greater than zero, we've passed. (Note. JP will clear Z)
    retstr += (label1 + ": SUBLEQ " + "Z Z\n")  # Clear Z
    retstr += ("SUBLEQ " + "Z " + args[1] + " " + label2 + "\n")  # If arg[1] - 0 < 0. It must be zero. N.B. arg[1] is unchanged because we subtract 0
    retstr += ("JP " + args[2] + "\n")  # If it's less than zero, we've passed
    retstr += (label2 + ": \n")  # Out
    retstr += "//End JNZ implementation\n"
    return retstr


# Format JP [address]
def jp_imp(args):
    retstr = "//Begin JP implementation\n"
    retstr += "SUBLEQ Z Z " + args[1] + "\n"
    retstr += "//End JP implementation\n"
    return retstr


# Format MV [src], [dest]
def mov_imp(args):
    retstr = "//Begin MOV implementation\n"
    retstr += ("SUBLEQ " + args[2] + " " + args[2] + "\n")  # Clear r2
    retstr += ("SUBLEQ " + args[1] + " Z\n")  # Set Z to -r1
    retstr += ("SUBLEQ Z " + args[2] + "\n")  # Set r2 to -A (=r1)
    retstr += "SUBLEQ Z Z \n"  # Clear Z
    retstr += "//End MOV implementation\n"
    return retstr


# Format ADD [src], [dest]
def add_imp(args):
    retstr = "//Begin ADD implementation\n"
    retstr += ("SUBLEQ " + args[1] + " Z \n")  # Z = -r1
    retstr += ("SUBLEQ Z " + args[2] + "\n")  # r2 = r2 -Z = r2 + r1
    retstr += "SUBLEQ Z Z \n"  # Clear Z
    retstr += "//End ADD implementation\n"
    return retstr


# Format LDI [dest], [Immediate]
def ldi_imp(args):
    retstr = "//Begin LDI implementation\n"
    retstr += ("MULTI U " + args[1] + " " + args[2] + "\n")  # Multiply immediate with 1, store in dest
    retstr += "//End LDI implementation\n"
    return retstr


commands = {'JZ': jz_imp,
            'JNZ': jnz_imp,
            'JP': jp_imp,
            'MOV': mov_imp,
            'ADD': add_imp,
            'LDI': ldi_imp}


# Process a buffer
# This may be an iterative process, so return a procCount
# A non zero proc count means that some elements are not of base operations
def process_buf(in_buf, out_buf):
    proc_count = 0
    line = in_buf.readline()
    while line:  # While not at end of file
        proc_count += process_cmd(line, out_buf)
        line = in_buf.readline()
    return proc_count


def process_cmd(line, out_buf):
    line = line.strip('\n')  # Remove newlines
    args = re.split(' +', line)

    # If the initial value is a space, resplit will put a space on the start of the list
    # Remove all empty arguments in string
    for i in range(len(args)-1, -1, -1):
        if args[i] == '':
            args.pop(i)

    # If the list is now empty (line was just a new line. Return)
    if len(args) == 0:
        return 0

    # Iterate through list and remove all entries after a comment
    remove_mode = False
    tmp_list = []
    for item in args:
        if item[0] == '/' and item[1] == '/':
            remove_mode = True
        if not remove_mode:
            tmp_list.append(item)
    args = tmp_list

    # If the current line has label(s), append to output stream and continue as normal
    # If the line at any point is empty, return
    i = 0
    while i == 0:
        if len(args) == 0:
            return 0
        elif args[i][-1] == ':':
            out_buf.write(args[i])
            out_buf.write(' ')
            args.pop(i)
        else:
            i += 1

    # If the list is now empty (line was just a label. Return)
    if len(args) == 0:
        return 0

    # If command is already accepted type (or empty line). Write out verbatim
    if args[0] == 'SUBLEQ' or args[0] == 'MULTI' or args[0] == 'CONST' or args[0] == '\n':
        for i in range(0, len(args)):
            out_buf.write(args[i])
            out_buf.write(" ")
        out_buf.write("\n")
        return 0

    # Process command into acceptable type
    out_buf.write(commands[args[0]](args))
    return 1

# Start of main script

assert(len(sys.argv) == 3)  # We need both an input and output file specified
infilename = sys.argv[1]
outfilename = sys.argv[2]

gen_label_name.number = 0

inputFile = io.open(infilename, 'r')
buf1 = io.StringIO(inputFile.read())
inputFile.close()

# Recursively process stream
action = True
while action:
#    print("NEXT ITERATION")
    buf2 = io.StringIO()  # Buf 2 is empty stream
    action = process_buf(buf1, buf2)
#    print(buf2.getvalue())
    # Buf1 now contains the previous stream, buf2 the current stream
    buf1.close()  # Close the old stream as it is no longer needed
    buf1 = io.StringIO(buf2.getvalue())  # Create buf1 as a new stream with the contents of buf2
    buf2.close()  # Close buf2

outputFile = io.open(outfilename, 'w')
outputFile.write(buf1.getvalue())
buf1.close()
outputFile.close()