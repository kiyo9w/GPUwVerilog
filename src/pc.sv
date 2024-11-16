module pc (
    input wire clk,                  // Xung nhịp
    input wire reset,                // Tín hiệu reset
    input wire [7:0] pc_in,          // Địa chỉ mới cho PC, dùng khi nhảy tới địa chỉ cụ thể
    input wire pc_write_enable,      // Tín hiệu cho phép cập nhật PC
    input wire pc_increment,         // Tín hiệu cho phép PC tăng tự động
    output reg [7:0] pc_out          // Địa chỉ hiện tại trong Program Counter
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 8'b0; // Thiết lập PC về 0 khi reset
        end else if (pc_write_enable) begin
            pc_out <= pc_in; // Cập nhật PC với địa chỉ mới được đưa vào
        end else if (pc_increment) begin
            pc_out <= pc_out + 1; // Tăng PC để trỏ đến địa chỉ lệnh kế tiếp
        end
    end

endmodule
