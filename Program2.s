    .global main
    .func main
   
main:
    ADD R6, #0, #0
    BL  _scanf              @ branch to scan procedure with return
    MOV R7, R0              @ store n in R7
    BL  _scanf		    @ branch to scan procedure with return
    MOV R8, R0		    @ store m in R8
    
    MOV R1, R7              @ pass n to count partition procedure
    MOV R2, R8		    @ pass m to count partition procedure
    BL  _count_partitions   @ branch to count partition procedure with return
    
    MOV R1, R6
    MOV R2, R7              @ pass n to printf procedure
    MOV R3, R8              @ pass result to printf procedure
    BL  _printf             @ branch to print procedure with return
    B main

_count_partitions:
    PUSH {LR}               @ store the return address
    CMP R1, #0              @ compare the input argument to 1
    ADDEQ R6, R6, #1            @ set return value to 1 if equal
    POPEQ {PC}              @ restore stack pointer and return if equal
   
    CMP R1, #0
    ADDLT R6, R6, #0
    POPLT {PC}
    
    CMP R2, #0
    ADDEQ R6, R6, #0
    POPEQ {PC}
    
    SUB R4, R7, R8
    SUB R5, 
    PUSH {R1}               @ backup input argument value  
    SUB R1, R1, #1          @ decrement the input argument
    BL _fact                @ compute fact(n-1)
    POP {R1}                @ restore input argument
    MUL R0, R0, R1          @ compute fact(n-1)*n
    POP  {PC}               @ restore the stack pointer and return

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
   
_scanf:
    PUSH {LR}               @ store the return address
    PUSH {R1}               @ backup regsiter value
    LDR R0, =format_str     @ R0 contains address of format string
    SUB SP, SP, #4          @ make room on stack
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ remove value from stack
    POP {R1}                @ restore register value
    POP {PC}                @ restore the stack pointer and return
 

.data
format_str:     .asciz      "%d"
printf_str:     .asciz      "There are %d partitions of %d using integers up to %d"
