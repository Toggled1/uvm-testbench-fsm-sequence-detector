class sd_agent extends uvm_agent;

    `uvm_component_utils(sd_agent)

    sd_sequencer m_sequencer;
    sd_driver m_driver;
    sd_monitor m_monitor;

    function new(string name = "sd_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(get_is_active()) begin
            m_sequencer = sd_sequencer::type_id::create("m_sequencer", this);
            m_driver = sd_driver::type_id::create("m_driver", this);
        end
        
        m_monitor = sd_monitor::type_id::create("m_monitor", this);
    endfunction


    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        //Connect driver to sequencer
        if(get_is_active()) begin
            m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
        end

    endfunction



endclass
