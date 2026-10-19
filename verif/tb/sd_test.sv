class sd_test extends uvm_test;

    `uvm_component_utils(sd_test)

    sd_env m_env;

    function new(string name = "sd_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_env = sd_env::type_id::create("m_env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
    
        sd_sequence seq = sd_sequence::type_id::create("seq");
        //start sequence on the agent's sequencer!
        phase.raise_objection(this);
        phase.phase_done.set_drain_time(this, 20ns);
        seq.start(m_env.m_agent.m_sequencer);
        phase.drop_objection(this);
    endtask
endclass
