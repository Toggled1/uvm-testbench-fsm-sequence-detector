module sd_checker (
	input logic clk,
	input logic rst_n,
	input logic data_in,
	input logic detected,
	input state_t_pkg::state_t state
);

	import state_t_pkg::*;

    // all properties default to the positive edge of the clk
    default clocking cb @(posedge clk);
    endclocking



    //--------common properties----------//
	property p_no_match_0;
		disable iff (!rst_n)
		(state == NO_MATCH && !data_in) |=> (state == NO_MATCH);
	endproperty

	property p_no_match_1;
		disable iff (!rst_n)
		(state == NO_MATCH && data_in) |=> (state == GOT_1);
	endproperty

	property p_got_1_0;
		disable iff (!rst_n)
		(state == GOT_1 && !data_in) |=> (state == GOT_10);
	endproperty

	property p_got_1_1;
		disable iff (!rst_n)
		(state == GOT_1 && data_in) |=> (state == GOT_1);
	endproperty

	property p_got_10_0;
		disable iff (!rst_n)
		(state == GOT_10 && !data_in) |=> (state == NO_MATCH);
	endproperty

	property p_got_10_1;
		disable iff (!rst_n)
		(state == GOT_10 && data_in) |=> (state == GOT_101);
	endproperty

	property p_got_101_0;
		disable iff (!rst_n)
		(state == GOT_101 && !data_in) |=> (state == GOT_10);
	endproperty

	property p_got_101_1;
		disable iff (!rst_n)
		(state == GOT_101 && data_in) |=> (state == GOT_1);
	endproperty




    //--------special properties w/assertions----------//

    //reset behaves correctly (never disable)
    a_reset_sampled: assert property (
    @(posedge clk) disable iff (1'b0)
    (!rst_n) |-> (state === NO_MATCH && detected === 1'b0)
    );

    // reset should not be unknown (never disable)
	a_reset_known: assert property (
		@(posedge clk) disable iff (1'b0) !$isunknown(rst_n)
	);

    //input should not be unknown
	a_input_known: assert property (disable iff (!rst_n) !$isunknown(data_in));

    //state should not be unknown
	a_state_valid: assert property (
		disable iff (!rst_n)
		!$isunknown(state) &&
		state inside {NO_MATCH, GOT_1, GOT_10, GOT_101}
	);

    //detected only high when state == GOT_101 and data_in is high
	a_detected: assert property (
		disable iff (!rst_n)
		detected == ((state == GOT_101) && data_in)
	);



    //-------------transition coverage---------------//
	a_no_match_0: assert property (p_no_match_0);
	c_no_match_0: cover property (p_no_match_0);

	a_no_match_1: assert property (p_no_match_1);
	c_no_match_1: cover property (p_no_match_1);

	a_got_1_0: assert property (p_got_1_0);
	c_got_1_0: cover property (p_got_1_0);

	a_got_1_1: assert property (p_got_1_1);
	c_got_1_1: cover property (p_got_1_1);

	a_got_10_0: assert property (p_got_10_0);
	c_got_10_0: cover property (p_got_10_0);

	a_got_10_1: assert property (p_got_10_1);
	c_got_10_1: cover property (p_got_10_1);

	a_got_101_0: assert property (p_got_101_0);
	c_got_101_0: cover property (p_got_101_0);

	a_got_101_1: assert property (p_got_101_1);
	c_got_101_1: cover property (p_got_101_1);




    //-------------state coverage---------------//
	c_no_match: cover property (disable iff (!rst_n) state == NO_MATCH);
	c_got_1: cover property (disable iff (!rst_n) state == GOT_1);
	c_got_10: cover property (disable iff (!rst_n) state == GOT_10);
	c_got_101: cover property (disable iff (!rst_n) state == GOT_101);

endmodule

