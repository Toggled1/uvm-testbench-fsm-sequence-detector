class sd_transaction extends uvm_sequence_item;

    rand    logic data_in;
            logic detected;
            logic rst_n;

    `uvm_object_utils_begin(sd_transaction)
        `uvm_field_int(data_in, UVM_ALL_ON)
        `uvm_field_int(detected, UVM_ALL_ON)
        `uvm_field_int(rst_n, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "sd_transaction");
        super.new(name);
    endfunction
endclass
