.code
main:
JMP os_boot
JMP kernel_dispatcher
JMP kernel_syscall_handler
kernel_fault_handler:
INT CLI_INT
SOP POP_OP
SOP POP_OP
LDA current_pid
SOP PUSH_OP
LDA SIGKILL
SOP PUSH_OP
CALL kernel_kill
SOP POP_OP
CALL schedule
SOP POP_OP
JMP dispatcher_restore_context
kernel_syscall_handler:
INT CLI_INT
STA isr_tmp_ac
SOP POP_OP
STA tmp_sys_flags
SOP POP_OP
STA tmp_sys_pc
SOP POP_OP
STA tmp_sys_id
SOP POP_OP
STA tmp_sys_arg
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_3
JZ bloco_then_1
or_next_6:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_6
JZ bloco_then_1
or_next_5:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_25
JZ bloco_then_1
or_next_4:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_27
JZ bloco_then_1
or_next_3:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_29
JZ bloco_then_1
JMP fim_if_2
bloco_then_1:
SOP POP_OP
STA tmp_sys_arg2
fim_if_2:
LDA tmp_sys_pc
SOP PUSH_OP
LDA tmp_sys_flags
SOP PUSH_OP
LDA tmp_ptr
SOP PUSH_OP
LDA tmp_idx
SOP PUSH_OP
LDA tmp_lhs
SOP PUSH_OP
LDA tmp_val
SOP PUSH_OP
LDA tmp_left_cond
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
LDA tmp_right
SOP PUSH_OP
LDA tmp_arr_base
SOP PUSH_OP
LDA tmp_step
SOP PUSH_OP
LDA curr_pcb
STA main_curr
MOV $SP
STA isr_tmp_sp
LDA main_curr
ADD prog_const_2
STA tmp_lhs
LDA isr_tmp_ac
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_curr
ADD prog_const_1
STA tmp_lhs
LDA isr_tmp_sp
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA system_ticks
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA system_ticks
LDA prog_const_0
STA main_i
MOV pcb
STA tmp_arr_base
LDA tmp_arr_base
STA main_p
while_start_7:
LDA main_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_7_true
JMP while_end_8
while_start_7_true:
LDA main_p
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_TERMINATED
JZ fim_if_10
bloco_then_9:
LDA main_p
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_SLEEPING
JZ bloco_then_11
JMP fim_if_12
bloco_then_11:
LDA system_ticks
STA tmp_left_cond
LDA main_p
ADD prog_const_11
STA tmp_ptr
LDI tmp_ptr
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_13
JN fim_if_14
bloco_then_13:
LDA main_p
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_14:
fim_if_12:
LDA main_p
ADD prog_const_12
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ fim_if_16
JN fim_if_16
bloco_then_15:
LDA system_ticks
STA tmp_left_cond
LDA main_p
ADD prog_const_12
STA tmp_ptr
LDI tmp_ptr
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_17
JN fim_if_18
bloco_then_17:
LDA main_p
ADD prog_const_13
STA tmp_lhs
LDA prog_const_14
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_p
ADD prog_const_12
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_18:
fim_if_16:
fim_if_10:
LDA main_p
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
LDA tmp_right
STA tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
STA tmp_right
LDA tmp_left
ADD tmp_right
STA main_p
LDA main_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA main_i
JMP while_start_7
while_end_8:
CALL schedule
SOP POP_OP
JMP dispatcher_restore_context
kernel_dispatcher:
INT CLI_INT
STA isr_tmp_ac
LDA tmp_ptr
SOP PUSH_OP
LDA tmp_idx
SOP PUSH_OP
LDA tmp_lhs
SOP PUSH_OP
LDA tmp_val
SOP PUSH_OP
LDA tmp_left_cond
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
LDA tmp_right
SOP PUSH_OP
LDA tmp_arr_base
SOP PUSH_OP
LDA tmp_step
SOP PUSH_OP
MOV $SP
STA isr_tmp_sp
LDA curr_pcb
ADD prog_const_2
STA tmp_lhs
LDA isr_tmp_ac
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA curr_pcb
ADD prog_const_1
STA tmp_lhs
LDA isr_tmp_sp
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
CALL schedule
SOP POP_OP
dispatcher_restore_context:
LDA curr_pcb
STA main_curr
LDA main_curr
ADD prog_const_1
STA tmp_ptr
LDI tmp_ptr
STA main_target_sp
LDA main_curr
ADD prog_const_13
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ fim_if_20
JN fim_if_20
bloco_then_19:
LDA main_curr
ADD prog_const_14
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ fim_if_22
bloco_then_21:
LDA main_curr
ADD prog_const_16
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_23
JMP fim_if_24
bloco_then_23:
LDA main_curr
ADD prog_const_17
STA tmp_lhs
LDA main_target_sp
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_curr
ADD prog_const_18
STA tmp_lhs
LDA main_curr
ADD prog_const_2
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA ram
STA tmp_arr_base
LDA main_target_sp
ADD tmp_arr_base
STA main_sp_ptr
LDA main_curr
ADD prog_const_28
STA tmp_lhs
LDA main_sp_ptr
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA main_sp_ptr
LDA main_curr
ADD prog_const_27
STA tmp_lhs
LDA main_sp_ptr
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA main_sp_ptr
LDA main_curr
ADD prog_const_25
STA tmp_lhs
LDA main_sp_ptr
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA main_sp_ptr
LDA main_curr
ADD prog_const_24
STA tmp_lhs
LDA main_sp_ptr
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA main_sp_ptr
LDA main_curr
ADD prog_const_23
STA tmp_lhs
LDA main_sp_ptr
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA main_sp_ptr
LDA main_curr
ADD prog_const_22
STA tmp_lhs
LDA main_sp_ptr
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA main_sp_ptr
LDA main_curr
ADD prog_const_21
STA tmp_lhs
LDA main_sp_ptr
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA main_sp_ptr
LDA main_curr
ADD prog_const_20
STA tmp_lhs
LDA main_sp_ptr
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA main_sp_ptr
LDA main_curr
ADD prog_const_19
STA tmp_lhs
LDA main_sp_ptr
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA main_sp_ptr
LDA main_curr
ADD prog_const_26
STA tmp_lhs
LDA main_sp_ptr
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA main_sp_ptr
LDA main_curr
ADD prog_const_15
STA tmp_lhs
LDA main_sp_ptr
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_sp_ptr
STA tmp_lhs
LDA main_curr
ADD prog_const_14
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA main_curr
ADD prog_const_16
STA tmp_lhs
LDA prog_const_1
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_24:
fim_if_22:
fim_if_20:
MOV pcb
STA tmp_arr_base
LDA current_pid
STA tmp_a_mul
LDA prog_const_0
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_arr_base
ADD prog_const_1
STA tmp_ptr
LDI tmp_ptr
STA isr_tmp_sp
MOV pcb
STA tmp_arr_base
LDA current_pid
STA tmp_a_mul
LDA prog_const_0
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_arr_base
ADD prog_const_2
STA tmp_ptr
LDI tmp_ptr
STA isr_tmp_ac
LDA isr_tmp_sp
MOV -$SP
SOP POP_OP
STA tmp_step
SOP POP_OP
STA tmp_arr_base
SOP POP_OP
STA tmp_right
SOP POP_OP
STA tmp_left
SOP POP_OP
STA tmp_left_cond
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_lhs
SOP POP_OP
STA tmp_idx
SOP POP_OP
STA tmp_ptr
SOP POP_OP
STA ctx_tmp_flags
SOP POP_OP
STA ctx_tmp_pc
MOV $SP
STA isr_tmp_sp
MOV ctx_block
STA tmp_arr_base
LDA tmp_arr_base
STA tmp_lhs
LDA ctx_tmp_pc
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
MOV ctx_block
STA tmp_arr_base
LDA tmp_arr_base
ADD prog_const_1
STA tmp_lhs
LDA curr_pcb
ADD prog_const_4
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
MOV ctx_block
STA tmp_arr_base
LDA tmp_arr_base
ADD prog_const_2
STA tmp_lhs
LDA curr_pcb
ADD prog_const_5
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
MOV ctx_block
STA tmp_arr_base
LDA tmp_arr_base
ADD prog_const_3
STA tmp_lhs
LDA curr_pcb
ADD prog_const_6
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
MOV ctx_block
STA tmp_arr_base
LDA tmp_arr_base
ADD prog_const_4
STA tmp_lhs
LDA isr_tmp_sp
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
MOV ctx_block
STA tmp_arr_base
LDA tmp_arr_base
ADD prog_const_5
STA tmp_lhs
LDA isr_tmp_ac
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
MOV ctx_block
STA tmp_arr_base
LDA tmp_arr_base
ADD prog_const_6
STA tmp_lhs
LDA ctx_tmp_flags
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
MOV ctx_block
INT CTXSW_INT
os_boot:
INT CLI_INT
LDA prog_const_0
STA main_i
for_start_25:
LDA main_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN for_start_25_true
JMP for_end_27
for_start_25_true:
MOV pcb
STA tmp_arr_base
LDA main_i
STA tmp_a_mul
LDA prog_const_0
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_arr_base
STA tmp_lhs
LDA STATE_TERMINATED
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
for_inc_26:
MOV main_i
STA tmp_ptr
LDI tmp_ptr
STA tmp_old_val
ADD prog_const_1
STI tmp_ptr
LDA tmp_old_val
JMP for_start_25
for_end_27:
LDA prog_const_0
STA ram
MOV os_heap
STA HEAP_START
CALL init_heap
SOP POP_OP
CALL boot_overlays
SOP POP_OP
LDA prog_const_0
STA current_pid
MOV pcb
STA tmp_arr_base
LDA tmp_arr_base
STA curr_pcb
MOV pcb
STA tmp_arr_base
LDA tmp_arr_base
STA tmp_lhs
LDA STATE_RUNNING
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
MOV pcb
STA tmp_arr_base
LDA tmp_arr_base
ADD prog_const_1
STA tmp_ptr
LDI tmp_ptr
STA isr_tmp_sp
MOV pcb
STA tmp_arr_base
LDA tmp_arr_base
ADD prog_const_2
STA tmp_ptr
LDI tmp_ptr
STA isr_tmp_ac
JMP dispatcher_restore_context
fim_func_main:
INT HALT_INT
schedule:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV pcb
STA tmp_arr_base
LDA current_pid
STA tmp_a_mul
LDA prog_const_0
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_arr_base
STA schedule_curr
LDA schedule_curr
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_RUNNING
JZ bloco_then_28
JMP fim_if_29
bloco_then_28:
LDA schedule_curr
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_29:
LDA prog_const_0
STA schedule_any_alive
LDA prog_const_0
STA schedule_i
while_start_30:
LDA schedule_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_30_true
JMP while_end_31
while_start_30_true:
MOV pcb
STA tmp_arr_base
LDA schedule_i
STA tmp_a_mul
LDA prog_const_0
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_arr_base
STA schedule_p
LDA schedule_p
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_TERMINATED
JZ fim_if_33
bloco_then_32:
LDA prog_const_1
STA schedule_any_alive
fim_if_33:
LDA schedule_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA schedule_i
JMP while_start_30
while_end_31:
LDA schedule_any_alive
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_34
JMP fim_if_35
bloco_then_34:
INT CLI_INT
INT HALT_INT
while_start_36:
LDA prog_const_1
SUB prog_const_0
JZ while_end_37
JMP while_start_36
while_end_37:
fim_if_35:
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA schedule_next_pid
while_start_38:
LDA schedule_next_pid
STA tmp_left_cond
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ while_start_38_true
JMP while_end_39
while_start_38_true:
LDA prog_const_1
STA schedule_i
while_start_40:
LDA schedule_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_40_true
JZ while_start_40_true
JMP while_end_41
while_start_40_true:
LDA current_pid
STA tmp_left
LDA schedule_i
STA tmp_right
LDA tmp_left
ADD tmp_right
STA schedule_temp_pid
LDA schedule_temp_pid
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JZ bloco_then_42
JN fim_if_43
bloco_then_42:
LDA schedule_temp_pid
STA tmp_left
LDA MAX_PROCESSES
STA tmp_right
LDA tmp_left
SUB tmp_right
STA schedule_temp_pid
fim_if_43:
MOV pcb
STA tmp_arr_base
LDA schedule_temp_pid
STA tmp_a_mul
LDA prog_const_0
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_arr_base
STA schedule_p
LDA schedule_p
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_READY
JZ bloco_then_44
JMP bloco_else_45
bloco_then_44:
LDA schedule_temp_pid
STA schedule_next_pid
LDA MAX_PROCESSES
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA schedule_i
JMP fim_if_46
bloco_else_45:
LDA schedule_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA schedule_i
fim_if_46:
JMP while_start_40
while_end_41:
LDA schedule_next_pid
STA tmp_left_cond
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_47
JMP fim_if_48
bloco_then_47:
LDA system_ticks
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA system_ticks
LDA prog_const_0
STA schedule_i
while_start_49:
LDA schedule_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_49_true
JMP while_end_50
while_start_49_true:
MOV pcb
STA tmp_arr_base
LDA schedule_i
STA tmp_a_mul
LDA prog_const_0
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_arr_base
STA schedule_p
LDA schedule_p
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_SLEEPING
JZ bloco_then_51
JMP fim_if_52
bloco_then_51:
LDA system_ticks
STA tmp_left_cond
LDA schedule_p
ADD prog_const_11
STA tmp_ptr
LDI tmp_ptr
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_53
JN fim_if_54
bloco_then_53:
LDA schedule_p
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_54:
fim_if_52:
LDA schedule_p
ADD prog_const_12
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ fim_if_56
JN fim_if_56
bloco_then_55:
LDA system_ticks
STA tmp_left_cond
LDA schedule_p
ADD prog_const_12
STA tmp_ptr
LDI tmp_ptr
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_57
JN fim_if_58
bloco_then_57:
LDA schedule_p
ADD prog_const_13
STA tmp_lhs
LDA prog_const_14
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA schedule_p
ADD prog_const_12
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA schedule_p
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_PAUSED
JZ bloco_then_59
JMP fim_if_60
bloco_then_59:
LDA schedule_p
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_60:
fim_if_58:
fim_if_56:
LDA schedule_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA schedule_i
JMP while_start_49
while_end_50:
fim_if_48:
JMP while_start_38
while_end_39:
LDA schedule_next_pid
STA current_pid
MOV pcb
STA tmp_arr_base
LDA current_pid
STA tmp_a_mul
LDA prog_const_0
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_arr_base
STA curr_pcb
LDA curr_pcb
STA tmp_lhs
LDA STATE_RUNNING
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA curr_pcb
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_TERMINATED
JZ bloco_then_61
JMP fim_if_62
bloco_then_61:
INT CLI_INT
INT HALT_INT
fim_if_62:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_schedule:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
init_heap:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA ram
STA tmp_arr_base
LDA HEAP_START
ADD tmp_arr_base
STA tmp_lhs
LDA HEAP_SIZE
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA ram
STA tmp_arr_base
LDA HEAP_START
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_lhs
LDA prog_const_1
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_func_init_heap:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
malloc:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA malloc_size
LDA tmp_left
SOP PUSH_OP
LDA HEAP_START
STA malloc_ptr
LDA malloc_size
STA malloc_needed_size
LDA malloc_needed_size
STA tmp_left
LDA prog_const_2
STA tmp_right
LDA tmp_left
ADD tmp_right
STA malloc_needed_size
while_start_63:
LDA malloc_ptr
STA tmp_left_cond
LDA HEAP_START
STA tmp_left
LDA HEAP_SIZE
STA tmp_right
LDA tmp_left
ADD tmp_right
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JN while_start_63_true
JMP while_end_64
while_start_63_true:
LDA ram
STA tmp_arr_base
LDA malloc_ptr
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA malloc_block_size
LDA ram
STA tmp_arr_base
LDA malloc_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA malloc_is_free
LDA malloc_is_free
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_65
JMP fim_if_66
bloco_then_65:
LDA malloc_block_size
STA tmp_left_cond
LDA tmp_left_cond
SUB malloc_needed_size
JZ bloco_then_67
JN fim_if_68
bloco_then_67:
LDA ram
STA tmp_arr_base
LDA malloc_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA malloc_block_size
STA tmp_left
LDA malloc_needed_size
STA tmp_right
LDA tmp_left
SUB tmp_right
STA malloc_remaining
LDA malloc_remaining
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_2
JZ fim_if_70
JN fim_if_70
bloco_then_69:
LDA ram
STA tmp_arr_base
LDA malloc_ptr
ADD tmp_arr_base
STA tmp_lhs
LDA malloc_needed_size
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA malloc_ptr
STA tmp_left
LDA malloc_needed_size
STA tmp_right
LDA tmp_left
ADD tmp_right
STA malloc_next_ptr
LDA ram
STA tmp_arr_base
LDA malloc_next_ptr
ADD tmp_arr_base
STA tmp_lhs
LDA malloc_remaining
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA ram
STA tmp_arr_base
LDA malloc_next_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_lhs
LDA prog_const_1
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_70:
LDA malloc_ptr
STA tmp_left
LDA prog_const_2
STA tmp_right
LDA tmp_left
ADD tmp_right
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_68:
fim_if_66:
LDA malloc_ptr
STA tmp_left
LDA malloc_block_size
STA tmp_right
LDA tmp_left
ADD tmp_right
STA malloc_ptr
JMP while_start_63
while_end_64:
LDA prog_const_0
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_malloc:
RET
free:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA free_ptr
LDA tmp_left
SOP PUSH_OP
LDA free_ptr
STA tmp_left
LDA prog_const_2
STA tmp_right
LDA tmp_left
SUB tmp_right
STA free_header_ptr
LDA ram
STA tmp_arr_base
LDA free_header_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_lhs
LDA prog_const_1
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
CALL kernel_defrag
SOP POP_OP
fim_func_free:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_defrag:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA HEAP_START
STA kernel_defrag_ptr
while_start_71:
LDA kernel_defrag_ptr
STA tmp_left_cond
LDA HEAP_START
STA tmp_left
LDA HEAP_SIZE
STA tmp_right
LDA tmp_left
ADD tmp_right
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JN while_start_71_true
JMP while_end_72
while_start_71_true:
LDA ram
STA tmp_arr_base
LDA kernel_defrag_ptr
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_defrag_block_size
LDA ram
STA tmp_arr_base
LDA kernel_defrag_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_defrag_is_free
LDA kernel_defrag_is_free
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_73
JMP bloco_else_74
bloco_then_73:
LDA kernel_defrag_ptr
STA tmp_left
LDA kernel_defrag_block_size
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_defrag_next_ptr
LDA prog_const_0
STA kernel_defrag_merged
LDA kernel_defrag_next_ptr
STA tmp_left_cond
LDA HEAP_START
STA tmp_left
LDA HEAP_SIZE
STA tmp_right
LDA tmp_left
ADD tmp_right
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JN bloco_then_76
JMP fim_if_77
bloco_then_76:
LDA ram
STA tmp_arr_base
LDA kernel_defrag_next_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_defrag_next_is_free
LDA kernel_defrag_next_is_free
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_78
JMP fim_if_79
bloco_then_78:
LDA ram
STA tmp_arr_base
LDA kernel_defrag_next_ptr
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_defrag_next_size
LDA ram
STA tmp_arr_base
LDA kernel_defrag_ptr
ADD tmp_arr_base
STA tmp_lhs
LDA kernel_defrag_block_size
STA tmp_left
LDA kernel_defrag_next_size
STA tmp_right
LDA tmp_left
ADD tmp_right
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA prog_const_1
STA kernel_defrag_merged
fim_if_79:
fim_if_77:
LDA kernel_defrag_merged
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_80
JMP fim_if_81
bloco_then_80:
LDA kernel_defrag_next_ptr
STA kernel_defrag_ptr
fim_if_81:
JMP fim_if_75
bloco_else_74:
LDA kernel_defrag_ptr
STA tmp_left
LDA kernel_defrag_block_size
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_defrag_ptr
fim_if_75:
JMP while_start_71
while_end_72:
fim_func_kernel_defrag:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
wakeup_waiters:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA wakeup_waiters_dead_pid
LDA tmp_left
SOP PUSH_OP
LDA prog_const_0
STA wakeup_waiters_i
MOV pcb
STA tmp_arr_base
LDA tmp_arr_base
STA wakeup_waiters_p
while_start_82:
LDA wakeup_waiters_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_82_true
JMP while_end_83
while_start_82_true:
LDA wakeup_waiters_p
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_WAITING
JZ bloco_then_84
JMP fim_if_85
bloco_then_84:
LDA wakeup_waiters_p
ADD prog_const_10
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB wakeup_waiters_dead_pid
JZ bloco_then_86
JMP fim_if_87
bloco_then_86:
LDA wakeup_waiters_p
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA wakeup_waiters_p
ADD prog_const_10
STA tmp_lhs
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_87:
fim_if_85:
LDA wakeup_waiters_p
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
LDA tmp_right
STA tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
ADD tmp_step
STA tmp_right
LDA tmp_left
ADD tmp_right
STA wakeup_waiters_p
LDA wakeup_waiters_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA wakeup_waiters_i
JMP while_start_82
while_end_83:
fim_func_wakeup_waiters:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_kill:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_kill_signal
SOP POP_OP
STA kernel_kill_target_pid
LDA tmp_left
SOP PUSH_OP
MOV pcb
STA tmp_arr_base
LDA kernel_kill_target_pid
STA tmp_a_mul
LDA prog_const_0
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_arr_base
STA kernel_kill_target
LDA kernel_kill_target
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_TERMINATED
JZ fim_if_89
bloco_then_88:
LDA kernel_kill_signal
STA tmp_left_cond
LDA tmp_left_cond
SUB SIGKILL
JZ bloco_then_90
JMP bloco_else_91
bloco_then_90:
LDA kernel_kill_target
STA tmp_lhs
LDA STATE_TERMINATED
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_kill_target
ADD prog_const_9
STA tmp_ptr
LDI tmp_ptr
SOP PUSH_OP
CALL free
SOP POP_OP
LDA kernel_kill_target_pid
SOP PUSH_OP
CALL wakeup_waiters
SOP POP_OP
JMP fim_if_92
bloco_else_91:
LDA kernel_kill_target
ADD prog_const_13
STA tmp_lhs
LDA kernel_kill_signal
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_kill_target
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_PAUSED
JZ bloco_then_93
JMP fim_if_94
bloco_then_93:
LDA kernel_kill_target
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_94:
fim_if_92:
fim_if_89:
fim_func_kernel_kill:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
create_process_overlay:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA create_process_overlay_mem_base
SOP POP_OP
STA create_process_overlay_priority
SOP POP_OP
STA create_process_overlay_stack_base
SOP POP_OP
STA create_process_overlay_ds_base
SOP POP_OP
STA create_process_overlay_cs_base
SOP POP_OP
STA create_process_overlay_entry_pc
SOP POP_OP
STA create_process_overlay_pid
LDA tmp_left
SOP PUSH_OP
MOV pcb
STA tmp_arr_base
LDA create_process_overlay_pid
STA tmp_a_mul
LDA prog_const_0
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_arr_base
STA create_process_overlay_p
LDA create_process_overlay_p
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_1
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_2
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_3
STA tmp_lhs
LDA create_process_overlay_entry_pc
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_4
STA tmp_lhs
LDA create_process_overlay_cs_base
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_5
STA tmp_lhs
LDA create_process_overlay_ds_base
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_6
STA tmp_lhs
LDA KERNEL_SS
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_7
STA tmp_lhs
LDA create_process_overlay_priority
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_8
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_9
STA tmp_lhs
LDA create_process_overlay_mem_base
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_10
STA tmp_lhs
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_11
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_12
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_13
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_14
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_15
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_16
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_17
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_18
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_19
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_20
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_21
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_22
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_23
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_24
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_25
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_27
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_28
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_26
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA ram
STA tmp_arr_base
LDA create_process_overlay_stack_base
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
ADD tmp_arr_base
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
LDA create_process_overlay_entry_pc
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
LDA prog_const_8
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_1
STA tmp_lhs
LDA create_process_overlay_stack_base
STA tmp_left
LDA prog_const_11
STA tmp_right
LDA tmp_left
SUB tmp_right
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_func_create_process_overlay:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_spawn_overlay:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_spawn_overlay_priority
SOP POP_OP
STA kernel_spawn_overlay_overlay_img
LDA tmp_left
SOP PUSH_OP
LDA ram
STA tmp_arr_base
LDA kernel_spawn_overlay_overlay_img
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB OVERLAY_MAGIC
JZ fim_if_96
bloco_then_95:
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_96:
LDA prog_const_0
STA kernel_spawn_overlay_i
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA kernel_spawn_overlay_free_pid
while_start_97:
LDA kernel_spawn_overlay_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN and_next_99
JMP while_end_98
and_next_99:
LDA kernel_spawn_overlay_free_pid
STA tmp_left_cond
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ while_start_97_true
JMP while_end_98
while_start_97_true:
MOV pcb
STA tmp_arr_base
LDA kernel_spawn_overlay_i
STA tmp_a_mul
LDA prog_const_0
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_res_mul
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_TERMINATED
JZ bloco_then_100
JMP fim_if_101
bloco_then_100:
LDA kernel_spawn_overlay_i
STA kernel_spawn_overlay_free_pid
fim_if_101:
LDA kernel_spawn_overlay_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_spawn_overlay_i
JMP while_start_97
while_end_98:
LDA kernel_spawn_overlay_free_pid
STA tmp_left_cond
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_102
JMP fim_if_103
bloco_then_102:
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_103:
LDA ram
STA tmp_arr_base
LDA kernel_spawn_overlay_overlay_img
STA tmp_left
LDA prog_const_2
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_spawn_overlay_entry_pc
LDA ram
STA tmp_arr_base
LDA kernel_spawn_overlay_overlay_img
STA tmp_left
LDA prog_const_3
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_spawn_overlay_text_size
LDA ram
STA tmp_arr_base
LDA kernel_spawn_overlay_overlay_img
STA tmp_left
LDA prog_const_4
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_spawn_overlay_data_size
LDA ram
STA tmp_arr_base
LDA kernel_spawn_overlay_overlay_img
STA tmp_left
LDA prog_const_5
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_spawn_overlay_bss_size
LDA ram
STA tmp_arr_base
LDA kernel_spawn_overlay_overlay_img
STA tmp_left
LDA prog_const_6
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_spawn_overlay_stack_size
LDA kernel_spawn_overlay_stack_size
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_104
JMP fim_if_105
bloco_then_104:
LDA prog_const_40
STA kernel_spawn_overlay_stack_size
fim_if_105:
LDA kernel_spawn_overlay_overlay_img
STA tmp_left
LDA OVERLAY_HEADER_SIZE
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_spawn_overlay_text_off
LDA kernel_spawn_overlay_text_off
STA tmp_left
LDA kernel_spawn_overlay_text_size
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_spawn_overlay_data_off
LDA kernel_spawn_overlay_stack_size
SOP PUSH_OP
CALL malloc
SOP POP_OP
STA kernel_spawn_overlay_mem
LDA kernel_spawn_overlay_mem
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_106
JMP fim_if_107
bloco_then_106:
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_107:
LDA kernel_spawn_overlay_free_pid
SOP PUSH_OP
LDA kernel_spawn_overlay_entry_pc
SOP PUSH_OP
LDA KERNEL_DS
STA tmp_left
LDA kernel_spawn_overlay_text_off
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
LDA KERNEL_DS
STA tmp_left
LDA kernel_spawn_overlay_data_off
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
LDA kernel_spawn_overlay_mem
STA tmp_left
LDA kernel_spawn_overlay_stack_size
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
LDA kernel_spawn_overlay_priority
SOP PUSH_OP
LDA kernel_spawn_overlay_mem
SOP PUSH_OP
CALL create_process_overlay
SOP POP_OP
LDA kernel_spawn_overlay_free_pid
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_kernel_spawn_overlay:
RET
boot_overlays:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV app_counter_overlay
STA overlay_addr_0
LDA overlay_addr_0
SOP PUSH_OP
LDA prog_const_4
SOP PUSH_OP
CALL kernel_spawn_overlay
SOP POP_OP
fim_func_boot_overlays:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
.data

; ==== OVERLAYS INJETADOS ====
; --- overlay app_counter_overlay ---
app_counter_overlay: INITD 51966, 1, 0, 247, 15, 29, 100
app_counter_overlay_text:
    INITD 0x0006, 0x1010, 0x0007, 0x5006, 0xa01d, 0x7000, 0x600c, 0x3047, 0x600d, 0x0010, 0x600c, 0x3075
    INITD 0x600d, 0x0008, 0x600c, 0x3023, 0x600d, 0x0010, 0x1026, 0x0007, 0x102a, 0x0026, 0x402a, 0x1010
    INITD 0x0009, 0x600c, 0x3035, 0x600d, 0x8002, 0x7000, 0x600c, 0x7001, 0x600c, 0x2005, 0x8022, 0x600d
    INITD 0x1026, 0x600d, 0x1011, 0x0026, 0x600c, 0x0011, 0x600c, 0x700a, 0x600c, 0x2005, 0x600d, 0x1026
    INITD 0x0006, 0x600c, 0x0026, 0x600c, 0xf000, 0x600d, 0x1026, 0x600d, 0x1012, 0x0026, 0x600c, 0x0012
    INITD 0x600c, 0x700c, 0x600c, 0x2005, 0x600d, 0x1026, 0x0006, 0x600c, 0x0026, 0x600c, 0xf000, 0x600d
    INITD 0x1026, 0x600d, 0x1013, 0x0026, 0x600c, 0x0006, 0x1014, 0x0013, 0x1025, 0x0014, 0x4025, 0x1029
    INITD 0xb029, 0x1015, 0x0015, 0x1027, 0x0027, 0x5006, 0xa06e, 0x0015, 0x600c, 0x3023, 0x600d, 0x0014
    INITD 0x1026, 0x0007, 0x102a, 0x0026, 0x402a, 0x1014, 0x0013, 0x1025, 0x0014, 0x4025, 0x1029, 0xb029
    INITD 0x1015, 0x8056, 0x600d, 0x1026, 0x0006, 0x600c, 0x0026, 0x600c, 0xf000, 0x600d, 0x1026, 0x600d
    INITD 0x1016, 0x0026, 0x600c, 0x0016, 0x1027, 0x0027, 0x5006, 0xa081, 0x8086, 0x000a, 0x600c, 0x3023
    INITD 0x600d, 0x80f0, 0x0016, 0x1027, 0x0027, 0x5006, 0x908c, 0x8097, 0x000b, 0x600c, 0x3023, 0x600d
    INITD 0x0006, 0x1026, 0x0016, 0x102a, 0x0026, 0x502a, 0x1016, 0x0006, 0x1023, 0x0016, 0x1027, 0x0027
    INITD 0x5006, 0xa0d2, 0x90d2, 0x0006, 0x1017, 0x0016, 0x1018, 0x0018, 0x1027, 0x0027, 0x5008, 0xa0a9
    INITD 0x90b8, 0x0018, 0x1026, 0x0008, 0x102a, 0x0026, 0x502a, 0x1018, 0x0017, 0x1026, 0x0007, 0x102a
    INITD 0x0026, 0x402a, 0x1017, 0x80a3, 0x7019, 0x1025, 0x0023, 0x4025, 0x1028, 0x0018, 0x1026, 0x000a
    INITD 0x102a, 0x0026, 0x402a, 0x102b, 0x0028, 0x1029, 0x002b, 0xc029, 0x0023, 0x1026, 0x0007, 0x102a
    INITD 0x0026, 0x402a, 0x1023, 0x0017, 0x1016, 0x8099, 0x0023, 0x1026, 0x0007, 0x102a, 0x0026, 0x502a
    INITD 0x1024, 0x0024, 0x1027, 0x0027, 0x5006, 0xa0df, 0x90f0, 0x7019, 0x1025, 0x0024, 0x4025, 0x1029
    INITD 0xb029, 0x600c, 0x3023, 0x600d, 0x0024, 0x1026, 0x0007, 0x102a, 0x0026, 0x502a, 0x1024, 0x80d9
    INITD 0x600d, 0x1026, 0x0006, 0x600c, 0x0026, 0x600c, 0xf000
app_counter_overlay_data:
    INITD 0x0041, 0x0050, 0x0050, 0x0020, 0x0000, 0x001a, 0x0000, 0x0001, 0x000a, 0x0005, 0x0030, 0x002d
    INITD 0x0000, 0x0001, 0x0019
app_counter_overlay_bss:
    INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
    INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
    INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
; --- end overlay app_counter_overlay ---


STATE_READY: DD 0
STATE_RUNNING: DD 1
STATE_BLOCKED: DD 2
STATE_TERMINATED: DD 3
STATE_WAITING: DD 4
STATE_SLEEPING: DD 5
STATE_PAUSED: DD 6
STATE_WAITING_PIPE_READ: DD 7
STATE_WAITING_PIPE_WRITE: DD 8
SIGKILL: DD 9
SIGALRM: DD 14
SIGTERM: DD 15
SIGCONT: DD 18
IN_INT: DD 20
OUT_INT: DD 21
TIMER_INT: DD 22
CLI_INT: DD 23
IRET_INT: DD 24
HALT_INT: DD 25
SYSCALL_INT: DD 26
CTXSW_INT: DD 27
KERNEL_CS: DD 0
KERNEL_DS: DD 4096
KERNEL_SS: DD 4096
system_ticks: DD 0
MAX_PROCESSES: DD 3
HEAP_SIZE: DD 250
shm_count: DD 0
PIPE_SIZE: DD 20
pipe_head: DD 0
pipe_tail: DD 0
pipe_count: DD 0
SEM_STATE: DD 0
MUTEX_ZERO: DD 0
MUTEX_STATE: DD 0
OVERLAY_MAGIC: DD 51966
OVERLAY_HEADER_SIZE: DD 7
prog_const_3: DD 3
prog_const_6: DD 6
prog_const_25: DD 25
prog_const_27: DD 27
prog_const_29: DD 29
prog_const_2: DD 2
prog_const_1: DD 1
prog_const_0: DD 0
prog_const_11: DD 11
prog_const_12: DD 12
prog_const_13: DD 13
prog_const_14: DD 14
prog_const_16: DD 16
prog_const_17: DD 17
prog_const_18: DD 18
prog_const_28: DD 28
prog_const_24: DD 24
prog_const_23: DD 23
prog_const_22: DD 22
prog_const_21: DD 21
prog_const_20: DD 20
prog_const_19: DD 19
prog_const_26: DD 26
prog_const_15: DD 15
prog_const_4: DD 4
prog_const_5: DD 5
prog_const_10: DD 10
prog_const_9: DD 9
prog_const_7: DD 7
prog_const_8: DD 8
prog_const_40: DD 40
PUSH_OP: DD 0
POP_OP: DD 1
HALT_INT: DD 25
.bss
pcb: RESD 87
current_pid: RESD 1
curr_pcb: RESD 1
ram: RESD 1
os_heap: RESD 250
HEAP_START: RESD 1
shm_keys: RESD 5
shm_addrs: RESD 5
pipe_buffer: RESD 20
tmp_lock_ret: RESD 1
ipc_mailbox: RESD 2
overlay_addr_0: RESD 1
isr_tmp_ac: RESD 1
isr_tmp_sp: RESD 1
tmp_sys_flags: RESD 1
tmp_sys_pc: RESD 1
tmp_sys_id: RESD 1
tmp_sys_arg: RESD 1
tmp_sys_arg2: RESD 1
tmp_sys_arg3: RESD 1
ctx_block: RESD 7
ctx_tmp_flags: RESD 1
ctx_tmp_pc: RESD 1
main_curr: RESD 1
main_i: RESD 1
main_p: RESD 1
main_target_sp: RESD 1
main_sp_ptr: RESD 1
schedule_i: RESD 1
schedule_next_pid: RESD 1
schedule_any_alive: RESD 1
schedule_temp_pid: RESD 1
schedule_curr: RESD 1
schedule_p: RESD 1
malloc_size: RESD 1
malloc_ptr: RESD 1
malloc_needed_size: RESD 1
malloc_block_size: RESD 1
malloc_is_free: RESD 1
malloc_remaining: RESD 1
malloc_next_ptr: RESD 1
free_ptr: RESD 1
free_header_ptr: RESD 1
kernel_defrag_ptr: RESD 1
kernel_defrag_block_size: RESD 1
kernel_defrag_is_free: RESD 1
kernel_defrag_next_ptr: RESD 1
kernel_defrag_next_is_free: RESD 1
kernel_defrag_next_size: RESD 1
kernel_defrag_merged: RESD 1
wakeup_waiters_dead_pid: RESD 1
wakeup_waiters_i: RESD 1
wakeup_waiters_p: RESD 1
kernel_kill_signal: RESD 1
kernel_kill_target_pid: RESD 1
kernel_kill_target: RESD 1
create_process_overlay_mem_base: RESD 1
create_process_overlay_priority: RESD 1
create_process_overlay_stack_base: RESD 1
create_process_overlay_ds_base: RESD 1
create_process_overlay_cs_base: RESD 1
create_process_overlay_entry_pc: RESD 1
create_process_overlay_pid: RESD 1
create_process_overlay_p: RESD 1
create_process_overlay_sp_ptr: RESD 1
kernel_spawn_overlay_priority: RESD 1
kernel_spawn_overlay_overlay_img: RESD 1
kernel_spawn_overlay_i: RESD 1
kernel_spawn_overlay_free_pid: RESD 1
kernel_spawn_overlay_entry_pc: RESD 1
kernel_spawn_overlay_text_size: RESD 1
kernel_spawn_overlay_data_size: RESD 1
kernel_spawn_overlay_bss_size: RESD 1
kernel_spawn_overlay_stack_size: RESD 1
kernel_spawn_overlay_text_off: RESD 1
kernel_spawn_overlay_data_off: RESD 1
kernel_spawn_overlay_mem: RESD 1
tmp_a_mul: RESD 1
tmp_arr_base: RESD 1
tmp_idx: RESD 1
tmp_left: RESD 1
tmp_left_cond: RESD 1
tmp_lhs: RESD 1
tmp_old_val: RESD 1
tmp_ptr: RESD 1
tmp_res_mul: RESD 1
tmp_right: RESD 1
tmp_right_cond: RESD 1
tmp_step: RESD 1
tmp_val: RESD 1
.stack 100

