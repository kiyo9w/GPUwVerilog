// compute_core.v
`include "definitions.vh"

module compute_core (
    input clk,
    input reset,
    output reg halt
);
    reg [`DATA_WIDTH-1:0] register_file [0:`NUM_THREADS-1][0:`REG_COUNT-1];
    reg [`ADDR_WIDTH-1:0] pc [0:`NUM_THREADS-1];
    reg [`NUM_THREADS-1:0] active_threads;
    reg [`DATA_WIDTH-1:0] data_mem [0:15];
    reg [`DATA_WIDTH-1:0] instr_mem [0:15];

    wire [`THREAD_ID_WIDTH-1:0] scheduled_thread;

    wire [`DATA_WIDTH-1:0] instruction;
    wire [3:0] opcode;
    wire [3:0] dest_reg;
    wire [3:0] src_reg;
    wire [7:0] immediate;

    reg [`DATA_WIDTH-1:0] alu_result;
    reg cmp_flag;

    integer i;
    integer current_thread;

    reg pc_increment;

    reg [`NUM_THREADS-1:0] next_active_threads;

    scheduler #(
        .NUM_THREADS(`NUM_THREADS)
    ) scheduler_inst (
        .clk(clk),
        .reset(reset),
        .active_threads(active_threads),
        .scheduled_thread(scheduled_thread)
    );

    fetcher fetcher_inst (
        .pc_in(pc[scheduled_thread]),
        .instruction(instruction),
        .instr_mem(instr_mem)
    );

    decoder decoder_inst (
        .instruction(instruction),
        .opcode(opcode),
        .dest_reg(dest_reg),
        .src_reg(src_reg),
        .immediate(immediate)
    );

    initial begin
       $readmemh("instruction_memory.mem", instr_mem);
       $display("Instruction Memory Initialized:");
       for (i = 0; i < 16; i = i + 1) begin
           $display("instr_mem[%0d] = %h", i, instr_mem[i]);
       end
    end

    initial begin
       $readmemh("data_memory.mem", data_mem);
       $display("Data Memory Initialized:");
       for (i = 0; i < 16; i = i + 1) begin
           $display("data_mem[%0d] = %h", i, data_mem[i]);
       end
    end

    // core logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < `NUM_THREADS; i = i + 1) begin
                pc[i] <= 0;
                active_threads[i] <= 1;
                for (current_thread = 0; current_thread < `REG_COUNT; current_thread = current_thread + 1) begin
                    register_file[i][current_thread] <= 0;
                end
                register_file[i][15] <= i;
            end
            halt <= 0;
            $display("DUT Reset at time %0t", $time);
        end else if (!halt) begin
            next_active_threads = active_threads;

            current_thread = scheduled_thread;
            if (active_threads[current_thread]) begin
                pc_increment = 1;

                case (opcode)
                    `OP_ADD: begin
                        alu_result = register_file[current_thread][dest_reg] + register_file[current_thread][src_reg] + immediate;
                        register_file[current_thread][dest_reg] <= alu_result;
                    end
                    `OP_SUB: begin
                        alu_result = register_file[current_thread][dest_reg] - register_file[current_thread][src_reg] - immediate;
                        register_file[current_thread][dest_reg] <= alu_result;
                    end
                    `OP_MUL: begin
                        alu_result = register_file[current_thread][dest_reg] * register_file[current_thread][src_reg];
                        register_file[current_thread][dest_reg] <= alu_result;
                    end
                    `OP_CMP: begin
                        if (register_file[current_thread][dest_reg] < register_file[current_thread][src_reg]) begin
                            cmp_flag <= 1;
                        end else begin
                            cmp_flag <= 0;
                        end
                    end
                    `OP_JMP: begin
                        pc[current_thread] <= {8'b00000000, immediate};
                        pc_increment <= 0;
                    end
                    `OP_JLT: begin
                        if (cmp_flag == 1) begin
                            pc[current_thread] <= {8'b00000000, immediate};
                            pc_increment <= 0;
                        end
                    end
                    `OP_LDR: begin
                        register_file[current_thread][dest_reg] <= data_mem[immediate];
                    end
                    `OP_STR: begin
                        data_mem[immediate] <= register_file[current_thread][dest_reg];
                    end
                    `OP_HALT: begin
                        next_active_threads[current_thread] = 0; // halt current thread
                        $display("Thread %0d executing HALT. Halting.", current_thread);
                    end
                    default: begin
                        // NOP or undefined instruction
                        $display("Thread %0d encountered undefined opcode %b. No operation performed.", current_thread, opcode);
                    end
                endcase

                // logging
                if (pc_increment) begin
                    pc[current_thread] <= pc[current_thread] + 1;
                end

                $display("Time=%0t | Thread=%0d | PC=%0d | Instruction=%h | Opcode=%b | dest_reg=R%0d | src_reg=R%0d | immediate=%d",
                         $time, current_thread, pc[current_thread], instruction, opcode, dest_reg, src_reg, immediate);
            end

            active_threads <= next_active_threads;

            // check if all threads have halted
            if (next_active_threads == 0) begin
                halt <= 1;
                $display("All threads have halted at time %0t", $time);
            end
        end
    end

    // dump waveforms
    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, compute_core);
    end

endmodule
