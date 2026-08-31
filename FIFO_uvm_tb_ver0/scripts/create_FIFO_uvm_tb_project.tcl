
#print and validate env variable 
puts "running " 
puts $env(FPGA_ROOT)


if {[info exists env(FPGA_ROOT)]} { 
	#puts "FPGA_ROOT set to $env(FPGA_ROOT)" 

	#project for PYNCQ Z1 device
	create_project -force CDC_top_asyncFIFO $env(FPGA_ROOT)/results/ -part xc7z020clg400-1 

	#adding RTL modules
	add_files -norecurse -scan_for_includes $env(FPGA_ROOT)/rtl/CDC_top.sv

	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/CDC_top_tb_uvm_ver0.sv
	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/fifo_data_hex.txt
	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/FIFO_queue_bfm.sv
	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/FIFO_queue_package.sv
	
	
	
	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/FIFO_queue_coverage.svh
	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/FIFO_queue_scoreboard.svh
	
	
#	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/base_test.svh
	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/address_boundaries_test.svh	
	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/random_burst_test.svh	
	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/reset_health_test.svh	
	
	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/base_tester.svh
	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/address_boundaries_tester.svh	
	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/random_burst_tester.svh	
	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/reset_health_tester.svh	
	add_files -fileset sim_1 -norecurse -scan_for_includes $env(FPGA_ROOT)/tb/env.svh
	
	#adding include paths
	set_property include_dirs [list "$env(FPGA_ROOT)/tb/"] [get_filesets sim_1]

	#adding constraintse

	#change debug level to all for better debug
	set_property -name {xsim.elaborate.debug_level} -value {all} -objects [get_filesets sim_1]
	
	# seting top module for simulation
	set_property top CDC_top_tb_uvm_ver0 [current_fileset] 
	update_compile_order -fileset sources_1 
	
	#closing project
	close_project 
	
} else {

	puts "" 
	puts "ERROR: FPGA_ROOT not set" 
	puts "" 
	puts ""
	
}

