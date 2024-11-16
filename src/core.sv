module core (
    input wire clk,                      // Xung nhịp
    input wire reset,                    // Tín hiệu reset
    input wire [7:0] program_memory[0:255], // Bộ nhớ chương trình
    output reg [7:0] result              // Kết quả cuối cùng từ ALU
);

    wire [7:0] instruction;              // Lệnh được tìm nạp
    wire fetch_valid;                    // Tín hiệu hợp lệ từ fetcher

    wire [2:0] opcode;                   // Mã lệnh từ decoder
    wire [3:0] src1, src2, dest;         // Các toán hạng và đích

    wire alu_enable, reg_write, mem_read, mem_write;
    wire [1:0] alu_op;

    reg [7:0] registers[0:15];           // Tập hợp thanh ghi
    wire [7:0] alu_out;                  // Kết quả từ ALU

    // Fetcher Instance
    fetcher fetch_inst (
        .clk(clk),
        .reset(reset),
        .program_memory(program_memory),
        .start_fetch(1),
        .instruction(instruction),
        .fetch_valid(fetch_valid)
    );

    // Decoder Instance
    decoder decode_inst (
        .instruction(instruction),
        .opcode(opcode),
        .src1(src1),
        .src2(src2),
        .dest(dest),
        .valid()
    );

    // Controller Instance
    controller control_inst (
        .opcode(opcode),
        .alu_enable(alu_enable),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_op(alu_op)
    );

    // ALU Instance
    alu alu_inst (
        .clk(clk),
        .reset(reset),
        .enable(alu_enable),
        .rs(registers[src1]),
        .rt(registers[src2]),
        .alu_op(alu_op),
        .alu_out(alu_out)
    );

    // Register Write-back logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            integer i;
            for (i = 0; i < 16; i = i + 1) begin
                registers[i] <= 8'b0;
            end
            result <= 8'b0;
        end else if (reg_write) begin
            registers[dest] <= alu_out;
            result <= alu_out;
        end
    end
endmodule
