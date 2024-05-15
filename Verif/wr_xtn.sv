class write_xtn extends uvm_sequence_item;

    `uvm_object_utils(write_xtn)

    rand bit[`RAM_WIDTH-1 : 0] data;
    rand bit[`ADDR_SIZE-1 : 0] address;
    rand bit write;
    rand addr_t xtn_type;
    rand bit[63:0] xtn_delay;

    constraint a{ 
        data inside {[20:90]};
        address inside {[0:200]};
        xtn_type dist {BAD_XTN:=2 , GOOD_XTN:=30};
    }

    extern function new(string name = "write_xtn");
    extern function void do_copy(uvm_object rhs);
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function void do_print(uvm_printer printer);
    extern function void post_randomize();

endclass: write_xtn

function write_xtn::new(string name = "write_xtn");
    super.new(name);
endfunction:new

function void write_xtn::do_copy(uvm_object rhs);
    write_xtn rhs_;
    if (!$cast(rhs_, rhs))
        `uvm_fatal("do_copy", "cast of the rhs object failed")
    super.do_copy(rhs);
    data = rhs_.data;
    address = rhs_.address;
    write = rhs_.write;
    xtn_type = rhs_.xtn_type;
    xtn_delay = rhs_.xtn_delay;
endfunction: do_copy

function bit write_xtn::do_compare(uvm_object rhs, uvm_comparer comparer);
    write_xtn rhs_;
    if (!$cast(rhs_, rhs))
        `uvm_fatal("do_compare", "cast of the rhs object failed")
    return super.do_compare(rhs, comparer) &&
        data == rhs_.data &&
        address == rhs_.address &&
        write == rhs_.write &&
        xtn_type == rhs_.xtn_type &&
        xtn_delay == rhs_.xtn_delay;
endfunction: do_compare

function void write_xtn::do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("data", this.data, 64, UVM_DEC);
    printer.print_field("address", this.address, 12, UVM_DEC);
    printer.print_field("write", this.write, '1, UVM_DEC);
    printer.print_field("xtn_delay", this.xtn_delay, 65, UVM_DEC);
    printer.print_generic("xtn_type", "addr_t", $bits(xtn_type), xtn_type.name);
endfunction: do_print

function void write_xtn::post_randomize();
    if (xtn_type == BAD_XTN)
        this.address = 6000;
endfunction: post_randomize
