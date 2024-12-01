module fetcher_tb;

    // Parameters
    parameter ADDR_WIDTH = 16;      // Chiều rộng địa chỉ (16 bit)
    parameter DATA_WIDTH = 16;      // Chiều rộng dữ liệu (16 bit)

    // Inputs
    reg [ADDR_WIDTH-1:0] pc_in;    // Địa chỉ chương trình
    reg [DATA_WIDTH-1:0] instr_mem [0:15];  // Bộ nhớ chỉ thị (instruction memory)

    // Outputs
    wire [DATA_WIDTH-1:0] instruction;  // Lệnh được fetch từ bộ nhớ

    // Instantiate the fetcher module
    fetcher uut (
        .pc_in(pc_in),
        .instruction(instruction),
        .instr_mem(instr_mem)
    );

    // Testbench stimulus
    initial begin
        // Initialize instruction memory (ví dụ với 16 chỉ thị, mỗi chỉ thị 16 bit)
        instr_mem[0] = 16'hA5A5;  // Instruction 0
        instr_mem[1] = 16'h5A5A;  // Instruction 1
        instr_mem[2] = 16'h1234;  // Instruction 2
        instr_mem[3] = 16'hDEAD;  // Instruction 3
        instr_mem[4] = 16'h8765;  // Instruction 4
        instr_mem[5] = 16'hABCD;  // Instruction 5
        instr_mem[6] = 16'h1122;  // Instruction 6
        instr_mem[7] = 16'hAABB;  // Instruction 7
        instr_mem[8] = 16'hDEAD;  // Instruction 8
        instr_mem[9] = 16'hF00D;  // Instruction 9
        instr_mem[10] = 16'hC0FF; // Instruction 10
        instr_mem[11] = 16'h0000; // Instruction 11
        instr_mem[12] = 16'hCAFE; // Instruction 12
        instr_mem[13] = 16'h1234; // Instruction 13
        instr_mem[14] = 16'h4321; // Instruction 14
        instr_mem[15] = 16'h9999; // Instruction 15

        // Display header
        $display("Time\tPC\tInstruction");

        // Apply different values of pc_in and observe the instruction fetched
        #10 pc_in = 16'b0000000000000000; // Fetch instruction at address 0
        #10 pc_in = 16'b0000000000000001; // Fetch instruction at address 1
        #10 pc_in = 16'b0000000000000010; // Fetch instruction at address 2
        #10 pc_in = 16'b0000000000000011; // Fetch instruction at address 3
        #10 pc_in = 16'b0000000000000100; // Fetch instruction at address 4
        #10 pc_in = 16'b0000000000000101; // Fetch instruction at address 5
        #10 pc_in = 16'b0000000000000110; // Fetch instruction at address 6
        #10 pc_in = 16'b0000000000000111; // Fetch instruction at address 7
        #10 pc_in = 16'b0000000000001000; // Fetch instruction at address 8
        #10 pc_in = 16'b0000000000001001; // Fetch instruction at address 9
        #10 pc_in = 16'b0000000000001010; // Fetch instruction at address 10
        #10 pc_in = 16'b0000000000001011; // Fetch instruction at address 11
        #10 pc_in = 16'b0000000000001100; // Fetch instruction at address 12
        #10 pc_in = 16'b0000000000001101; // Fetch instruction at address 13
        #10 pc_in = 16'b0000000000001110; // Fetch instruction at address 14
        #10 pc_in = 16'b0000000000001111; // Fetch instruction at address 15

        // End simulation
        #10 $finish;
    end

    // Monitor the fetched instruction
    always @(pc_in) begin
        $display("%0t\t%h\t%h", $time, pc_in, instruction);
    end

endmodule
