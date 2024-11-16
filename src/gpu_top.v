module gpu_top (
	clk,
	reset,
	start,
	dcr_address,
	dcr_data_in,
	dcr_write_enable,
	done
);
	input wire clk;
	input wire reset;
	input wire start;
	input wire [3:0] dcr_address;
	input wire [7:0] dcr_data_in;
	input wire dcr_write_enable;
	output wire done;
	wire [7:0] instruction;
	wire [7:0] alu_out;
	wire [7:0] read_data;
	wire [7:0] pc_value;
	wire [7:0] dcr_data_out;
	wire [2:0] opcode;
	wire [3:0] src1;
	wire [3:0] src2;
	wire [3:0] dest;
	wire fetch_valid;
	wire alu_enable;
	wire reg_write;
	wire mem_read;
	wire mem_write;
	wire [1:0] alu_op;
	dcr dcr_inst(
		.clk(clk),
		.reset(reset),
		.write_enable(dcr_write_enable),
		.address(dcr_address),
		.data_in(dcr_data_in),
		.data_out(dcr_data_out)
	);
	pc pc_inst(
		.clk(clk),
		.reset(reset),
		.pc_in(8'b00000000),
		.pc_write_enable(1'b0),
		.pc_increment(fetch_valid),
		.pc_out(pc_value)
	);
	fetcher fetch_inst(
		.clk(clk),
		.reset(reset),
		.program_memory(dcr_data_out),
		.instruction(instruction),
		.fetch_valid(fetch_valid)
	);
	decoder decode_inst(
		.instruction(instruction),
		.opcode(opcode),
		.src1(src1),
		.src2(src2),
		.dest(dest),
		.valid(fetch_valid)
	);
	controller control_inst(
		.opcode(opcode),
		.alu_enable(alu_enable),
		.reg_write(reg_write),
		.mem_read(mem_read),
		.mem_write(mem_write),
		.alu_op(alu_op)
	);
	alu alu_inst(
		.A(src1),
		.B(src2),
		.opcode(alu_op),
		.result(alu_out),
		.zero_flag()
	);
	lsu lsu_inst(
		.clk(clk),
		.reset(reset),
		.address(alu_out),
		.write_data(src2),
		.mem_write(mem_write),
		.mem_read(mem_read),
		.read_data(read_data)
	);
	core core_inst(
		.clk(clk),
		.reset(reset),
		.result(alu_out)
	);
	reg [7:0] registers [0:15];
	always @(posedge clk or posedge reset)
		if (reset) begin : sv2v_autoblock_1
			integer i;
			for (i = 0; i < 16; i = i + 1)
				registers[i] <= 8'b00000000;
		end
		else if (reg_write)
			registers[dest] <= (mem_read ? read_data : alu_out);
	assign done = 1'b0;
endmodule

module alu (
	A,
	B,
	opcode,
	result,
	zero_flag
);
	input wire [7:0] A;
	input wire [7:0] B;
	input wire [2:0] opcode;
	output reg [7:0] result;
	output reg zero_flag;
	localparam ADD = 3'b000;
	localparam SUB = 3'b001;
	localparam AND = 3'b010;
	localparam OR = 3'b011;
	localparam XOR = 3'b100;
	localparam NOT = 3'b101;
	localparam SL = 3'b110;
	localparam SR = 3'b111;
	always @(*) begin
		case (opcode)
			ADD: result = A + B;
			SUB: result = A - B;
			AND: result = A & B;
			OR: result = A | B;
			XOR: result = A ^ B;
			NOT: result = ~A;
			SL: result = A << 1;
			SR: result = A >> 1;
			default: result = 8'b00000000;
		endcase
		zero_flag = result == 8'b00000000;
	end
endmodule

module controller (
	opcode,
	alu_enable,
	reg_write,
	mem_read,
	mem_write,
	alu_op
);
	input wire [2:0] opcode;
	output reg alu_enable;
	output reg reg_write;
	output reg mem_read;
	output reg mem_write;
	output reg [1:0] alu_op;
	localparam ADD_OP = 3'b000;
	localparam SUB_OP = 3'b001;
	localparam AND_OP = 3'b010;
	localparam LOAD_OP = 3'b011;
	localparam STORE_OP = 3'b100;
	always @(*) begin
		alu_enable = 0;
		reg_write = 0;
		mem_read = 0;
		mem_write = 0;
		alu_op = 2'b00;
		case (opcode)
			ADD_OP: begin
				alu_enable = 1;
				reg_write = 1;
				alu_op = 2'b00;
			end
			SUB_OP: begin
				alu_enable = 1;
				reg_write = 1;
				alu_op = 2'b01;
			end
			AND_OP: begin
				alu_enable = 1;
				reg_write = 1;
				alu_op = 2'b10;
			end
			LOAD_OP: begin
				mem_read = 1;
				reg_write = 1;
			end
			STORE_OP: mem_write = 1;
			default:
				;
		endcase
	end
endmodule

module core (
	clk,
	reset,
	program_memory,
	result
);
	input wire clk;
	input wire reset;
	input wire [2047:0] program_memory;
	output reg [7:0] result;
	wire [7:0] instruction;
	wire fetch_valid;
	wire [2:0] opcode;
	wire [3:0] src1;
	wire [3:0] src2;
	wire [3:0] dest;
	wire alu_enable;
	wire reg_write;
	wire mem_read;
	wire mem_write;
	wire [1:0] alu_op;
	reg [7:0] registers [0:15];
	wire [7:0] alu_out;
	fetcher fetch_inst(
		.clk(clk),
		.reset(reset),
		.program_memory(program_memory),
		.start_fetch(1),
		.instruction(instruction),
		.fetch_valid(fetch_valid)
	);
	decoder decode_inst(
		.instruction(instruction),
		.opcode(opcode),
		.src1(src1),
		.src2(src2),
		.dest(dest),
		.valid()
	);
	controller control_inst(
		.opcode(opcode),
		.alu_enable(alu_enable),
		.reg_write(reg_write),
		.mem_read(mem_read),
		.mem_write(mem_write),
		.alu_op(alu_op)
	);
	alu alu_inst(
		.clk(clk),
		.reset(reset),
		.enable(alu_enable),
		.rs(registers[src1]),
		.rt(registers[src2]),
		.alu_op(alu_op),
		.alu_out(alu_out)
	);
	always @(posedge clk or posedge reset)
		if (reset) begin : sv2v_autoblock_1
			integer i;
			for (i = 0; i < 16; i = i + 1)
				registers[i] <= 8'b00000000;
			result <= 8'b00000000;
		end
		else if (reg_write) begin
			registers[dest] <= alu_out;
			result <= alu_out;
		end
endmodule

module dcr (
	clk,
	reset,
	write_enable,
	data_in,
	control_select,
	control_status
);
	input wire clk;
	input wire reset;
	input wire write_enable;
	input wire [7:0] data_in;
	input wire [3:0] control_select;
	output reg [7:0] control_status;
	reg [7:0] dcr [0:15];
	always @(posedge clk or posedge reset)
		if (reset) begin : sv2v_autoblock_1
			integer i;
			for (i = 0; i < 16; i = i + 1)
				dcr[i] <= 8'b00000000;
			control_status <= 8'b00000000;
		end
		else if (write_enable)
			dcr[control_select] <= data_in;
	always @(*) control_status = dcr[control_select];
endmodule

module decoder (
	instruction,
	opcode,
	src1,
	src2,
	dest,
	valid
);
	input wire [7:0] instruction;
	output reg [2:0] opcode;
	output reg [3:0] src1;
	output reg [3:0] src2;
	output reg [3:0] dest;
	output reg valid;
	always @(*) begin
		opcode = instruction[7:5];
		src1 = instruction[4:3];
		src2 = instruction[2:1];
		dest = instruction[0];
		valid = opcode < 3'b101;
	end
endmodule

module dispatcher (
	clk,
	reset,
	work_item,
	dispatch_enable,
	assigned_core,
	task_valid
);
	input wire clk;
	input wire reset;
	input wire [3:0] work_item;
	input wire dispatch_enable;
	output reg [3:0] assigned_core;
	output reg task_valid;
	localparam CORE_COUNT = 4;
	reg [1:0] next_core;
	always @(posedge clk or posedge reset)
		if (reset) begin
			next_core <= 2'b00;
			task_valid <= 1'b0;
		end
		else if (dispatch_enable) begin
			assigned_core <= next_core;
			task_valid <= 1'b1;
			next_core <= (next_core + 1) % CORE_COUNT;
		end
		else
			task_valid <= 1'b0;
endmodule

module fetcher (
	clk,
	reset,
	program_memory,
	start_fetch,
	instruction,
	fetch_valid
);
	input wire clk;
	input wire reset;
	input wire [2047:0] program_memory;
	input wire start_fetch;
	output reg [7:0] instruction;
	output reg fetch_valid;
	reg [7:0] program_counter;
	always @(posedge clk or posedge reset)
		if (reset) begin
			program_counter <= 0;
			fetch_valid <= 0;
		end
		else if (start_fetch) begin
			instruction <= program_memory[(255 - program_counter) * 8+:8];
			fetch_valid <= 1;
			program_counter <= program_counter + 1;
		end
		else
			fetch_valid <= 0;
endmodule

module lsu (
	clk,
	reset,
	address,
	write_data,
	mem_write,
	mem_read,
	read_data,
	busy
);
	input wire clk;
	input wire reset;
	input wire [7:0] address;
	input wire [7:0] write_data;
	input wire mem_write;
	input wire mem_read;
	output reg [7:0] read_data;
	output reg busy;
	reg [7:0] memory [0:255];
	always @(posedge clk or posedge reset)
		if (reset) begin
			busy <= 0;
			read_data <= 0;
		end
		else if (mem_write) begin
			memory[address] <= write_data;
			busy <= 1;
		end
		else if (mem_read) begin
			read_data <= memory[address];
			busy <= 1;
		end
		else
			busy <= 0;
endmodule

module pc (
	clk,
	reset,
	pc_in,
	pc_write_enable,
	pc_increment,
	pc_out
);
	input wire clk;
	input wire reset;
	input wire [7:0] pc_in;
	input wire pc_write_enable;
	input wire pc_increment;
	output reg [7:0] pc_out;
	always @(posedge clk or posedge reset)
		if (reset)
			pc_out <= 8'b00000000;
		else if (pc_write_enable)
			pc_out <= pc_in;
		else if (pc_increment)
			pc_out <= pc_out + 1;
endmodule

module register (
	clk,
	reset,
	read_reg1,
	read_reg2,
	write_reg,
	write_data,
	reg_write,
	read_data1,
	read_data2
);
	input wire clk;
	input wire reset;
	input wire [3:0] read_reg1;
	input wire [3:0] read_reg2;
	input wire [3:0] write_reg;
	input wire [7:0] write_data;
	input wire reg_write;
	output wire [7:0] read_data1;
	output wire [7:0] read_data2;
	reg [7:0] registers [15:0];
	assign read_data1 = registers[read_reg1];
	assign read_data2 = registers[read_reg2];
	always @(posedge clk or posedge reset)
		if (reset) begin : sv2v_autoblock_1
			integer i;
			for (i = 0; i < 16; i = i + 1)
				registers[i] <= 8'b00000000;
		end
		else if (reg_write)
			registers[write_reg] <= write_data;
endmodule

module scheduler (
	clk,
	reset,
	new_task,
	core_busy,
	execute_core,
	dispatch_task
);
	input wire clk;
	input wire reset;
	input wire new_task;
	input wire [3:0] core_busy;
	output reg [3:0] execute_core;
	output reg dispatch_task;
	reg [1:0] current_core;
	always @(posedge clk or posedge reset) begin : sv2v_autoblock_1
		reg [0:1] _sv2v_jump;
		_sv2v_jump = 2'b00;
		if (reset) begin
			execute_core <= 4'b0000;
			dispatch_task <= 0;
			current_core <= 0;
		end
		else if (new_task) begin
			dispatch_task <= 0;
			begin : sv2v_autoblock_2
				integer i;
				begin : sv2v_autoblock_3
					integer _sv2v_value_on_break;
					for (i = 0; i < 4; i = i + 1)
						if (_sv2v_jump < 2'b10) begin
							_sv2v_jump = 2'b00;
							current_core <= (current_core + 1) % 4;
							if (!core_busy[current_core]) begin
								execute_core <= 1 << current_core;
								dispatch_task <= 1;
								_sv2v_jump = 2'b10;
							end
							_sv2v_value_on_break = i;
						end
					if (!(_sv2v_jump < 2'b10))
						i = _sv2v_value_on_break;
					if (_sv2v_jump != 2'b11)
						_sv2v_jump = 2'b00;
				end
			end
		end
		else
			dispatch_task <= 0;
	end
endmodule
