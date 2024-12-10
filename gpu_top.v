// gpu_top.v
`include "definitions.vh"

module gpu_top (
    input clk,
    input reset
);
    wire [`ADDR_WIDTH-1:0] pc_out;
    wire [15:0] instruction;
    wire halt;

    compute_core compute_core_inst (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .pc_out(pc_out),
        .halt(halt)
    );

    fetcher fetcher_inst (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_out),
        .instruction(instruction)
    );

endmodule
