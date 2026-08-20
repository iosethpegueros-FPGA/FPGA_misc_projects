
#print and validate env variable 
puts running  
puts $env(FPGA_ROOT)


if {[info exists env(FPGA_ROOT)]} { 
	#puts FPGA_ROOT set to $env(FPGA_ROOT) 

	#project for PYNCQ Z1 device

	create_project -force FIFO_queue_project $env(FPGA_ROOT)/results -part xc7z020clg400-1 

	#adding RTL modules
	# add_files -norecurse -scan_for_includes $env(FPGA_ROOT)/rtl/CDC_top_FIFO_1hotEncoding_for_addressSyncrhronization_v0_0.sv

	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/fifo_data_hex.txt
	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/FIFO_queue_bfm.sv
	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/FIFO_queue_class.svh
	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/FIFO_queue_coverage.svh
	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/FIFO_queue_package.sv
	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/FIFO_queue_scoreboard.svh
	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/FIFO_queue_tb.sv
	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/FIFO_queue_tester.svh
	# add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/FIFO_queue_top.sv	

	#adding constraints
	# add_files    -fileset constrs_1 -norecurse $env(FPGA_ROOT)/constraints/CDC_top.xdc
	# add_files -fileset constrs_1            $env(FPGA_ROOT)/constraints/CDC_top.xdc	

	# seting top module 
	# set_property top CDC_top [current_fileset] 
	# update_compile_order -fileset sources_1 
	
	# saving and closing project 
	save_project as FIFO_queue_project.xpr
	close_project 
	
} else {

	puts  
	puts ERROR: FPGA_ROOT not set 
	puts  
	puts 
	
}

