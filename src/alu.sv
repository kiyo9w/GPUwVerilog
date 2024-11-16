module alu (
    input  wire [7:0] A,          // Operand A
    input  wire [7:0] B,          // Operand B
    input  wire [2:0] opcode,     // Opcode để chọn phép toán
    output reg [7:0] result,      // Kết quả đầu ra
    output reg zero_flag          // Cờ bằng không
);

    // Định nghĩa mã lệnh cho các phép toán
    localparam ADD = 3'b000,
               SUB = 3'b001,
               AND = 3'b010,
               OR  = 3'b011,
               XOR = 3'b100,
               NOT = 3'b101, // Chỉ trên A
               SL  = 3'b110, // Shift Left
               SR  = 3'b111; // Shift Right

    always @(*) begin
        case (opcode)
            ADD: result = A + B;            // Cộng
            SUB: result = A - B;            // Trừ
            AND: result = A & B;            // AND
            OR:  result = A | B;            // OR
            XOR: result = A ^ B;            // XOR
            NOT: result = ~A;               // NOT
            SL:  result = A << 1;           // Dịch trái
            SR:  result = A >> 1;           // Dịch phải
            default: result = 8'b0;         // Mặc định
        endcase
        
        // Thiết lập cờ zero_flag
        zero_flag = (result == 8'b0);
    end

endmodule
