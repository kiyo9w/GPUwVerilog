// register_file.v
`include "definitions.vh"

module register_file (
    input clk,
    input reset,
    input write_enable,
    input [3:0] write_reg,
    input [`DATA_WIDTH-1:0] write_data,
    input [3:0] read_reg_a,
    input [3:0] read_reg_b,
    output [`DATA_WIDTH-1:0] read_data_a,
    output [`DATA_WIDTH-1:0] read_data_b
);
    // Register array
    reg [`DATA_WIDTH-1:0] regs [0:`REG_COUNT-1];

    // Read ports
    assign read_data_a = regs[read_reg_a];
    assign read_data_b = regs[read_reg_b];

    // Write port
    always @(posedge clk) begin
        if (write_enable) begin
            regs[write_reg] <= write_data;
        end
    end

    // Optional: Reset registers
    integer i;
    always @(posedge reset) begin
        if (reset) begin
            for (i = 0; i < `REG_COUNT; i = i + 1) begin
                regs[i] <= 0;
            end
        end
    end

endmodule
