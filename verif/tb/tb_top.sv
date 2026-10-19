// Clock, reset, interface/DUT instances,
//checker binding, config_db, run_test()


module tb_top;

timeunit 1ns;
timeprecision 1ps;

import uvm_pkg::*;
import sd_pkg::*;

//import sd_pkg::*;
`include "uvm_macros.svh"

bit clk;
always #10 clk = ~clk;

sd_if vif (clk);


//startup sequence
initial begin
	vif.rst_n = 0;
	#25;
	vif.rst_n = 1;
end



initial begin
	uvm_config_db #(virtual sd_if.driver)::set(null, "uvm_test_top.*", "vif", vif.driver);
	uvm_config_db #(virtual sd_if.monitor)::set(null, "uvm_test_top.*", "vif", vif.monitor);


    //run sd_test
    run_test("sd_test");
end

//dut instantiation
seq_detector dut(.bus(vif));


bind seq_detector sd_checker checker_inst (
    //resolve connections from DUT
	.clk(bus.clk),
	.rst_n(bus.rst_n),
	.data_in(bus.data_in),
	.detected(bus.detected),
	.state(state)
);

endmodule
