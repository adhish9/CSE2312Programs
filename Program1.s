@Program1
@Adhish Deshpande
@1001104148


.global main
    .func main

main:
    BL  _prompt1             @ branch to prompt procedure with return
    BL  _scanf1             @ branch to scanf procedure with return
    MOV R4, R0              @ move return value R0 to argument register R1

    BL  _prompt2         @ branch to printf procedure with return
    BL  _scanf2            @ brach to getchar procedure with return
    MOV R5, R0              @ move return value R0 to argument register R3

    BL  _prompt3             @ branch to prompt procedure with return
    BL  _scanf3              @ branch to scanf procedure with return
    MOV R6, R0              @ move return value R0 to argument register R1

    MOV R1, R4
    MOV R2, R5
    MOV R3, R6
    BL  _comp            @ branch to compare procedure
    MOV R1, R0
    BL  _ans        @ branch to printf procedure with return

    B   main                @ branch to main procedure with no return


_prompt1:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #14             @ print string length
    LDR R1, =prompt_str1    @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_prompt2:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #11             @ print string length
    LDR R1, =prompt_str2    @ string at label cprompt_str
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_prompt3:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #15             @ print string length
    LDR R1, =prompt_str3    @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return


_ans:
    MOV R7, LR              @ store LR since printf call overwrites
    LDR R0, =ans_str     @ R0 contains formatted string address
    MOV R1, R1              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    MOV PC, R7              @ return

_comp:
    CMP R2, #'+'            @ compare against the constant char '+'
    BEQ sum                 @ branch to equal handler
    CMP R2, #'-'            @ compare against the constant char '-'
    BEQ diff          @ branch to equal handler
    CMP R2, #'*'            @ compare against the constant char '-'
    BEQ prod             @ branch to equal handler
    CMP R2, #'M'            @ compare against the constant char '-'
    BEQ max         @ branch to equal handler
    MOV PC, LR

sum:
    MOV R7, LR
    ADD R0, R1, R3          @ R0 = R1 + R3
    MOV PC, R7              @ return

diff:
    MOV R7, LR
    SUB R0, R1, R3          @ R1 - R3 = R0
    MOV PC, R7

prod:
    MOV R7, LR
    MUL R0, R1, R3          @ R0 = R1*R3
    MOV PC, R7

max:
    MOV R7, LR
    CMP R1, R3              @ compare R1, R3
    MOVLE R1, R3            @ overwrite R1 with R3 if R1 is lesser than or equal to R3
    MOV R0, R1              @ move the value from reg R1 to reg R0
    MOV PC, R7


_scanf1:
    MOV R7, LR              @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    MOV PC, R7              @ return


_scanf2:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =char_str      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return

_scanf3:
    MOV R7, LR              @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    MOV PC, R7              @ return


.data
format_str:     .asciz      "%d"
prompt_str1:    .ascii      "First number: "
prompt_str2:    .ascii      "Character: "
prompt_str3:	.ascii      "Second number: "
ans_str:     	.asciz      "Answer: %d\n"
char_str:       .ascii      " "
