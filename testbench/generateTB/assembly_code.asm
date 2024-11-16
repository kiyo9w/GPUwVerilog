// A program written in assembly that can be translated into instructions at instruction_memory.mem to create test case

.define MAX_ITER 16
.define THRESHOLD 1024
.define VALUE_C_REAL 10
.define VALUE_C_IMAG 10
.define X_INIT 0
.define Y_INIT 0
.define Z_REAL_INIT 0
.define Z_IMAG_INIT 0
.define MAX_X 16
.define MAX_Y 16


LDRI R11, [MAX_ITER]      
LDRI R12, [THRESHOLD]     


LDRI R1, [Y_INIT]         

LOOP_Y:
    CMP R1, [MAX_Y]        
    JLT LOOP_Y_BODY        
    JMP END_PROGRAM        

LOOP_Y_BODY:
    
    LDRI R0, [X_INIT]      

LOOP_X:
    CMP R0, [MAX_X]        
    JLT LOOP_X_BODY        
    ADD R1, R1, #1         
    JMP LOOP_Y             

LOOP_X_BODY:
    
    LDRI R4, [VALUE_C_REAL] 
    LDRI R5, [VALUE_C_IMAG] 

    
    LDRI R2, [Z_REAL_INIT] 
    LDRI R3, [Z_IMAG_INIT] 

    
    LDRI R10, [ITER_INIT]  

LOOP_MANDEL:
    
    MUL R6, R2, R2          
    
    MUL R7, R3, R3          
    
    MUL R8, R2, R3          
    ADD R8, R8, #0          

    
    SUB R2, R6, R7          
    ADD R2, R2, R4          

    
    ADD R3, R8, R5          

    
    ADD R9, R6, R7          

    
    CMP R9, R12             
    JLT CONTINUE_ITER       

    
    
    MUL R14, R1, #16        
    ADD R14, R14, R0        

    
    STR R10, [R14]          

    
    ADD R0, R0, #1
    JMP LOOP_X              

CONTINUE_ITER:
    
    ADD R10, R10, #1

    
    CMP R10, R11
    JLT LOOP_MANDEL         

    
    
    MUL R14, R1, #16        
    ADD R14, R14, R0        

    
    STR R10, [R14]          

    
    ADD R0, R0, #1
    JMP LOOP_X              

END_PROGRAM:
    HALT                    
