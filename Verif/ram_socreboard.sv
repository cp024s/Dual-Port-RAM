// ---------------------- SCORE BOARD CLASS -----------------------------

// CLASS DESCRIPTION
class ram_scoreboard extends uvm_scoreboard;
  
    // Define FIFOs for storing read and write transactions
    uvm_tlm_analysis_fifo #(read_xtn) fifo_rdh;
    uvm_tlm_analysis_fifo #(write_xtn) fifo_wrh;

    // Variables to keep track of transaction counts and comparison results
    int  wr_xtns_in, rd_xtns_in, xtns_compared, xtns_dropped;

    // Factory registration macro
    `uvm_component_utils(ram_scoreboard)

    // Reference model for the RAM data storage
    logic [63:0] ref_data [bit[31:0]];

    // Variables to hold transaction data for comparison
    write_xtn wr_data;
    read_xtn rd_data;

    // Variables for storing coverage data
    write_xtn write_cov_data;
    read_xtn read_cov_data;

    // Covergroup for functional coverage of write transactions
    covergroup ram_fcov1;
      
        option.per_instance=1;
      
        //ADDRESS coverpoint for write transactions
        WR_ADD : coverpoint write_cov_data.address {
            bins low = {[0:100]};
            bins mid1 = {[101:511]};
            bins mid2 = {[512:1023]};
            bins mid3 = {[1024:1535]};
            bins mid4 = {[1536:2047]};
            bins mid5 = {[2048:2559]};
            bins mid6 = {[2560:3071]};
            bins mid7 = {[3072:3583]};
            bins mid8 = {[3584:4094]};
            bins high = {[3996:4095]};
        }

        //DATA coverpoint for write transactions
        DATA : coverpoint write_cov_data.data {
            bins low  =  {[0:64'h0000_0000_0000_ffff]};
            bins mid1 = {[64'h0000_0000_0001_0000:64'h0000_0000_ffff_ffff]};
            bins mid2 = {[64'h0000_0001_0000_0000:64'h0000_ffff_ffff_ffff]};
            bins high = {[64'h0001_0000_0000_0000:64'h0000_ffff_ffff_ffff]};
        }

        // WRITE coverpoint for write transactions
        WR : coverpoint write_cov_data.write {
            bins wr_bin = {1};
        }

        // Cross coverage between ADDRESS, DATA, and WRITE for write transactions
        WRITE_FC : cross WR, WR_ADD, DATA;

    endgroup

    // Covergroup for functional coverage of read transactions
    covergroup ram_fcov2;
      
        option.per_instance=1;
      
        //ADDRESS coverpoint for read transactions
        RD_ADD : coverpoint read_cov_data.address {
            bins low = {[0:100]};
            bins mid1 = {[101:511]};
            bins mid2 = {[512:1023]};
            bins mid3 = {[1024:1535]};
            bins mid4 = {[1536:2047]};
            bins mid5 = {[2048:2559]};
            bins mid6 = {[2560:3071]};
            bins mid7 = {[3072:3583]};
            bins mid8 = {[3584:3995]};
            bins high = {[3996:4095]};
        }

        //DATA coverpoint for read transactions
        DATA : coverpoint read_cov_data.data {
            bins low = {[0:64'h0000_0000_0000_ffff]};
            bins mid1 = {[64'h0000_0000_0001_0000:64'h0000_0000_ffff_ffff]};
            bins mid2 = {[64'h0000_0001_0000_0000:64'h0000_ffff_ffff_ffff]};
            bins high = {[64'h0001_0000_0000_0000:64'h0000_ffff_ffff_ffff]};
        }

        // READ coverpoint for read transactions
        RD : coverpoint read_cov_data.read {
            bins rd_bin = {1};
        }

        // Cross coverage between RD_ADD, DATA, and READ for read transactions
        READ_FC : cross RD, RD_ADD, DATA;

    endgroup

    // Methods
    // Standard UVM Methods:
    extern function new(string name, uvm_component parent);
    extern function void mem_write(write_xtn wd);
    extern function bit mem_read(ref read_xtn rd);
    extern task run_phase(uvm_phase phase);
    extern function void check_data(read_xtn rd);
    extern function void report_phase(uvm_phase phase);

endclass

//-----------------  constructor new method  -------------------//

// Constructor method for initializing the scoreboard
function ram_scoreboard::new(string name, uvm_component parent);
  
    super.new(name, parent);
    // Create FIFOs for read and write transactions
    fifo_rdh = new("fifo_rdh", this);
    fifo_wrh = new("fifo_wrh", this);
  
    // Create instances of covergroups ram_fcov1 & ram_fcov2
    ram_fcov1 = new;
    ram_fcov2 = new;

endfunction

//-----------------  mem_write() method  -------------------//

// Method to handle write transactions and update reference model
function void ram_scoreboard::mem_write(write_xtn wd);
  
    if (wd.write)
    begin
        // Update reference model with write transaction data
        ref_data[wd.address] = wd.data;
        // Log write transaction information
        `uvm_info("MEM Write Function", $psprintf("Address = %h", wd.address), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Write Transaction from Write agt_top \n %s", wd.sprint()), UVM_HIGH)
        // Increment write transaction count
        wr_xtns_in ++;
    end
endfunction : mem_write

//-----------------  mem_read() method  -------------------//

// Method to handle read transactions and compare with reference model
function bit ram_scoreboard::mem_read(ref read_xtn rd);
  
    if (rd.read)
    begin
        // Log read transaction information
        `uvm_info(get_type_name(), $sformatf("Read Transaction from Read agt_top \n %s", rd.sprint()), UVM_HIGH)
        `uvm_info("MEM Function", $psprintf("Address = %h", rd.address), UVM_LOW)

        if (ref_data.exists(rd.address))
        begin
            // If data exists in reference model, update read transaction data
            rd.data = ref_data[rd.address];
            // Increment read transaction count
            rd_xtns_in ++;
            return 1;
        end
        else
        begin
            // If data doesn't exist in reference model, log dropped transaction
            xtns_dropped ++;
            return 0;
        end 
    end
endfunction : mem_read

//-----------------  run() phase  -------------------//

// Method to handle the run phase of the scoreboard
task ram_scoreboard::run_phase(uvm_phase phase);
    fork
        // Loop for handling write transactions
        forever
        begin
            // Get write transaction from FIFO
            fifo_wrh.get(wr_data);
            // Process write transaction
            mem_write(wr_data);
            `uvm_info("WRITE SB","write data" , UVM_LOW)
            wr_data.print;
            // Update coverage data
            write_cov_data = wr_data;
            ram_fcov1.sample();
        end
      
        // Loop for handling read transactions
        forever
        begin
            // Get read transaction from FIFO
            fifo_rdh.get(rd_data);
            `uvm_info("READ SB", "read data" , UVM_LOW)
            rd_data.print;
            // Check read transaction data
            check_data(rd_data);
        end
    join
endtask

//-----------------  check_data() method  -------------------//

// Method to check read transaction data against reference model
function void ram_scoreboard::check_data(read_xtn rd);
  
    read_xtn ref_xtn;
  
    // Create a clone of the read transaction
    $cast(ref_xtn, rd.clone());

    // Log read transaction from reference model
    `uvm_info(get_type_name(), $sformatf("Read Transaction from Memory_Model \n %s", ref_xtn.sprint()), UVM_HIGH)
 
    // If read transaction matches reference model
    if (mem_read(ref_xtn))
    begin
        // Compare read transaction with reference model
        if (rd.compare(ref_xtn))
        begin
            // Log successful data match
            `uvm_info(get_type_name(), $sformatf("Scoreboard - Data Match successful"), UVM_MEDIUM)
            // Increment transaction comparison count
            xtns_compared++ ;
        end
        else
        begin
            // Log data mismatch error
            `uvm_error(get_type_name(), $sformatf("\n Scoreboard Error [Data Mismatch]: \n Received Transaction:\n %s \n Expected Transaction: \n %s",
                rd.sprint(), ref_xtn.sprint()))
        end
    end
    else
    begin
        // Log if no data is written at the specified address
        uvm_report_info(get_type_name(), $psprintf("No Data written in the address=%d \n %s", rd.address, rd.sprint()));
    end
                  
    // Update coverage data
    read_cov_data = rd;
    ram_fcov2.sample();
                  
endfunction

//-----------------  report_phase() method  -------------------//

// Method to handle the report phase of the scoreboard
function void ram_scoreboard::report_phase(uvm_phase phase);
  
   // Display the final report of the test using scoreboard statistics
   `uvm_info(get_type_name(), $sformatf("MSTB: Simulation Report from ScoreBoard \n Number of Read Transactions from Read agt_top : %0d \n Number of Write Transactions from write agt_top : %0d \n Number of Read Transactions Dropped : %0d \n Number of Read Transactions compared : %0d \n\n", rd_xtns_in, wr_xtns_in, xtns_dropped, xtns_compared), UVM_LOW)
  
endfunction
