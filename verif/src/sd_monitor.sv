class sd_monitor extends uvm_monitor;

    `uvm_component_utils(sd_monitor)

    virtual interface sd_if.driver vif;
    //analysis port
    uvm_analysis_port #(sd_transaction) ap;

    function new(string name = "sd_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual sd_if.driver)::get(this, "", "vif", vif))
            `uvm_fatal("SD_MONITOR", "Monitor virtual interface is not configured")
        
        ap = new("ap", this);
    endfunction

    virtual task run_phase(uvm_phase phase);

        sd_transaction tr;

        forever begin
            tr = new();
            @(negedge vif.clk);
            tr.data_in = vif.data_in;
            tr.detected = vif.detected;
            tr.rst_n = vif.rst_n;
            
            ap.write(tr);
        end
        
    endtask

endclass
