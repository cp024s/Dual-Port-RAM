// ------------------------------- RAM WRITE AGENT ----------------------------------

class ram_wr_agent extends uvm_agent;
    `uvm_component_utils(ram_wr_agent)

    ram_wr_agent_config m_cfg;

    ram_wr_monitor monh;
    ram_wr_sequencer seqrh;
    ram_wr_driver drvh;


    // Standard UVM Methods :
    extern function new(string name = "ram_wr_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : ram_wr_agent
          
//-----------------  constructor new method  -------------------//
function ram_wr_agent::new(string name = "ram_wr_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction

//-----------------  build() phase method  -------------------//
function void ram_wr_agent::build_phase(uvm_phase phase);

    super.build_phase(phase);
  
    // get the config object using uvm_config_db
    if(!uvm_config_db #(ram_wr_agent_config)::get(this,"","ram_wr_agent_config",m_cfg))
        `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
    monh=ram_wr_monitor::type_id::create("monh",this);
  
    if(m_cfg.is_active==UVM_ACTIVE)
        begin
            drvh=ram_wr_driver::type_id::create("drvh",this);
            seqrh=ram_wr_sequencer::type_id::create("seqrh",this);
        end

endfunction

//-----------------  connect() phase method  -------------------//
function void ram_wr_agent::connect_phase(uvm_phase phase);
    if(m_cfg.is_active==UVM_ACTIVE)
        begin
            drvh.seq_item_port.connect(seqrh.seq_item_export);
        end
endfunction
