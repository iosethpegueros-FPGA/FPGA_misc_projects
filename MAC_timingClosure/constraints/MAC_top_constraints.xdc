

#define main clock frequency  starting at 500MHZ 
create_clock -name main_clock -period 2 [get_ports clock]
## 400 Mhz version 
##create_clock -name main_clock -period 2.5 [get_ports clock]
## 300 Mhz version 
#create_clock -name main_clock -period 3.333 [get_ports clock]

