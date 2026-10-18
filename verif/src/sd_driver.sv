class sd_driver extends uvm_driver #(sd_transaction);

    `uvm_component_utils(sd_driver)
    virtual interface sd_if.driver vif;

    function new(string name = "sd_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual sd_if.driver)::get(this, "", "vif", vif))
            `uvm_fatal("SD_DRIVER", "Driver virtual interface is not configured")
    endfunction

    virtual task run_phase(uvm_phase phase);
        sd_transaction tr;

        super.run_phase(phase);
        vif.data_in <= 1'b0;

        forever begin

            seq_item_port.get_next_item(tr);


            @(negedge vif.clk);
            //Drive data_in
            vif.data_in <= tr.data_in;

            @(posedge vif.clk);
            // Indicate the item is done
            seq_item_port.item_done();
        end
    endtask


endclass
