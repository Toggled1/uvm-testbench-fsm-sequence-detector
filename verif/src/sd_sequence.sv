class sd_sequence extends uvm_sequence #(sd_transaction);

    `uvm_object_utils(sd_sequence)

    function new(string name = "sd_sequence");
        super.new(name);
    endfunction

    virtual task pre_body();
        uvm_phase starting_phase = get_starting_phase();
        if (starting_phase != null)
            starting_phase.raise_objection(this);
    endtask


    virtual task body();

        repeat(67) begin

            req = sd_transaction::type_id::create("req");
            start_item(req);
            if (!req.randomize()) `uvm_fatal("SD_SEQ", "Randomization failed")
            finish_item(req);

        end

    endtask




    virtual task post_body();
        uvm_phase ending_phase = get_ending_phase();
        if (ending_phase != null)
            ending_phase.drop_objection(this);
    endtask

endclass
