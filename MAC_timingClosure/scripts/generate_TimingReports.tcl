
	
	
# if {[catch {open_project $env(FPGA_ROOT)/results/MAC_TimingClosure.xpr} errorstring]} {	
	# puts " MAC_TimingClosure: error opening project"
# } else {
	# puts "MAC_TimingClosure: exit"
# }




if {[info exists env(FPGA_ROOT)]} { 
	puts "running timing reports"
	
	set prj_type  [lindex $argv 0]
	
	open_project "$env(FPGA_ROOT)/results/MAC_${prj_type}_TimingClosure/MAC_${prj_type}_TimingClosure.xpr"

	report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -routable_nets -name timing_${prj_type}
	
	wait_on_run timing_${prj_type}
	
	close_project

} else {

	puts "" 
	puts "ERROR: FPGA_ROOT not set" 
	puts "" 

}
