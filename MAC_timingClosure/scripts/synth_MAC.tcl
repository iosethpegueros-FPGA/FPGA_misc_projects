

if {[info exists env(FPGA_ROOT)]} { 
	# # #puts "FPGA_ROOT set to $FPGA_ROOT" 
	
	set prj_type  [lindex $argv 0]
	
	
	# open_project $env(FPGA_ROOT)/MAC_${prj_type}_TimingClosure.xpr
	
	open_project "$env(FPGA_ROOT)/results/MAC_${prj_type}_TimingClosure/MAC_${prj_type}_TimingClosure.xpr"

	# if {[catch {launch_runs synth_1 -jobs 8} errorstring]} {
		# puts "BUILD_MAC_TCL:synthesis Failed  : $errorstring"
		# close_project
		# return 1
	# }else{
		# puts "BUILD_MAC_TCL: synthesis PASS"
		# close_project
		
	# }
	
	#optionall clean synthesis results 
	reset_run synth_1
	
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

