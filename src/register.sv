module register (
    input wire clk,                                // Xung nhịp
    input wire reset,                              // Tín hiệu reset
    input wire [3:0] read_reg1,                    // Địa chỉ thanh ghi đọc 1
    input wire [3:0] read_reg2,                    // Địa chỉ thanh ghi đọc 2
    input wire [3:0] write_reg,                    // Địa chỉ thanh ghi ghi
    input wire [7:0] write_data,                   // Dữ liệu ghi vào thanh ghi
    input wire reg_write,                          // Tín hiệu kích hoạt ghi
    output wire [7:0] read_data1,                  // Dữ liệu đầu ra đọc 1
    output wire [7:0] read_data2                   // Dữ liệu đầu ra đọc 2
);

    reg [7:0] registers [15:0]; // 16 thanh ghi, mỗi thanh ghi 8-bit

    // Đọc từ thanh ghi (thực hiện liên tục)
    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];

    // Ghi vào thanh ghi (thực hiện khi có xung nhịp)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Đặt lại tất cả thanh ghi về 0 khi reset
            integer i;
            for (i = 0; i < 16; i = i + 1) begin
                registers[i] <= 8'b0;
            end
        end else if (reg_write) begin
            // Ghi dữ liệu vào thanh ghi được chỉ định nếu reg_write được bật
            registers[write_reg] <= write_data;
        end
    end

endmodule
