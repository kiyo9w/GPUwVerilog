module decoder (
    input wire [7:0] instruction,     // Lệnh đầu vào cần giải mã
    output reg [2:0] opcode,          // Mã lệnh (operation code)
    output reg [3:0] src1,            // Toán hạng nguồn 1
    output reg [3:0] src2,            // Toán hạng nguồn 2
    output reg [3:0] dest,            // Thanh ghi đích
    output reg valid                  // Tín hiệu hợp lệ cho biết lệnh đã được giải mã thành công
);

    always @(*) begin
        opcode = instruction[7:5];    // 3 bit cao nhất dùng làm mã lệnh
        src1 = instruction[4:3];      // Toán hạng nguồn 1
        src2 = instruction[2:1];      // Toán hạng nguồn 2
        dest = instruction[0];        // Thanh ghi đích (hoặc có thể dùng nhiều bit hơn nếu cần)

        // Giả định rằng mã lệnh hợp lệ nếu opcode nằm trong phạm vi nhất định.
        valid = (opcode < 3'b101);    // Ví dụ: chỉ các opcode từ 0 đến 4 là hợp lệ
    end

endmodule
