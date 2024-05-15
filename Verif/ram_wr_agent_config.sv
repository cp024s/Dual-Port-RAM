// ----------------------- RAM WRITE AGENT CONFIG ------------------------

class ram_wr_agent_config extends uvm_object;
        `uvm_object_utils(ram_wr_agent_config)

        uvm_active_passive_enum is_active = UVM_ACTIVE;

        virtual ram_if vif;
        static int mon_rcvd_xtn_cnt = 0;
        static int drv_data_sent_cnt = 0;


        // Standard UVM Methods:
        extern function new(string name = "ram_wr_agent_config");
endclass: ram_wr_agent_config
          
//-----------------  constructor new method  -------------------//
function ram_wr_agent_config::new(string name = "ram_wr_agent_config");
  super.new(name);
endfunction
