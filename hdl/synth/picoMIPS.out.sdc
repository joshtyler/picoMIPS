## Generated SDC file "picoMIPS.out.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 15.0.0 Build 145 04/22/2015 SJ Full Version"

## DATE    "Wed Apr 26 14:35:41 2017"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {counter:c|count[23]} -period 1000.000 -waveform { 0.000 500.000 } [get_registers { counter:c|count[23] }]
create_clock -name {fastclk} -period 20.000 -waveform { 0.000 10.000 } [get_ports { fastclk }]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {counter:c|count[23]}] -rise_to [get_clocks {counter:c|count[23]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {counter:c|count[23]}] -fall_to [get_clocks {counter:c|count[23]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {counter:c|count[23]}] -rise_to [get_clocks {fastclk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {counter:c|count[23]}] -fall_to [get_clocks {fastclk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {counter:c|count[23]}] -rise_to [get_clocks {counter:c|count[23]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {counter:c|count[23]}] -fall_to [get_clocks {counter:c|count[23]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {counter:c|count[23]}] -rise_to [get_clocks {fastclk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {counter:c|count[23]}] -fall_to [get_clocks {fastclk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {fastclk}] -rise_to [get_clocks {counter:c|count[23]}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {fastclk}] -fall_to [get_clocks {counter:c|count[23]}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {fastclk}] -rise_to [get_clocks {fastclk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {fastclk}] -fall_to [get_clocks {fastclk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {fastclk}] -rise_to [get_clocks {counter:c|count[23]}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {fastclk}] -fall_to [get_clocks {counter:c|count[23]}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {fastclk}] -rise_to [get_clocks {fastclk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {fastclk}] -fall_to [get_clocks {fastclk}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

