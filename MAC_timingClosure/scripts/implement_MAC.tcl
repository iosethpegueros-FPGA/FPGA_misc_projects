

if {[info exists env(FPGA_ROOT)]} { 
	#puts "FPGA_ROOT set to $FPGA_ROOT" 
	
	set prj_type  [lindex $argv 0]
	
	open_project "$env(FPGA_ROOT)/results/MAC_${prj_type}_TimingClosure/MAC_${prj_type}_TimingClosure.xpr"
	
	
	# if {[catch {launch_runs synth_1 -jobs 8} errorstring]} {
		# puts "BUILD_MAC_TCL:synthesis Failed  : $errorstring"
		# close_project
		# return 1
	# }else{
		# puts "BUILD_MAC_TCL: synthesis PASS"
		# close_project
		
	# }
	
	
	## optionall clean synthesis results 
	## reset_run synth_1
	
	reset_run impl_1

	launch_runs impl_1 -jobs 8 
	
	wait_on_run impl_1
	
	open_run impl_1
	
	# report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -routable_nets -name timing_1 
	
	report_timing_summary -file $env(FPGA_ROOT)/results/post_route_timing_summary.rpt
	
	# wait_on_run timing_1
	
	close_project

} else {
	puts "" 
	puts "ERROR: FPGA_ROOT not set" 
	puts "" 
}

