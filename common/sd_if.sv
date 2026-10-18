
interface sd_if (input bit clk);

    logic rst_n;
    logic data_in;
    logic detected;

    modport dut (
        input clk, rst_n, data_in,
        output detected
    );

    modport driver (
        input clk, detected,
        output rst_n, data_in
    );

    modport monitor (
        input clk, rst_n, data_in, detected
    );
endinterface
