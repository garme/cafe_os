.code
main:
MOV prog_str_0
SOP PUSH_OP
CALL printstr
SOP POP_OP
CALL exit
SOP POP_OP
fim_func_main:
MOV 0
SOP PUSH_OP
MOV 1
SOP PUSH_OP
INT SYSCALL_INT
overlay_exit_loop_1:
MOV 0
SOP PUSH_OP
MOV 9
SOP PUSH_OP
INT SYSCALL_INT
JMP overlay_exit_loop_1
print_char:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA print_char_ascii
LDA tmp_left
SOP PUSH_OP
LDA print_char_ascii
SOP PUSH_OP
MOV 10
SOP PUSH_OP
INT SYSCALL_INT
fim_func_print_char:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
printstr:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA printstr_str
LDA tmp_left
SOP PUSH_OP
MOV 0
STA printstr_i
LDA printstr_str
STA tmp_arr_base
LDA printstr_i
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA printstr_c
while_start_2:
LDA printstr_c
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ while_end_3
while_start_2_true:
LDA printstr_c
SOP PUSH_OP
CALL print_char
SOP POP_OP
LDA printstr_i
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA printstr_i
LDA printstr_str
STA tmp_arr_base
LDA printstr_i
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA printstr_c
JMP while_start_2
while_end_3:
fim_func_printstr:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
exit:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 0
SOP PUSH_OP
MOV 1
SOP PUSH_OP
INT SYSCALL_INT
while_start_4:
MOV 1
SUB prog_const_0
JZ while_end_5
MOV 0
SOP PUSH_OP
MOV 9
SOP PUSH_OP
INT SYSCALL_INT
JMP while_start_4
while_end_5:
fim_func_exit:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
.data
prog_str_0: INITB 72,101,108,108,111,32,111,118,101,114,108,97,121,10,0
SYSCALL_INT: DD 26
prog_const_0: DD 0
PUSH_OP: DD 0
POP_OP: DD 1
HALT_INT: DD 25
.bss
print_char_ascii: RESD 1
printstr_str: RESD 1
printstr_i: RESD 1
printstr_c: RESD 1
tmp_arr_base: RESD 1
tmp_left: RESD 1
tmp_left_cond: RESD 1
tmp_ptr: RESD 1
tmp_right: RESD 1
.stack 100
