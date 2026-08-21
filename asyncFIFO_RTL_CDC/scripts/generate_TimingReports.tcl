
	
	
# if {[catch {open_project $env(FPGA_ROOT)/results/CDC_top_asyncFIFO.xpr} errorstring]} {	
	# puts " CDC_top_asyncFIFO: error opening project"
# } else {
	# puts "CDC_top_asyncFIFO: exit"
# }




if {[info exists env(FPGA_ROOT)]} { 
	puts "running timing reports"
	
	open_project $env(FPGA_ROOT)/results/CDC_top_asyncFIFO.xpr

	# report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -routable_nets -name timing_1 
	
	# wait_on_run timing_1
	
	close_project

} else {

	puts "" 
	puts "ERROR: FPGA_ROOT not set" 
	puts "" 

}
