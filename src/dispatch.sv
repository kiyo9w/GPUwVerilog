module dispatcher (
    input wire        clk,            // Xung nhịp
    input wire        reset,          // Tín hiệu reset
    input wire [3:0]  work_item,      // Công việc cần xử lý, mã công việc đến các đơn vị
    input wire        dispatch_enable,// Tín hiệu kích hoạt bộ phát
    output reg [3:0]  assigned_core,  // Lõi (core) được chỉ định để thực hiện công việc
    output reg        task_valid      // Tín hiệu xác nhận công việc được chỉ định
);

    // Giả định có 4 đơn vị xử lý (cores)
    localparam CORE_COUNT = 4;
    reg [1:0] next_core;
    
    // Bộ đếm để chỉ định lõi tiếp theo
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_core <= 2'b00;
            task_valid <= 1'b0;
        end else if (dispatch_enable) begin
            // Gán công việc cho lõi hiện tại
            assigned_core <= next_core;
            
            // Đánh dấu công việc là hợp lệ khi đã được gán
            task_valid <= 1'b1; 
            
            // Chuẩn bị cho lõi tiếp theo
            next_core <= (next_core + 1) % CORE_COUNT;
        end else begin
            task_valid <= 1'b0; // Không hợp lệ khi không có yêu cầu phát công việc
        end
    end

endmodule
