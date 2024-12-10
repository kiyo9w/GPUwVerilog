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
    integer last_thread; 
    integer i;           
    integer thread;      
    reg thread_found;    

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            last_thread <= -1;
            scheduled_thread <= 0;
        end else begin
            thread_found = 0;
            
            // iterate through all threads
            for (i = 1; i <= NUM_THREADS; i = i + 1) begin
                thread = (last_thread + i) % NUM_THREADS;
                
                // check if the current thread is active and no thread has been scheduled yet
                if (active_threads[thread] && !thread_found) begin
                    scheduled_thread <= thread;    
                    last_thread <= thread;         
                    thread_found = 1;              
                end
            end
        end
    end
endmodule
