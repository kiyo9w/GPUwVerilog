// alu.v
`include "definitions.vh"


module alu (
    input [3:0] opcode,
    input [`DATA_WIDTH-1:0] operand_a,
    input [`DATA_WIDTH-1:0] operand_b,
    input [7:0] immediate,
    output reg [`DATA_WIDTH-1:0] result,
    output reg cmp_flag
);
    always @(*) begin
        cmp_flag = 0;
        case (opcode)
            `OP_ADD: result = operand_a + operand_b + immediate;
            `OP_SUB: result = operand_a - operand_b - immediate;
            `OP_MUL: result = operand_a * operand_b;
            `OP_CMP: begin
                result = 0;
                if (operand_a < operand_b)
                    cmp_flag = 1;
                else
                    cmp_flag = 0;
            end
            default: result = 0;
        endcase
    end
endmodule
