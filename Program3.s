@Program 3
@Adhish Deshpande
@1001104148


  	.global main
	.func main
	
main:
	BL _scanf		@ branch to _scanf procedure
	MOV R4, R0		@ storing the value of n in R4
	MOV R0, #0		@ initialize index variable
	BL _generate		@ branch to _generate procedure
	MOV R0, #0		@ initialize index variable
	BL _sort_ascending	@ branch to _sort_ascending procedure
	MOV R0, #0		@ initialize index variable 
	BL _readloop		@ branch to _readloop procedure
	B _exit			@ branch to exit and terminate program
	
_scanf:
	PUSH {LR}		@ backup stack pointer
    	SUB SP, SP, #4          @ make room on stack
    	LDR R0, =format_str     @ R0 contains address of format string
    	MOV R1, SP              @ move SP to R1 to store entry on stack
    	BL scanf                @ call scanf
    	LDR R0, [SP]            @ load value at SP into R0
    	ADD SP, SP, #4          @ restore the stack pointer
    	POP {PC}	        @ return
	
_generate:
	CMP R0, #0		@ check to see if we started at 0 
	PUSHEQ {LR}		@ backup stack pointer
	CMP R0, #20		@ check to see if we are done iterating
	POPEQ {PC}		@ exit loop if done
	LDR R1, =array_a	@ get address of a
	LDR R3, =array_b	@ get address of b
	LSL R2, R0, #2		@ multiply index * 4 to get array offset
	LSL R5, R0, #2
	ADD R2, R1, R2		@ R2 now has the element address
	ADD R5, R3, R5		
	PUSH {R0}		@ push R0 to stack
	ADD R0, R4, R0		@ R0 = n+i
	STR R0, [R2]		@ a[i] = n+i
	STR R0, [R5]
	ADD R0, R0, #1		@ R0 = (n+i)+1
	RSB R0, R0, #0		@ R0 = -[(n+i)+1}
	ADD R2, R2, #4		@ R2 = a[i+1]
	ADD R5, R5, #4
	STR R0, [R2]
	STR R0, [R5]
	POP {R0}		@ pop from stack to R0
	ADD R0, R0, #2		@ increment index
	B _generate		@ branch to _generate 
	
	
_sort_ascending:
	PUSH {LR}		@ backup stack pointer
_outer_loop:
	CMP R0, #19		@ R0 = j
	POPEQ {PC} 		@ restore stack pointer if equal
	LDR R3, =array_b	@ R3 contains the address of array b	
	LSL R2, R0, #2   	@ initiate the process of reading the array
	ADD R2, R3, R2		@ add R2 and R3 and store in R2
	LDR R2, [R2]		@ a[iMin] = R2
	PUSH {R2}		@ backup R2
	ADD R1, R0, #1		@ i stored in R1 (j=i+1)
_inner_loop:
	CMP R1, #20
	BEQ _compare
	LSL R7, R1, #2
	ADD R7, R3, R7
	LDR R7, [R7]		@ R7 = a[i]		
	CMP R7, R2		@ a[i] < a[iMin]
	MOVLT R2, R7		@ a[iMin]=a[i]
	MOVLT R10, R1		@ iMIN = i
	ADD R1, R1, #1		
	BL _inner_loop		@ branch to inner loop
_compare:
	POP {R5}
	CMP R2, R5
	BLNE _swap
	ADD R0, R0, #1
	B _outer_loop		@ branch to outer loop 
_swap:
	MOV R8, R2
	MOV R2, R5
	MOV R5, R8
	LSL R11, R0, #2
	ADD R11, R11, R3
	STR R5, [R11]
	LSL R9, R10, #2
	ADD R9, R9, R3
	STR R2, [R9]
	MOV PC, LR
	
_readloop:
	CMP R0, #0
	PUSHEQ {LR}
	CMP R0, #20		@ check to see if we are done iterating
	POPEQ {PC}		@ exit loop if done
	LDR R1, =array_a	@ get address of array A
	LDR R3, =array_b	@ get address of array B
	LSL R2, R0, #2		@ multiply index * 4 to get array offset
	LSL R5, R0, #2
	ADD R2, R1, R2		@ R2 now has the element address
	ADD R5, R3, R5
	LDR R1, [R2]		@ read the array at address
	LDR R3, [R5]
	PUSH {R0} 		@ backup register before printf
	PUSH {R1}		@ backup register before printf
	PUSH {R2} 		@ backup register before printf
	PUSH {R3}
	PUSH {R5}
	MOV R2, R1		@ move array value to R2 for printf
	MOV R1, R0		@ move array index to R1 for printf
	BL _printf_a		@ branch to _printf procedure with return
	POP {R5}
	POP {R3}
	POP {R2}
	POP {R1}
	POP {R0}
	PUSH {R0}
	PUSH {R1}
	PUSH {R2}
	PUSH {R3}
	PUSH {R5}
	MOV R2, R3
	MOV R1, R0
	BL _printf_b
	POP {R5}
	POP {R3}
	POP {R2}		@ restore register
	POP {R1}		@ restore register
	POP {R0}		@ restore register
	ADD R0, R0, #1		@ increment index
	B _readloop		@ branch to next loop iteration
	

_printf_a:
	PUSH {LR}		@ backup return address
	LDR R0, =printf_str_a	@ R0 contains formatted string address
	BL printf		@ call printf
	POP {PC}		@ restore the stack pointer and return

_printf_b:
	PUSH {LR}		@ backup return address
	LDR R0, =printf_str_b	@ R0 contains formatted string address
	BL printf		@ call printf
	POP {PC}		@ restore the stack pointer and return 
	
_exit:
	PUSH {LR}
	MOV R7, #4		@ write syscall, 4
	MOV R0, #1		@ output stream to monitor, 1
	MOV R2, #21		@ print string length
	LDR R1, =exit_str 	@ string at label exit_str:
	SWI 0			@ execute syscall
	MOV R7, #1		@ terminate syscall, 1
	SWI 0			@ execute syscall
	POP {PC}
	
	
.data

.balign	4
array_a:	.skip		80
array_b:	.skip		80
printf_str_a: 	.asciz		"array_a[%d] = %d, "
printf_str_b:	.asciz		"array_b[%d] = %d\n"
exit_str:	.ascii		"Terminating Program.\n"
format_str:	.asciz		"%d"
