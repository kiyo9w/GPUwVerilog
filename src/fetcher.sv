module fetcher (
    input wire clk,                      // Xung nhịp
    input wire reset,                    // Tín hiệu reset
    input wire [7:0] program_memory[0:255], // Bộ nhớ chương trình chứa các lệnh
    input wire start_fetch,              // Tín hiệu bắt đầu tìm nạp
    output reg [7:0] instruction,        // Lệnh được tìm nạp
    output reg fetch_valid               // Tín hiệu xác nhận lệnh được tìm nạp hợp lệ
);

    reg [7:0] program_counter;           // Bộ đếm chương trình

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            program_counter <= 0;
            fetch_valid <= 0;
        end else if (start_fetch) begin
            instruction <= program_memory[program_counter];
            fetch_valid <= 1;  // Đánh dấu rằng lệnh hợp lệ đã được tìm nạp
            program_counter <= program_counter + 1;
        end else begin
            fetch_valid <= 0; // Không có lệnh mới được tìm nạp
        end
    end

endmodule
