@Final Program
@Adhish Deshpande
@1001104148

	.global main
	.func main

main:
	MOV R0, #0
	MOV R5, #0
_populate_array:
    	CMP R0, #10
   	BEQ _populate_array_done     
	PUSH {R0}
	PUSH {R1}
	BL _scanf
	MOV R4 ,R0
	ADD R5 ,R0 ,R5
	POP {R1}
	POP {R0}
    	LDR R1, =array_a              @ get address of a
	LSL R2, R0, #2          @ multiply index*4 to get array offset
    	ADD R2, R1, R2          @ R2 now has the element address
	STR R4, [R2]            @ write the address of a[i] to a[i]
	ADD R0, R0, #1          @ increment index
    	B _populate_array           @ branch to next loop iteration
_populate_array_done:
    MOV R0, #0              @ initialze index variable
_printf_array:	    	
	CMP R0, #10       
    	BEQ _printf_array_done
    	LDR R1, =array_a
    	LSL R2, R0, #2
    	ADD R2, R1, R2          @ R2 now has the element address
	LDR R1, [R2]            @ read the array at address 
    	PUSH {R0} 	             @ backup register before printf
    	PUSH {R1}               @ backup register before printf
    	PUSH {R2}               @ backup register before printf
    	MOV R2,	R1              @ move array value to R2 for printf
    	MOV R1, R0              @ move array index to R1 for printf
    	BL  _printf             @ branch to print procedure with return
    	POP {R2}                @ restore register
	POP {R1}                @ restore register
    	POP {R0}                @ restore register
	ADD R0, R0, #1          @ increment index
    	B   _printf_array            @ branch to next loop iteration
_printf_array_done:
	MOV R1, R5
    	B _exit                 @ exit if done

_scanf:
    PUSH {LR}              @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
	POP {LR}
	MOV PC, LR

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
    
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

.data

.balign	4
array_a:	.skip		40
format_str:	.asciz		"%d"
printf_str: 	.asciz		"array_a[%d] = %d\n"
printf_min_str:	.asciz		"minimum = %d\n"
printf_max_str:	.asciz		"maximum = %d\n"
printf_sum_str:	.asciz		"sum = %d\n"
exit_str:	.ascii		"\n"

