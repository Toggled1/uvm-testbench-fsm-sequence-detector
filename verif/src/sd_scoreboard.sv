class sd_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(sd_scoreboard)

    uvm_analysis_imp #(sd_transaction, sd_scoreboard) ap_imp = new("ap_imp", this);

    logic [3:0] history;
    logic detected_in_model;

    function new(string name = "sd_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void write(sd_transaction tr);
        `uvm_info(get_type_name(), $sformatf("Received transaction: %0s", tr.convert2string()), UVM_MEDIUM)

        //shift and load shift register history model
        history = history << 1;
        history[0] = tr.data_in;

        detected_in_model = 0;
        //check for if sequence "1011" has been detected
        if (history == 4'b1011) begin
            `uvm_info(get_type_name(), "Sequence 1011 detected in model", UVM_MEDIUM)
            detected_in_model = 1; //mark that sequence should be detected
        end

        if (detected_in_model != tr.detected) begin
            `uvm_error(get_type_name(), "Mismatch between model and DUT detection")
        end
        else begin
            `uvm_info(get_type_name(), "Model and DUT detection match", UVM_MEDIUM)
        end

    endfunction
endclass
