

if {[info exists env(FPGA_ROOT)]} { 
	# # #puts "FPGA_ROOT set to $FPGA_ROOT" 
	
	set argv  {pipelined}
	set argc  1
	
	source $env(FPGA_ROOT)/scripts/synth_MAC.tcl
	source $env(FPGA_ROOT)/scripts/implement_MAC.tcl
	source $env(FPGA_ROOT)/scripts/generate_TimingReports.tcl


} else {
	puts "" 
	puts "ERROR: FPGA_ROOT not set" 
	puts "" 
}

