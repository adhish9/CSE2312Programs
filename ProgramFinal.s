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
    	LDR R1, =array_a              
	LSL R2, R0, #2
    	ADD R2, R1, R2      
	STR R4, [R2]       
	ADD R0, R0, #1         
    	B _populate_array        
_populate_array_done:
	MOV R0, #0             
_printf_array:	    	
	CMP R0, #10       
    	BEQ _printf_array_done
    	LDR R1, =array_a
    	LSL R2, R0, #2
    	ADD R2, R1, R2          
	LDR R1, [R2]           
    	PUSH {R0} 	         
    	PUSH {R1}              
    	PUSH {R2}             
    	MOV R2,	R1             
    	MOV R1, R0              
    	BL  _printf             
    	POP {R2}                
	POP {R1}                
    	POP {R0}                
	ADD R0, R0, #1         
    	B   _printf_array           
_printf_array_done:
	BL _find_min
	@BL _find_max
	@MOV R1, R5
	@BL _find_sum
    	B _exit                 

_find_min:
	PUSH {LR}
	MOV R0, #0
	LDR R1, =array_a
	LSL R2, R0, #2
	ADD R2, R2, R1
	LDR R2, [R2]
_find_min_loop:
	ADD R0, R0, #1
	CMP R0, #10
	BEQ _find_min_done
	LSL R3, R0, #2
	ADD R3, R1, R3
	LDR R3, [R3]
	CMP R3, R2
	MOVLT R2, R3
	B _find_min_loop
_find_min_done:
	MOV R1, R2
	BL _printf_min
	POP {PC}

_printf_min:
	PUSH {LR}
	LDR R0, =printf_min_str
	BL printf
	POP {PC}

_scanf:
	PUSH {LR}             
    	SUB SP, SP, #4         
    	LDR R0, =format_str    
    	MOV R1, SP             
    	BL scanf               
    	LDR R0, [SP]           
    	ADD SP, SP, #4        
	POP {LR}
	MOV PC, LR

_printf:
    	PUSH {LR}               
    	LDR R0, =printf_str     
    	BL printf              
    	POP {PC}                
   

_exit:  
	MOV R7, #4              
    	MOV R0, #1             
    	MOV R2, #21             
	LDR R1, =exit_str       
	SWI 0                   
	MOV R7, #1             
	SWI 0                  

.data

.balign	4
array_a:	.skip		40
format_str:	.asciz		"%d"
printf_str: 	.asciz		"array_a[%d] = %d\n"
printf_min_str:	.asciz		"minimum = %d\n"
printf_max_str:	.asciz		"maximum = %d\n"
printf_sum_str:	.asciz		"sum = %d\n"
exit_str:	.ascii		"\n"

