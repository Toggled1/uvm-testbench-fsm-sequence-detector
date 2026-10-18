

module seq_detector(
    sd_if.dut bus
);

import state_t_pkg::*;

state_t state, next_state;

//sequential part
always_ff @(posedge bus.clk or negedge bus.rst_n) begin
    if (!bus.rst_n)
        state <= NO_MATCH;
    else
        state <= next_state;
end

//combinational next_state
always_comb begin

    case (state)

        NO_MATCH: next_state = (bus.data_in) ? GOT_1 : NO_MATCH;
        GOT_1: next_state = (bus.data_in) ? GOT_1 : GOT_10;
        GOT_10: next_state = (bus.data_in) ? GOT_101 : NO_MATCH;
        GOT_101: next_state = (bus.data_in) ? GOT_1 : GOT_10;
        default: next_state = NO_MATCH;
    endcase
end


//combinational mealy output
always_comb begin

    bus.detected = 1'b0;

    case (state)
        NO_MATCH: bus.detected = 1'b0;
        GOT_1: bus.detected = 1'b0;
        GOT_10: bus.detected = 1'b0;
        GOT_101: bus.detected = (bus.data_in) ? 1'b1 : 1'b0; //assert when 1011
        default: bus.detected = 1'b0;
    endcase
end

endmodule
