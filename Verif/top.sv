`include "ram_test_pkg.sv"
`include "ram_if.sv"
`include "ram_soc.sv"
`include "ram_chip.sv"
`include "ram_4096.v"
`include "mem_dec.v"

module top;

    // Import necessary packages and modules
    import ram_test_pkg::*;
    import uvm_pkg::*;

    // Generate clock signal
    bit clock;
    always #10 clock = !clock;

    // Instantiate 4 ram_if interface instances (in0, in1, in2, in3) with clock as input
    ram_if in0(clock);
    ram_if in1(clock);
    ram_if in2(clock);
    ram_if in3(clock);

    // Instantiate rtl ram_chip and pass the interface instances as arguments
    ram_soc DUV(
        .mif0(in0),
        .mif1(in1),
        .mif2(in2),
        .mif3(in3)
    );

    // In initial block
    initial begin
        // Set the virtual interface instances as strings vif_0, vif_1, vif_2, vif_3 using the uvm_config_db
        uvm_config_db #(virtual ram_if)::set(null, "*", "vif_0", in0);
        uvm_config_db #(virtual ram_if)::set(null, "*", "vif_1", in1);
        uvm_config_db #(virtual ram_if)::set(null, "*", "vif_2", in2);
        uvm_config_db #(virtual ram_if)::set(null, "*", "vif_3", in3);
                  
        // Call run_test
        run_test("ram_even_addr_test");
    end
  
    // Dump VCD file for waveform analysis
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule
