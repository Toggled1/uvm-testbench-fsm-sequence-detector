class sd_sequencer extends uvm_sequencer #(sd_transaction);

    `uvm_component_utils(sd_sequencer)

    function new(string name = "sd_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass
