// scheduler.v
`include "definitions.vh"

module scheduler #(
    parameter NUM_THREADS = `NUM_THREADS
)(
    input clk,
    input reset,
    input [NUM_THREADS-1:0] active_threads,
    output reg [`THREAD_ID_WIDTH-1:0] scheduled_thread
);
    integer last_thread; // Tracks the last scheduled thread
    integer i;           // Loop variable
    integer thread;      // Current thread being checked
    reg thread_found;    // Flag to indicate if a thread has been found

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            last_thread <= -1;
            scheduled_thread <= 0;
        end else begin
            // Initialize the thread_found flag to 0 at the start of each cycle
            thread_found = 0;
            
            // Iterate through all threads in a round-robin fashion
            for (i = 1; i <= NUM_THREADS; i = i + 1) begin
                thread = (last_thread + i) % NUM_THREADS; // Calculate the next thread index
                
                // Check if the current thread is active and no thread has been scheduled yet
                if (active_threads[thread] && !thread_found) begin
                    scheduled_thread <= thread;    // Schedule this thread
                    last_thread <= thread;         // Update the last scheduled thread
                    thread_found = 1;              // Set the flag to indicate a thread has been found
                end
            end
        end
    end
endmodule
