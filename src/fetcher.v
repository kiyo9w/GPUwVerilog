// fetcher.v
`include "definitions.vh"

module fetcher (
    input [`ADDR_WIDTH-1:0] pc_in,
    output [`DATA_WIDTH-1:0] instruction,
    input [`DATA_WIDTH-1:0] instr_mem [0:15]
);
    assign instruction = instr_mem[pc_in];
endmodule
