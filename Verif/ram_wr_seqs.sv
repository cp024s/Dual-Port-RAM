class ram_wbase_seq extends uvm_sequence #(write_xtn);

    `uvm_object_utils(ram_wbase_seq)
  
    // Constructor
    extern function new(string name ="ram_wbase_seq");

endclass

function ram_wbase_seq::new(string name ="ram_wbase_seq");
    super.new(name);
endfunction

class ram_rand_wr_xtns extends ram_wbase_seq;

    `uvm_object_utils(ram_rand_wr_xtns)

    // Constructor
    extern function new(string name ="ram_rand_wr_xtns");

    // Body task
    extern task body();

endclass

function ram_rand_wr_xtns::new(string name = "ram_rand_wr_xtns");
    super.new(name);
endfunction

task ram_rand_wr_xtns::body();
    // Generate 10 transactions of type write_xtn
    // Create req instance
    // Start item(req)
    // Assert for randomization
    // Finish item(req)
    repeat(10)
    begin
        req=write_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize());
        finish_item(req);
    end
endtask

class ram_single_addr_wr_xtns extends ram_wbase_seq;

    `uvm_object_utils(ram_single_addr_wr_xtns)

    // Constructor
    extern function new(string name ="ram_single_addr_wr_xtns");

    // Body task
    extern task body();

endclass

function ram_single_addr_wr_xtns::new(string name = "ram_single_addr_wr_xtns");
    super.new(name);
endfunction

task ram_single_addr_wr_xtns::body();
    // Generate 10 sequence items with address always equal to 55
    // Create req, start item, assert for randomization with inline constraint (with), finish item inside repeat's begin-end block
    repeat(10)
    begin
        req=write_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {address==55;} );
        finish_item(req);
    end
endtask

class ram_ten_wr_xtns extends ram_wbase_seq;

    `uvm_object_utils(ram_ten_wr_xtns)

    // Constructor
    extern function new(string name ="ram_ten_wr_xtns");

    // Body task
    extern task body();
endclass

function ram_ten_wr_xtns::new(string name = "ram_ten_wr_xtns");
    super.new(name);
endfunction

task ram_ten_wr_xtns::body();
    // Write the random data on memory address locations consecutively from 0 to 9
    // Create req, start item, assert for randomization with inline constraint (with), finish item inside repeat's begin-end block
    int addrseq;
    addrseq=0;
    repeat(10)
    begin
        req=write_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {address==addrseq; write==1'b1;} );
        finish_item(req);
        addrseq=addrseq + 1;
    end
endtask

class ram_odd_wr_xtns extends ram_wbase_seq;

    `uvm_object_utils(ram_odd_wr_xtns)

    // Constructor
    extern function new(string name ="ram_odd_wr_xtns");

    // Body task
    extern task body();
      
endclass

function ram_odd_wr_xtns::new(string name = "ram_odd_wr_xtns");
    super.new(name);
endfunction

task ram_odd_wr_xtns::body();
    // Write the 10 random data in odd memory address locations
    // Create req, start item, assert for randomization with inline constraint (with), finish item inside repeat's begin-end block
    int addrseq;
    addrseq=0;
    repeat(10)
    begin
        req=write_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {address==(2*addrseq+1);write==1'b1;} );
        finish_item(req);
        addrseq=addrseq + 1;
    end
endtask

class ram_even_wr_xtns extends ram_wbase_seq;

    `uvm_object_utils(ram_even_wr_xtns)

    // Constructor
    extern function new(string name ="ram_even_wr_xtns");

    // Body task
    extern task body();
      
endclass

function ram_even_wr_xtns::new(string name = "ram_even_wr_xtns");
    super.new(name);
endfunction

task ram_even_wr_xtns::body();
    // Write the 10 random data in even memory address locations
    // Create req, start item, assert for randomization with inline constraint (with), finish item inside repeat's begin-end block
    int addrseq;
    addrseq=0;
    repeat(10)
    begin
        req=write_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {address==(2*addrseq);write==1'b1;} );
        finish_item(req);
        addrseq=addrseq + 1;
    end
endtask
