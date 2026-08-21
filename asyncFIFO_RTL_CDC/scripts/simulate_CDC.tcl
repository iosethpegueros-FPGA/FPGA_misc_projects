

if {[info exists env(FPGA_ROOT)]} { 
	#puts "FPGA_ROOT set to $FPGA_ROOT" 
	
	open_project $env(FPGA_ROOT)/results/CDC_top_asyncFIFO.xpr
	
	set_property top tb_CDC_FIFO_top [current_fileset]
	update_compile_order -fileset sim_1 
	
	launch_simulation
	
	run all
	
	close_sim
	close_project



} else {
	puts "" 
	puts "ERROR: FPGA_ROOT not set" 
	puts "" 
}

