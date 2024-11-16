`include "gpu_top.v"
`timescale 1ns/1ps

module gpu_top_testbench;

    // Declare input registers and output wires
    reg clk;
    reg reset;
    reg start;
    reg [3:0] dcr_address;
    reg [7:0] dcr_data_in;
    reg dcr_write_enable;
    wire done;

    // Instantiate the gpu_top module
    gpu_top uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .dcr_address(dcr_address),
        .dcr_data_in(dcr_data_in),
        .dcr_write_enable(dcr_write_enable),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 ns clock period
    end

    // Stimulus block
    initial begin
        // Initialize inputs
        reset = 1;
        start = 0;
        dcr_address = 4'b0000;
        dcr_data_in = 8'b00000000;
        dcr_write_enable = 0;

        // Release reset after 20 ns
        #20 reset = 0;
        
        // Start sequence
        #10 start = 1;
        
        // Write to DCR address 1, data 0xAA
        #10 dcr_address = 4'b0001;
            dcr_data_in = 8'hAA;
            dcr_write_enable = 1;
        
        // Wait before disabling write
        #10 dcr_write_enable = 0;

        // Allow circuit to simulate for 100 ns
        #100;

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("At time %t, done = %b", $time, done);
    end

endmodule
