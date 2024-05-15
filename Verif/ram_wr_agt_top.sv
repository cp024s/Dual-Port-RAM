class ram_wr_agt_top extends uvm_env;

   `uvm_component_utils(ram_wr_agt_top)

    ram_wr_agent agnth;
  
        extern function new(string name = "ram_wr_agt_top" , uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass
          

function ram_wr_agt_top::new(string name = "ram_wr_agt_top" , uvm_component parent);
        super.new(name,parent);
endfunction


function void ram_wr_agt_top::build_phase(uvm_phase phase);
    super.build_phase(phase);
        agnth=ram_wr_agent::type_id::create("agnth",this);
endfunction


task ram_wr_agt_top::run_phase(uvm_phase phase);
        uvm_top.print_topology;
endtask
