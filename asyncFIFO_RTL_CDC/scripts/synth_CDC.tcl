

if {[info exists env(FPGA_ROOT)]} { 
	#puts "FPGA_ROOT set to $FPGA_ROOT" 
	
	open_project $env(FPGA_ROOT)/results/CDC_top_asyncFIFO.xpr
	

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
	
	reset_project
	# reset_run synth_1
	
	launch_runs synth_1 -jobs 8 
	
	wait_on_run synth_1
	
	close_project

} else {
	puts "" 
	puts "ERROR: FPGA_ROOT not set" 
	puts "" 
}

