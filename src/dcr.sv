module dcr (
    input wire clk,                     // Xung nhịp
    input wire reset,                   // Tín hiệu reset
    input wire write_enable,            // Kích hoạt ghi
    input wire [7:0] data_in,           // Dữ liệu đầu vào để ghi
    input wire [3:0] control_select,    // Chọn thanh ghi điều khiển nào
    output reg [7:0] control_status     // Trạng thái điều khiển đầu ra
);

    // Thanh ghi điều khiển thiết bị, sử dụng nhiều thanh ghi nếu cần
    reg [7:0] dcr [0:15]; // 16 thanh ghi điều khiển mỗi cái 8-bit

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Khởi tạo lại tất cả các thanh ghi khi reset
            integer i;
            for (i = 0; i < 16; i = i + 1) begin
                dcr[i] <= 8'b0;
            end
            control_status <= 8'b0;
        end else if (write_enable) begin
            // Ghi dữ liệu vào thanh ghi điều khiển được chỉ định
            dcr[control_select] <= data_in;
        end
    end

    // Đọc trạng thái điều khiển từ thanh ghi được chỉ định
    always @(*) begin
        control_status = dcr[control_select];
    end

endmodule
