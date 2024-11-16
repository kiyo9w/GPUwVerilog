# Python program to convert assembly code to instructions fitting for the gpu at instruction_memory.mem

import sys
import re

# Define opcode mappings
opcode_map = {
    'ADD': '0000',
    'SUB': '0001',
    'MUL': '0010',
    'CMP': '0011',
    'JMP': '0100',
    'JLT': '0101',  # Jump if Less Than
    'LDRI': '0110',  # Load Immediate
    'LDR': '0110',   # Load from Memory
    'STR': '0111',
    'HALT': '1111',
}

# Define register mappings (R0 to R15)
register_map = {f'R{i}': f'{i:04b}' for i in range(16)}

def assemble_instruction(parts, labels, definitions):
    if not parts:
        return None
    opcode = parts[0].upper()
    opcode_bin = opcode_map.get(opcode, None)
    if opcode_bin is None:
        print(f"Unknown opcode: {opcode}")
        return None

    if opcode in ['HALT']:
        # HALT has no operands
        return opcode_bin + '0000' + '00000000'

    elif opcode in ['LDR', 'STR']:
        # LDR dest_reg, [address]
        # STR src_reg, [address]
        if len(parts) != 3:
            print(f"Incorrect number of operands for {opcode}: {parts}")
            return None
        reg = parts[1].rstrip(',').upper()
        operand = parts[2].strip('[]').upper()
        # Resolve operand (address)
        if operand in labels:
            address = labels[operand]
        elif operand in definitions:
            address = definitions[operand]
        else:
            try:
                if operand.startswith('0x') or operand.startswith('0X'):
                    address = int(operand, 16)
                else:
                    address = int(operand)
            except ValueError:
                print(f"Invalid operand address: {operand}")
                return None
        dest_reg_bin = register_map.get(reg, '0000')
        immediate_bin = f'{address & 0xFF:08b}'  # 8-bit immediate
        return opcode_bin + dest_reg_bin + immediate_bin

    elif opcode in ['ADD', 'SUB', 'MUL', 'CMP']:
        # ADD dest_reg, src_reg, immediate
        if len(parts) != 4:
            print(f"Incorrect number of operands for {opcode}: {parts}")
            return None
        dest_reg = parts[1].rstrip(',').upper()
        src_reg = parts[2].rstrip(',').upper()
        immediate = parts[3].upper()
        # Resolve immediate
        if immediate in labels:
            imm_value = labels[immediate]
        elif immediate in definitions:
            imm_value = definitions[immediate]
        else:
            try:
                if immediate.startswith('#'):
                    imm_value = int(immediate[1:])
                elif immediate.startswith('0x') or immediate.startswith('0X'):
                    imm_value = int(immediate, 16)
                else:
                    imm_value = int(immediate)
            except ValueError:
                print(f"Invalid immediate value: {immediate}")
                return None
        dest_reg_bin = register_map.get(dest_reg, '0000')
        src_reg_bin = register_map.get(src_reg, '0000')
        immediate_bin = f'{imm_value & 0x0F:04b}'  # 4-bit immediate
        return opcode_bin + dest_reg_bin + src_reg_bin + immediate_bin

    elif opcode in ['JMP', 'JLT']:
        # JMP label
        # JLT label
        if len(parts) != 2:
            print(f"Incorrect number of operands for {opcode}: {parts}")
            return None
        label = parts[1].upper()
        if label in labels:
            address = labels[label]
        elif label in definitions:
            address = definitions[label]
        else:
            try:
                if label.startswith('0x') or label.startswith('0X'):
                    address = int(label, 16)
                else:
                    address = int(label)
            except ValueError:
                print(f"Invalid jump address: {label}")
                return None
        # For JMP and JLT, use a special register or ignore
        dest_reg_bin = '0000'  # Assuming no destination register for jumps
        immediate_bin = f'{address & 0xFF:08b}'
        return opcode_bin + dest_reg_bin + immediate_bin

    elif opcode in ['LDRI']:
        # LDRI dest_reg, immediate
        if len(parts) != 3:
            print(f"Incorrect number of operands for {opcode}: {parts}")
            return None
        dest_reg = parts[1].rstrip(',').upper()
        immediate = parts[2].upper()
        # Resolve immediate
        if immediate in labels:
            imm_value = labels[immediate]
        elif immediate in definitions:
            imm_value = definitions[immediate]
        else:
            try:
                if immediate.startswith('#'):
                    imm_value = int(immediate[1:])
                elif immediate.startswith('0x') or immediate.startswith('0X'):
                    imm_value = int(immediate, 16)
                else:
                    imm_value = int(immediate)
            except ValueError:
                print(f"Invalid immediate value: {immediate}")
                return None
        dest_reg_bin = register_map.get(dest_reg, '0000')
        immediate_bin = f'{imm_value & 0xFF:08b}'  # 8-bit immediate
        return opcode_bin + dest_reg_bin + immediate_bin

    else:
        print(f"Unhandled opcode: {opcode}")
        return None

def assemble(lines):
    labels = {}
    definitions = {}
    machine_code = []
    address = 0

    # First pass: collect labels and definitions
    for line in lines:
        line = line.strip()
        # Remove comments
        line = re.split(r'#|//', line)[0].strip()
        if not line:
            continue
        # Handle .define
        if line.startswith('.define'):
            parts = line.split()
            if len(parts) != 3:
                print(f"Invalid .define directive: {line}")
                continue
            _, name, value = parts
            try:
                if value.startswith('0x') or value.startswith('0X'):
                    definitions[name.upper()] = int(value, 16)
                else:
                    definitions[name.upper()] = int(value)
            except ValueError:
                print(f"Invalid .define value: {line}")
            continue
        # Handle labels
        if line.endswith(':'):
            label = line[:-1].upper()
            labels[label] = address
            continue
        # Otherwise, it's an instruction
        address += 1

    # Second pass: assemble instructions
    address = 0
    for line in lines:
        original_line = line
        line = line.strip()
        # Remove comments
        line = re.split(r'#|//', line)[0].strip()
        if not line:
            continue
        # Handle .define
        if line.startswith('.define'):
            continue
        # Handle labels
        if line.endswith(':'):
            continue
        # Split instruction into parts
        parts = re.split(r'[,\s]+', line)
        instruction_bin = assemble_instruction(parts, labels, definitions)
        if instruction_bin:
            instruction_hex = f'{int(instruction_bin, 2):04X}'
            machine_code.append(instruction_hex)
            address +=1
    return machine_code

def main():
    if len(sys.argv) < 2:
        print("Usage: python assembler.py assembly_code.asm")
        return

    asm_file = sys.argv[1]
    with open(asm_file, 'r') as f:
        lines = f.readlines()

    machine_code = assemble(lines)
    with open('instruction_memory.mem', 'w') as f:
        for code in machine_code:
            f.write(code + '\n')

    print("Assembly complete. Machine code written to instruction_memory.mem.")

if __name__ == '__main__':
    main()
