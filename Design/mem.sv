module dual_mem (
    input clk,         // RAM Clock
    input mem_en,      // Memory Enable
    input op_en,       // Operation Enable
    input [63:0] data_in,       // Data Input
    input [9:0] rd_address,     // Read Address
    input [9:0] wr_address,     // Write Address
    input read,        // Read Control
    input write,       // Write Control
    output reg [63:0] data_out   // Data Output
);

    parameter RAM_WIDTH = 64;
    parameter RAM_DEPTH = 1024;
    parameter ADDR_SIZE = 10;

    // Memory
    reg [63:0] memory [0:RAM_DEPTH-1];

    always @ (posedge clk) begin
        if (mem_en) begin
            if (write) begin
                memory[wr_address] <= data_in;
            end
        end
    end

    always @ (posedge clk) begin
        if (op_en) begin
            if (read) begin
                data_out <= memory[rd_address];
            end
        end else begin
            data_out <= 64'bZ; // High-impedance output when operation is disabled
        end
    end

endmodule
