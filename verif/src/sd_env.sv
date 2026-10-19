class sd_env extends uvm_env;

    `uvm_component_utils(sd_env)

    sd_agent m_agent;
    sd_scoreboard m_scoreboard;

    function new(string name = "sd_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_agent = sd_agent::type_id::create("m_agent", this);
        m_scoreboard = sd_scoreboard::type_id::create("m_scoreboard", this);
    endfunction
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        //connect the monitor to the scoreboard

        m_agent.m_monitor.ap.connect(m_scoreboard.ap_imp);
    endfunction
endclass
