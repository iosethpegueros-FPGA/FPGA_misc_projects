
#print and validate env variable 
puts "running " 
puts $env(FPGA_ROOT)


if {[info exists env(FPGA_ROOT)]} { 
	#puts "FPGA_ROOT set to $env(FPGA_ROOT)" 

	#project for PYNCQ Z1 device
	create_project -force TinyTests_project $env(FPGA_ROOT)/results/ -part xc7z020clg400-1 


	add_files -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/blockingVsNonBlocking_tb.sv
	add_files -norecurse -scan_for_includes $env(FPGA_ROOT)/rtl/4bit_substract.v

	
	set_property top 4bit_substract [current_fileset] 
	update_compile_order -fileset sources_1 
	
	#save_project as MAC_pipelined_TimingClosure.xpr
	
	close_project 
	
} else {

	puts "" 
	puts "ERROR: FPGA_ROOT not set" 
	puts "" 
	puts ""
	
}

