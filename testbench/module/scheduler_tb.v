module scheduler_tb;

    // Parameters
    parameter NUM_THREADS = 4;  // Giả sử có 4 threads
    parameter THREAD_ID_WIDTH = 3;  // Sửa chiều rộng ID thread thành 3 bit

    // Inputs
    reg clk;
    reg reset;
    reg [NUM_THREADS-1:0] active_threads;  // Tín hiệu xác định các thread còn hoạt động

    // Outputs
    wire [THREAD_ID_WIDTH-1:0] scheduled_thread;  // Thread được lập lịch

    // Instantiate the scheduler module
    scheduler #(
        .NUM_THREADS(NUM_THREADS)
    ) uut (
        .clk(clk),
        .reset(reset),
        .active_threads(active_threads),
        .scheduled_thread(scheduled_thread)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Chu kỳ đồng hồ 10 đơn vị thời gian
    end

    // Testbench stimulus
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        active_threads = 4'b1111;  // Tất cả các thread đều hoạt động

        // Display header
        $display("Time\tReset\tActive Threads\tScheduled Thread");

        // Apply reset and release it after a while
        #10 reset = 0;  // Release reset tại thời điểm t = 10

        // Chạy thử với các active_threads khác nhau
        #10 active_threads = 4'b1110;  // Thread 3 không hoạt động
        #10 active_threads = 4'b1101;  // Thread 2 không hoạt động
        #10 active_threads = 4'b1011;  // Thread 1 không hoạt động
        #10 active_threads = 4'b1000;  // Chỉ có thread 0 hoạt động

        // Chạy với tất cả các thread đều hoạt động
        #10 active_threads = 4'b1111;

        // Test with reset again
        #10 reset = 1;  // Thực hiện reset
        #10 reset = 0;  // Thả reset

        // Kết thúc mô phỏng sau khi test đủ các tình huống
        #50 $finish;
    end

    // Monitor output
    always @(posedge clk) begin
        $display("%0t\t%0b\t%0b\t%0d", $time, reset, active_threads, scheduled_thread);
    end

endmodule
