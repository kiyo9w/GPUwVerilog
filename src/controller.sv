module controller (
    input wire [2:0] opcode,         // Mã lệnh đến từ bộ giải mã
    output reg alu_enable,           // Kích hoạt ALU
    output reg reg_write,            // Kích hoạt ghi thanh ghi
    output reg mem_read,             // Kích hoạt đọc bộ nhớ
    output reg mem_write,            // Kích hoạt ghi bộ nhớ
    output reg [1:0] alu_op          // Tín hiệu chọn thao tác ALU
);

    // Define opcodes
    localparam ADD_OP  = 3'b000,
               SUB_OP  = 3'b001,
               AND_OP  = 3'b010,
               LOAD_OP = 3'b011,
               STORE_OP= 3'b100;

    always @(*) begin
        // Default values
        alu_enable = 0;
        reg_write = 0;
        mem_read = 0;
        mem_write = 0;
        alu_op = 2'b00;

        case(opcode)
            ADD_OP: begin
                alu_enable = 1;
                reg_write = 1;
                alu_op = 2'b00; // Assume 00 represents ADD operation
            end
            SUB_OP: begin
                alu_enable = 1;
                reg_write = 1;
                alu_op = 2'b01; // Assume 01 represents SUB operation
            end
            AND_OP: begin
                alu_enable = 1;
                reg_write = 1;
                alu_op = 2'b10; // Assume 10 represents AND operation
            end
            LOAD_OP: begin
                mem_read = 1;
                reg_write = 1;
            end
            STORE_OP: begin
                mem_write = 1;
            end
            default: begin
                // No operation (NOP)
            end
        endcase
    end

endmodule
