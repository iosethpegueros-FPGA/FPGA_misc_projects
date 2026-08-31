

if {[info exists env(FPGA_ROOT)]} { 
	#puts "FPGA_ROOT set to $FPGA_ROOT" 
	
	open_project $env(FPGA_ROOT)/results/CDC_top_asyncFIFO.xpr
	
	set_property top CDC_top_tb_uvm_ver0 [current_fileset]
	update_compile_order -fileset sim_1 
	
	set_property -name {xsim.compile.xvlog.more_options}   -value {-L uvm} -objects [get_filesets sim_1]
	set_property -name {xsim.elaborate.xelab.more_options} -value {-L uvm} -objects [get_filesets sim_1]
	
	set_property -name {xsim.simulate.xsim.more_options} -value {} -objects [get_filesets sim_1]
	set_property -name {xsim.elaborate.snapshot} -value {sim_snapshot} -objects [get_filesets sim_1]
	
	launch_simulation
	
	#run all
	cd $env(FPGA_ROOT)/CDC_top_asyncFIFO/results/CDC_top_asyncFIFO.sim/sim_1/behav/xsim
	
	exec xsim sim_snapshot -R -testplusarg UVM_TESTNAME=random_burst_test
	
	close_sim
	close_project

} else {
	puts "" 
	puts "ERROR: FPGA_ROOT not set" 
	puts "" 
}

