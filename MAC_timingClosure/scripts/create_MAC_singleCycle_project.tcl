
#print and validate env variable 
puts "running " 
puts $env(FPGA_ROOT)


if {[info exists env(FPGA_ROOT)]} { 
	#puts "FPGA_ROOT set to $env(FPGA_ROOT)" 

	#project for PYNCQ Z1 device
	create_project -force MAC_singleCycle_TimingClosure $env(FPGA_ROOT)/results/MAC_singleCycle_TimingClosure -part xc7z020clg400-1 

	add_files -norecurse -scan_for_includes $env(FPGA_ROOT)/rtl/adder.v
	add_files -norecurse -scan_for_includes $env(FPGA_ROOT)/rtl/MAC_top_noPipe.sv
	add_files -norecurse -scan_for_includes $env(FPGA_ROOT)/rtl/multiplier.v
	
	add_files    -fileset constrs_1 -norecurse $env(FPGA_ROOT)/constraints/MAC_top_constraints.xdc 
	import_files -fileset constrs_1            $env(FPGA_ROOT)/constraints/MAC_top_constraints.xdc 
	
	set_property top MAC_top_noPipe [current_fileset] 
	update_compile_order -fileset sources_1 
	
	#save_project as MAC_singleCycle_TimingClosure.xpr
	
	close_project 
	
} else {

	puts "" 
	puts "ERROR: FPGA_ROOT not set" 
	puts "" 
	puts ""
	
}

