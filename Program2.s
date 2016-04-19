@Program2
@Adhish Deshpande
@1001104148


    .global main
    .func main
   
main:
    MOV R6, #0		    @ set initial return value to 0 
    
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
    MOVEQ R0, #1            @ set return value to 1 if equal
    POPEQ {PC}              @ restore stack pointer and return if equal
   
    CMP R1, #0		    @ compare the input argument to 0
    MOVLT R0, #0	    @ set return value to 0 if less than
    POPLT {PC}	 	    @ restore stack pointer and return if less than
    
    CMP R2, #0 		    @ compare the input argument to 0
    MOVEQ R0, #0	    @ set return value to 0 if equal
    POPEQ {PC}		    @ restore stack pointer and return if equal 
    
    PUSH {R1}               @ backup input argument value 
    PUSH {R2}               @ backup input argument value 
    
    SUB R1, R1, R2 	    @ calculating (n-m)
    BL _count_partitions    @ call function again 
    ADD R6, R6, R0	    @ add return value to R6
    
    POP  {R2}		    @ restore R2 from stack 
    POP  {R1}		    @ restore R1 from stack
    SUB  R2, R2, #1	    @ calculating (m-1)
    BL _count_partitions    @ call function again
    
    
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
printf_str:     .asciz      "There are %d partitions of %d using integers up to %d \n"

