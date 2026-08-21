
# A - 100MHz and B - 150MHz timing clean
#create_clock -name clock_A [get_ports clka_in] -period 10
#create_clock -name clock_B [get_ports clkb_in] -period 6.66

## A - 200MHz and B -300MHz timing clean for  single bit sinchronizer and FIFO 
#create_clock -name clock_A [get_ports clka_in] -period 5
#create_clock -name clock_B [get_ports clkb_in] -period 3.33

## A - 625MHz and B -800MHz - setup slack ~1.5 ns for both clocks fanout 150 and 80 . push and towards empty flags fail ~2logic levels - for FIFO implementation
## unrealistic frecuencies for an Artix7 device. These are just for experimentation
create_clock -name clock_A [get_ports clka_in] -period 1.6
create_clock -name clock_B [get_ports clkb_in] -period 1.25

## A - MHz and B -MHz - setup slack
## unrealistic frecuencies for an Artix7 device. These are just for experimentation  
#create_clock -name clock_A [get_ports clka_in] -period 1.2
#create_clock -name clock_B [get_ports clkb_in] -period 0.8

set_clock_groups -asynchronous -group [get_clocks clock_A] -group [get_clocks clock_B]

set_false_path -from [get_ports rsta_n] -to [all_registers]
set_false_path -from [get_ports rstb_n] -to [all_registers]

## uncertanty values that seem reasonable to complete clock constraints 
#set_clock_uncertainty -setup 0.050 [get_clocks clock_A] ## not for an FPGA, this value looks more reazonable for an actual ASIC 
#set_clock_uncertainty -setup 0.030 [get_clocks clock_B] ## not for an FPGA, this value looks more reazonable for an actual ASIC


#XDC 
#set_clock_uncertainty -setup 0.200 [get_clocks clock_A]
#set_clock_uncertainty -setup 0.100 [get_clocks clock_B]
#set_clock_uncertainty -hold 0.150 [get_clocks clock_A]
#set_clock_uncertainty -hold 0.080 [get_clocks clock_B]


#SDC quartus
set_clock_uncertainty .2ns -to [get_clocks clock_A] -setup
set_clock_uncertainty .15ns -to [get_clocks clock_A] -hold

set_clock_uncertainty .1ns -to [get_clocks clock_B] -setup
set_clock_uncertainty .085ns -to [get_clocks clock_B] -hold

## Clock Uncertainty = Jitter + Skew + Margin
## Jitter - PLLs, Xtals, internal Clocking IP  - check in datasheets
## Skew   -  created by delay of clocking elements and clock tree paths
## Margin - extra time requirements to compensate design 



