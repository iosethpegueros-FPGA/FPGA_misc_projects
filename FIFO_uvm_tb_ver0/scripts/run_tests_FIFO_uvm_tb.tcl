

if {[info exists env(FPGA_ROOT)]} { 
	#puts "FPGA_ROOT set to $FPGA_ROOT" 
	
	set valid_tests {
		address_boundaries_test
		random_burst_test
		reset_health_test
		write_read_test
	}
	
	set testName  [lindex $argv 0]
	
	
	if {$argc != 1 || [lsearch -exact $valid_tests [lindex $argv 0]] == -1} {

    puts "ERROR: Invalid test argument."
    puts ""
    puts "Usage:"
    puts "    vivado -mode batch -source run_test.tcl -tclargs <test_name>"
    puts ""
    puts "Available tests:"

    foreach test $valid_tests {
        puts "    $test"
    }

    exit 1
	}

	
	#run all
	cd $env(FPGA_ROOT)/results/CDC_top_asyncFIFO.sim/sim_1/behav/xsim
	
	#exec 
	xsim sim_snapshot -R -testplusarg UVM_TESTNAME=$testName

} else {
	puts "" 
	puts "ERROR: FPGA_ROOT not set" 
	puts "" 
}

