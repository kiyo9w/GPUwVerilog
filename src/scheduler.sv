module scheduler (
    input wire        clk,              // Xung nhịp
    input wire        reset,            // Tín hiệu reset
    input wire        new_task,         // Tín hiệu báo có công việc mới
    input wire        core_busy[3:0],   // Trạng thái bận của các đơn vị xử lý
    output reg [3:0]  execute_core,     // Đơn vị xử lý được chọn để thực thi
    output reg        dispatch_task     // Tín hiệu điều phối công việc
);

    reg [1:0] current_core; // Đơn vị xử lý hiện tại được xem xét

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            execute_core <= 4'b0000;
            dispatch_task <= 0;
            current_core <= 0;
        end else if (new_task) begin
            dispatch_task <= 0; // Khởi tạo lại tín hiệu công việc
            // Tìm một đơn vị xử lý không bận để gán công việc
            for (integer i = 0; i < 4; i = i + 1) begin
                current_core <= (current_core + 1) % 4;
                if (!core_busy[current_core]) begin
                    execute_core <= 1 << current_core;
                    dispatch_task <= 1; // Công việc đã được định hướng
                    break;
                end
            end
        end else begin
            dispatch_task <= 0; // Không công việc nào được điều phối
        end
    end

endmodule
