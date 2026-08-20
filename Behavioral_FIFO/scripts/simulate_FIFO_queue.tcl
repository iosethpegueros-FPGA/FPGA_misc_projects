

if {[info exists env(FPGA_ROOT)]} { 
	#puts "FPGA_ROOT set to $FPGA_ROOT" 
	
	open_project $env(FPGA_ROOT)/results/FIFO_queue_project.xpr
	
	set_property top FIFO_queue_tb [current_fileset]
	update_compile_order -fileset sim_1 
	
	launch_simulation
	
	run all
	
	close_project



} else {
	puts "" 
	puts "ERROR: FPGA_ROOT not set" 
	puts "" 
}

