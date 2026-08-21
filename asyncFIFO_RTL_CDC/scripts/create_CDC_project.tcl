
#print and validate env variable 
puts "running " 
puts $env(FPGA_ROOT)


if {[info exists env(FPGA_ROOT)]} { 
	#puts "FPGA_ROOT set to $env(FPGA_ROOT)" 

	#project for PYNCQ Z1 device
	create_project -force CDC_top_asyncFIFO $env(FPGA_ROOT)/results -part xc7z020clg400-1 

	#adding RTL modules
	add_files -norecurse -scan_for_includes $env(FPGA_ROOT)/rtl/CDC_top.sv

	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/CDC_top_tb_Automatic.sv
	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/FIFO_queue_class.svh
	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/FIFO_queue_tester.svh
	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/fifo_data_hex.txt
	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/FIFO_queue_bfm.sv
	add_files -fileset sim_1 -norecurse $env(FPGA_ROOT)/tb/FIFO_queue_package.sv
	
	#adding include paths
	set_property include_dirs [list "$env(FPGA_ROOT)/tb/"] [get_filesets sim_1]

	#adding constraintse
	add_files    -fileset constrs_1 -norecurse $env(FPGA_ROOT)/constraints/CDC_top.xdc
#	import_files -fileset constrs_1            $env(FPGA_ROOT)/constraints/CDC_top.xdc	

	set_property -name {xsim.elaborate.debug_level} -value {all} -objects [get_filesets sim_1]
	
	# seting top module 
	set_property top CDC_top [current_fileset] 
	update_compile_order -fileset sources_1 
	
	# saving and closing project 
	#save_project as $env(FPGA_ROOT)/results/CDC_top_asyncFIFO_project.xpr  // this one stopped working for windows. no idea why. updates maybe
	close_project 
	
} else {

	puts "" 
	puts "ERROR: FPGA_ROOT not set" 
	puts "" 
	puts ""
	
}

