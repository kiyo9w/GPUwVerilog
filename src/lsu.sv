module lsu (
    input wire clk,                   // Xung nhịp
    input wire reset,                 // Tín hiệu reset
    input wire [7:0] address,         // Địa chỉ bộ nhớ
    input wire [7:0] write_data,      // Dữ liệu cần ghi vào bộ nhớ
    input wire mem_write,             // Tín hiệu kích hoạt ghi
    input wire mem_read,              // Tín hiệu kích hoạt đọc
    output reg [7:0] read_data,       // Dữ liệu được đọc từ bộ nhớ
    output reg busy                   // Tín hiệu cho biết LSU đang bận
);

    reg [7:0] memory [0:255];         // Bộ nhớ giả lập, 256 ô nhớ 8-bit

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            read_data <= 0;
        end else begin
            if(mem_write) begin
                memory[address] <= write_data;
                busy <= 1;            // Ghi vào bộ nhớ, thiết lập busy cho chu kỳ này
            end else if(mem_read) begin
                read_data <= memory[address];
                busy <= 1;            // Đọc từ bộ nhớ, thiết lập busy cho chu kỳ này
            end else begin
                busy <= 0;            // Không hoạt động
            end
        end
    end

endmodule
