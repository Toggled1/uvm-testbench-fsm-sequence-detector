// Clock, reset, interface/DUT instances,
//checker binding, config_db, run_test()


module tb_top;

import uvm_pkg::*;

//import sd_pkg::*;
`include "uvm_macros.svh"

bit clk;
always #10 clk = ~clk;

sd_if sd_if (clk);

//dut instantiation
seq_detector dut(.bus(sd_if));


bind seq_detector sd_checker checker_inst (
    //resolve connections from DUT
	.clk(bus.clk),
	.rst_n(bus.rst_n),
	.data_in(bus.data_in),
	.detected(bus.detected),
	.state(state)
);

endmodule
