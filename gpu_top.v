// gpu_top.v
`include "definitions.vh"

module gpu_top (
    input clk,
    input reset
);
    // Wires to connect modules
    wire [`ADDR_WIDTH-1:0] pc_out;
    wire [15:0] instruction;
    wire halt;

    // Instantiate Compute Core
    compute_core compute_core_inst (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .pc_out(pc_out),
        .halt(halt)
    );

    // Instantiate Fetcher
    fetcher fetcher_inst (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_out),
        .instruction(instruction)
    );

endmodule
