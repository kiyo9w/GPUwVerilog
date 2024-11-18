#include <iostream>
#include <queue>
#include <unordered_map>
#include <vector>

// Scheduler để lên lịch lệnh
class Scheduler {
public:
    void addInstruction(int opcode) {
        instructionQueue.push(opcode);
    }

    int getNextInstruction() {
        if (!instructionQueue.empty()) {
            int instr = instructionQueue.front();
            instructionQueue.pop();
            return instr;
        }
        return -1; // Không có lệnh để thực thi
    }

private:
    std::queue<int> instructionQueue;
};

// Memory Interface để kết nối bộ nhớ
class MemoryInterface {
public:
    void write(int address, int data) {
        memory[address] = data;
    }

    int read(int address) {
        if (memory.find(address) != memory.end()) {
            return memory[address];
        }
        return 0; // Giá trị mặc định nếu không tìm thấy
    }

private:
    std::unordered_map<int, int> memory; // Bộ nhớ giả lập sử dụng map
};

// Load Store Unit (LSU) để xử lý load/store
class LSU {
public:
    LSU(MemoryInterface& memInterface) : memory(memInterface) {}

    void store(int address, int data) {
        memory.write(address, data);
    }

    int load(int address) {
        return memory.read(address);
    }

private:
    MemoryInterface& memory; // Tham chiếu đến bộ nhớ
};

// ALU để thực hiện các phép toán
class ALU {
public:
    int execute(int operand_a, int operand_b, int opcode) {
        switch (opcode) {
        case 1: return operand_a + operand_b; // ADD
        case 2: return operand_a - operand_b; // SUB
        case 3: return operand_a * operand_b; // MUL
        case 4:
            if (operand_b != 0) return operand_a / operand_b; // DIV
            else {
                std::cout << "Error: Division by zero!" << std::endl;
                return 0;
            }
        default: return 0;
        }
    }
};

// Register File để lưu trữ các giá trị trung gian
class RegisterFile {
public:
    RegisterFile(int size) : registers(size, 0) {}

    void write(int regIndex, int value) {
        if (regIndex >= 0 && regIndex < registers.size()) {
            registers[regIndex] = value;
        }
    }

    int read(int regIndex) {
        if (regIndex >= 0 && regIndex < registers.size()) {
            return registers[regIndex];
        }
        return 0;
    }

private:
    std::vector<int> registers;
};

// Program Counter và Branch Logic để điều khiển dòng thực thi
class ProgramCounter {
public:
    ProgramCounter() : pc(0) {}

    void increment() {
        pc += 1; // Tăng địa chỉ lệnh tiếp theo
    }

    void branch(int address) {
        pc = address; // Nhảy đến địa chỉ mới
    }

    int getPC() {
        return pc;
    }

private:
    int pc; // Giá trị của Program Counter
};

class BranchLogic {
public:
    bool shouldBranch(int condition, int value1, int value2) {
        switch (condition) {
        case 1: return value1 == value2; // Branch if equal
        case 2: return value1 != value2; // Branch if not equal
        case 3: return value1 < value2;  // Branch if less than
        case 4: return value1 > value2;  // Branch if greater than
        default: return false;
        }
    }
};

// Main function: Kết hợp các thành phần để mô phỏng GPU
int main() {
    Scheduler scheduler;
    MemoryInterface memoryInterface;
    LSU lsu(memoryInterface);
    ALU alu;
    RegisterFile registerFile(8); // 8 thanh ghi
    ProgramCounter pc;
    BranchLogic branchLogic;

    int numInstructions;
    std::cout << "Nhập số lượng lệnh bạn muốn thực hiện: ";
    std::cin >> numInstructions;

    for (int i = 0; i < numInstructions; ++i) {
        int opcode;
        std::cout << "Nhập lệnh (1: ADD, 2: SUB, 3: MUL, 4: DIV): ";
        std::cin >> opcode;

        if (opcode < 1 || opcode > 4) {
            std::cout << "Lệnh không hợp lệ! Vui lòng nhập lại." << std::endl;
            --i;
            continue;
        }

        int operand_a, operand_b;
        std::cout << "Nhập toán hạng A: ";
        std::cin >> operand_a;
        std::cout << "Nhập toán hạng B: ";
        std::cin >> operand_b;

        // Thêm lệnh vào Scheduler
        scheduler.addInstruction(opcode);

        // Giả lập thực thi lệnh
        int nextOpcode = scheduler.getNextInstruction();
        if (nextOpcode != -1) {
            int result = alu.execute(operand_a, operand_b, nextOpcode);
            std::cout << "Kết quả: " << result << std::endl;

            // Ghi kết quả vào thanh ghi
            registerFile.write(0, result);

            // Giả sử lưu kết quả vào bộ nhớ
            lsu.store(pc.getPC(), result);

            // Tăng PC
            pc.increment();
        }
    }

    // Đọc giá trị từ bộ nhớ để xác minh kết quả
    std::cout << "Giá trị bộ nhớ tại địa chỉ 0: " << lsu.load(0) << std::endl;

    return 0;
}