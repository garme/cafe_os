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
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_19
JMP fim_if_20
bloco_then_19:
CALL kernel_exit
SOP POP_OP
fim_if_20:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_2
JZ bloco_then_21
JMP fim_if_22
bloco_then_21:
LDA tmp_sys_arg
SOP PUSH_OP
CALL kernel_wait
SOP POP_OP
fim_if_22:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_3
JZ bloco_then_23
JMP fim_if_24
bloco_then_23:
LDA tmp_sys_arg
SOP PUSH_OP
LDA tmp_sys_arg2
SOP PUSH_OP
CALL kernel_kill
SOP POP_OP
fim_if_24:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_4
JZ bloco_then_25
JMP fim_if_26
bloco_then_25:
CALL kernel_sem_lock
SOP POP_OP
fim_if_26:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_5
JZ bloco_then_27
JMP fim_if_28
bloco_then_27:
CALL kernel_sem_unlock
SOP POP_OP
fim_if_28:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_6
JZ bloco_then_29
JMP fim_if_30
bloco_then_29:
LDA tmp_sys_arg
SOP PUSH_OP
LDA tmp_sys_arg2
SOP PUSH_OP
CALL kernel_spawn
SOP POP_OP
STA isr_tmp_ac
LDA curr_pcb
ADD prog_const_2
STA tmp_lhs
LDA isr_tmp_ac
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_30:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_7
JZ bloco_then_31
JMP fim_if_32
bloco_then_31:
CALL kernel_mutex_trylock
SOP POP_OP
STA isr_tmp_ac
LDA curr_pcb
ADD prog_const_2
STA tmp_lhs
LDA isr_tmp_ac
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_32:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_8
JZ bloco_then_33
JMP fim_if_34
bloco_then_33:
CALL kernel_mutex_unlock
SOP POP_OP
fim_if_34:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_9
JZ bloco_then_35
JMP fim_if_36
bloco_then_35:
fim_if_36:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_10
JZ bloco_then_37
JMP fim_if_38
bloco_then_37:
LDA tmp_sys_arg
SOP PUSH_OP
CALL kernel_print_char
SOP POP_OP
fim_if_38:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_11
JZ bloco_then_39
JMP fim_if_40
bloco_then_39:
CALL kernel_read_char
SOP POP_OP
STA isr_tmp_ac
LDA curr_pcb
ADD prog_const_2
STA tmp_lhs
LDA isr_tmp_ac
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_40:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_12
JZ bloco_then_41
JMP fim_if_42
bloco_then_41:
LDA tmp_sys_arg
SOP PUSH_OP
CALL kernel_sleep
SOP POP_OP
fim_if_42:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_13
JZ bloco_then_43
JMP fim_if_44
bloco_then_43:
LDA tmp_sys_arg
SOP PUSH_OP
CALL kernel_alarm
SOP POP_OP
fim_if_44:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_14
JZ bloco_then_45
JMP fim_if_46
bloco_then_45:
CALL kernel_pause
SOP POP_OP
fim_if_46:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_15
JZ bloco_then_47
JMP fim_if_48
bloco_then_47:
LDA tmp_sys_arg
SOP PUSH_OP
CALL kernel_signal
SOP POP_OP
fim_if_48:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_16
JZ bloco_then_49
JMP fim_if_50
bloco_then_49:
CALL kernel_sigreturn
SOP POP_OP
fim_if_50:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_17
JZ bloco_then_51
JMP fim_if_52
bloco_then_51:
CALL kernel_get_signal
SOP POP_OP
STA isr_tmp_ac
LDA curr_pcb
ADD prog_const_2
STA tmp_lhs
LDA isr_tmp_ac
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_52:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_20
JZ bloco_then_53
JMP fim_if_54
bloco_then_53:
LDA tmp_sys_arg
SOP PUSH_OP
CALL kernel_write_pipe
SOP POP_OP
STA isr_tmp_ac
LDA curr_pcb
ADD prog_const_2
STA tmp_lhs
LDA isr_tmp_ac
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_54:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_21
JZ bloco_then_55
JMP fim_if_56
bloco_then_55:
CALL kernel_read_pipe
SOP POP_OP
STA isr_tmp_ac
LDA curr_pcb
ADD prog_const_2
STA tmp_lhs
LDA isr_tmp_ac
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_56:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_25
JZ bloco_then_57
JMP fim_if_58
bloco_then_57:
LDA tmp_sys_arg
SOP PUSH_OP
LDA tmp_sys_arg2
SOP PUSH_OP
CALL kernel_shmget
SOP POP_OP
STA isr_tmp_ac
LDA curr_pcb
ADD prog_const_2
STA tmp_lhs
LDA isr_tmp_ac
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_58:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_27
JZ bloco_then_59
JMP fim_if_60
bloco_then_59:
LDA tmp_sys_arg
SOP PUSH_OP
LDA tmp_sys_arg2
SOP PUSH_OP
CALL kernel_msg_send
SOP POP_OP
STA isr_tmp_ac
LDA curr_pcb
ADD prog_const_2
STA tmp_lhs
LDA isr_tmp_ac
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_60:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_28
JZ bloco_then_61
JMP fim_if_62
bloco_then_61:
CALL kernel_msg_recv
SOP POP_OP
STA isr_tmp_ac
LDA curr_pcb
ADD prog_const_2
STA tmp_lhs
LDA isr_tmp_ac
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_62:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_29
JZ bloco_then_63
JMP fim_if_64
bloco_then_63:
LDA tmp_sys_arg
SOP PUSH_OP
LDA tmp_sys_arg2
SOP PUSH_OP
CALL kernel_thread_create
SOP POP_OP
STA isr_tmp_ac
LDA curr_pcb
ADD prog_const_2
STA tmp_lhs
LDA isr_tmp_ac
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_64:
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
JZ fim_if_66
JN fim_if_66
bloco_then_65:
LDA main_curr
ADD prog_const_14
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ fim_if_68
bloco_then_67:
LDA main_curr
ADD prog_const_16
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_69
JMP fim_if_70
bloco_then_69:
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
fim_if_70:
fim_if_68:
fim_if_66:
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
for_start_71:
LDA main_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN for_start_71_true
JMP for_end_73
for_start_71_true:
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
for_inc_72:
MOV main_i
STA tmp_ptr
LDI tmp_ptr
STA tmp_old_val
ADD prog_const_1
STI tmp_ptr
LDA tmp_old_val
JMP for_start_71
for_end_73:
LDA prog_const_0
STA ram
MOV os_heap
STA HEAP_START
CALL init_heap
SOP POP_OP
CALL init_ipc_shm
SOP POP_OP
CALL init_ipc_mailbox
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
JZ bloco_then_74
JMP fim_if_75
bloco_then_74:
LDA schedule_curr
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_75:
LDA prog_const_0
STA schedule_any_alive
LDA prog_const_0
STA schedule_i
while_start_76:
LDA schedule_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_76_true
JMP while_end_77
while_start_76_true:
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
JZ fim_if_79
bloco_then_78:
LDA prog_const_1
STA schedule_any_alive
fim_if_79:
LDA schedule_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA schedule_i
JMP while_start_76
while_end_77:
LDA schedule_any_alive
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_80
JMP fim_if_81
bloco_then_80:
INT CLI_INT
INT HALT_INT
while_start_82:
LDA prog_const_1
SUB prog_const_0
JZ while_end_83
JMP while_start_82
while_end_83:
fim_if_81:
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA schedule_next_pid
while_start_84:
LDA schedule_next_pid
STA tmp_left_cond
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ while_start_84_true
JMP while_end_85
while_start_84_true:
LDA prog_const_1
STA schedule_i
while_start_86:
LDA schedule_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_86_true
JZ while_start_86_true
JMP while_end_87
while_start_86_true:
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
JZ bloco_then_88
JN fim_if_89
bloco_then_88:
LDA schedule_temp_pid
STA tmp_left
LDA MAX_PROCESSES
STA tmp_right
LDA tmp_left
SUB tmp_right
STA schedule_temp_pid
fim_if_89:
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
JZ bloco_then_90
JMP bloco_else_91
bloco_then_90:
LDA schedule_temp_pid
STA schedule_next_pid
LDA MAX_PROCESSES
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA schedule_i
JMP fim_if_92
bloco_else_91:
LDA schedule_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA schedule_i
fim_if_92:
JMP while_start_86
while_end_87:
LDA schedule_next_pid
STA tmp_left_cond
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_93
JMP fim_if_94
bloco_then_93:
LDA system_ticks
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA system_ticks
LDA prog_const_0
STA schedule_i
while_start_95:
LDA schedule_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_95_true
JMP while_end_96
while_start_95_true:
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
JZ bloco_then_97
JMP fim_if_98
bloco_then_97:
LDA system_ticks
STA tmp_left_cond
LDA schedule_p
ADD prog_const_11
STA tmp_ptr
LDI tmp_ptr
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_99
JN fim_if_100
bloco_then_99:
LDA schedule_p
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_100:
fim_if_98:
LDA schedule_p
ADD prog_const_12
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ fim_if_102
JN fim_if_102
bloco_then_101:
LDA system_ticks
STA tmp_left_cond
LDA schedule_p
ADD prog_const_12
STA tmp_ptr
LDI tmp_ptr
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_103
JN fim_if_104
bloco_then_103:
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
JZ bloco_then_105
JMP fim_if_106
bloco_then_105:
LDA schedule_p
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_106:
fim_if_104:
fim_if_102:
LDA schedule_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA schedule_i
JMP while_start_95
while_end_96:
fim_if_94:
JMP while_start_84
while_end_85:
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
JZ bloco_then_107
JMP fim_if_108
bloco_then_107:
INT CLI_INT
INT HALT_INT
fim_if_108:
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
while_start_109:
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
JN while_start_109_true
JMP while_end_110
while_start_109_true:
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
JZ bloco_then_111
JMP fim_if_112
bloco_then_111:
LDA malloc_block_size
STA tmp_left_cond
LDA tmp_left_cond
SUB malloc_needed_size
JZ bloco_then_113
JN fim_if_114
bloco_then_113:
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
JZ fim_if_116
JN fim_if_116
bloco_then_115:
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
fim_if_116:
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
fim_if_114:
fim_if_112:
LDA malloc_ptr
STA tmp_left
LDA malloc_block_size
STA tmp_right
LDA tmp_left
ADD tmp_right
STA malloc_ptr
JMP while_start_109
while_end_110:
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
while_start_117:
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
JN while_start_117_true
JMP while_end_118
while_start_117_true:
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
JZ bloco_then_119
JMP bloco_else_120
bloco_then_119:
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
JN bloco_then_122
JMP fim_if_123
bloco_then_122:
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
JZ bloco_then_124
JMP fim_if_125
bloco_then_124:
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
fim_if_125:
fim_if_123:
LDA kernel_defrag_merged
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_126
JMP fim_if_127
bloco_then_126:
LDA kernel_defrag_next_ptr
STA kernel_defrag_ptr
fim_if_127:
JMP fim_if_121
bloco_else_120:
LDA kernel_defrag_ptr
STA tmp_left
LDA kernel_defrag_block_size
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_defrag_ptr
fim_if_121:
JMP while_start_117
while_end_118:
fim_func_kernel_defrag:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
init_ipc_shm:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_0
STA init_ipc_shm_i
while_start_128:
LDA init_ipc_shm_i
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_5
JN while_start_128_true
JMP while_end_129
while_start_128_true:
MOV shm_keys
STA tmp_arr_base
LDA init_ipc_shm_i
ADD tmp_arr_base
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
MOV shm_addrs
STA tmp_arr_base
LDA init_ipc_shm_i
ADD tmp_arr_base
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA init_ipc_shm_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA init_ipc_shm_i
JMP while_start_128
while_end_129:
fim_func_init_ipc_shm:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_shmget:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_shmget_size
SOP POP_OP
STA kernel_shmget_key
LDA tmp_left
SOP PUSH_OP
LDA prog_const_0
STA kernel_shmget_i
while_start_130:
LDA kernel_shmget_i
STA tmp_left_cond
LDA tmp_left_cond
SUB shm_count
JN while_start_130_true
JMP while_end_131
while_start_130_true:
MOV shm_keys
STA tmp_arr_base
LDA kernel_shmget_i
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB kernel_shmget_key
JZ bloco_then_132
JMP fim_if_133
bloco_then_132:
MOV shm_addrs
STA tmp_arr_base
LDA kernel_shmget_i
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_133:
LDA kernel_shmget_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_shmget_i
JMP while_start_130
while_end_131:
LDA shm_count
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_5
JN bloco_then_134
JMP fim_if_135
bloco_then_134:
LDA kernel_shmget_size
SOP PUSH_OP
CALL malloc
SOP POP_OP
STA kernel_shmget_ptr
LDA kernel_shmget_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ fim_if_137
bloco_then_136:
MOV shm_keys
STA tmp_arr_base
LDA shm_count
ADD tmp_arr_base
STA tmp_lhs
LDA kernel_shmget_key
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
MOV shm_addrs
STA tmp_arr_base
LDA shm_count
ADD tmp_arr_base
STA tmp_lhs
LDA kernel_shmget_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA shm_count
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA shm_count
LDA kernel_shmget_ptr
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_137:
fim_if_135:
LDA prog_const_0
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_kernel_shmget:
RET
kernel_write_pipe:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_write_pipe_val
LDA tmp_left
SOP PUSH_OP
LDA pipe_count
STA tmp_left_cond
LDA tmp_left_cond
SUB PIPE_SIZE
JZ bloco_then_138
JMP fim_if_139
bloco_then_138:
LDA curr_pcb
STA tmp_lhs
LDA STATE_WAITING_PIPE_WRITE
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA prog_const_0
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_139:
MOV pipe_buffer
STA tmp_arr_base
LDA pipe_head
ADD tmp_arr_base
STA tmp_lhs
LDA kernel_write_pipe_val
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA pipe_head
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA pipe_head
LDA pipe_head
STA tmp_left_cond
LDA tmp_left_cond
SUB PIPE_SIZE
JZ bloco_then_140
JMP fim_if_141
bloco_then_140:
LDA prog_const_0
STA pipe_head
fim_if_141:
LDA pipe_count
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA pipe_count
LDA prog_const_0
STA kernel_write_pipe_i
while_start_142:
LDA kernel_write_pipe_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_142_true
JMP while_end_143
while_start_142_true:
MOV pcb
STA tmp_arr_base
LDA kernel_write_pipe_i
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
STA kernel_write_pipe_p
LDA kernel_write_pipe_p
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_WAITING_PIPE_READ
JZ bloco_then_144
JMP fim_if_145
bloco_then_144:
LDA kernel_write_pipe_p
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_145:
LDA kernel_write_pipe_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_write_pipe_i
JMP while_start_142
while_end_143:
LDA prog_const_1
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_kernel_write_pipe:
RET
kernel_read_pipe:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA pipe_count
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_146
JMP fim_if_147
bloco_then_146:
LDA curr_pcb
STA tmp_lhs
LDA STATE_WAITING_PIPE_READ
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
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
fim_if_147:
MOV pipe_buffer
STA tmp_arr_base
LDA pipe_tail
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_read_pipe_val
LDA pipe_tail
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA pipe_tail
LDA pipe_tail
STA tmp_left_cond
LDA tmp_left_cond
SUB PIPE_SIZE
JZ bloco_then_148
JMP fim_if_149
bloco_then_148:
LDA prog_const_0
STA pipe_tail
fim_if_149:
LDA pipe_count
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA pipe_count
LDA prog_const_0
STA kernel_read_pipe_i
while_start_150:
LDA kernel_read_pipe_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_150_true
JMP while_end_151
while_start_150_true:
MOV pcb
STA tmp_arr_base
LDA kernel_read_pipe_i
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
STA kernel_read_pipe_p
LDA kernel_read_pipe_p
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_WAITING_PIPE_WRITE
JZ bloco_then_152
JMP fim_if_153
bloco_then_152:
LDA kernel_read_pipe_p
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_153:
LDA kernel_read_pipe_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_read_pipe_i
JMP while_start_150
while_end_151:
LDA kernel_read_pipe_val
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_kernel_read_pipe:
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
while_start_154:
LDA wakeup_waiters_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_154_true
JMP while_end_155
while_start_154_true:
LDA wakeup_waiters_p
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_WAITING
JZ bloco_then_156
JMP fim_if_157
bloco_then_156:
LDA wakeup_waiters_p
ADD prog_const_10
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB wakeup_waiters_dead_pid
JZ bloco_then_158
JMP fim_if_159
bloco_then_158:
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
fim_if_159:
fim_if_157:
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
JMP while_start_154
while_end_155:
fim_func_wakeup_waiters:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
wakeup_all:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_0
STA wakeup_all_i
while_start_160:
LDA wakeup_all_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_160_true
JMP while_end_161
while_start_160_true:
MOV pcb
STA tmp_arr_base
LDA wakeup_all_i
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
SUB STATE_BLOCKED
JZ bloco_then_162
JMP fim_if_163
bloco_then_162:
MOV pcb
STA tmp_arr_base
LDA wakeup_all_i
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
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_163:
LDA wakeup_all_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA wakeup_all_i
JMP while_start_160
while_end_161:
fim_func_wakeup_all:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_sem_lock:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA SEM_STATE
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_164
JMP bloco_else_165
bloco_then_164:
LDA prog_const_1
STA SEM_STATE
JMP fim_if_166
bloco_else_165:
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
STA tmp_lhs
LDA STATE_BLOCKED
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_166:
fim_func_kernel_sem_lock:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_sem_unlock:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_0
STA kernel_sem_unlock_acordou_alguem
LDA prog_const_0
STA kernel_sem_unlock_i
while_start_167:
LDA kernel_sem_unlock_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_167_true
JMP while_end_168
while_start_167_true:
MOV pcb
STA tmp_arr_base
LDA kernel_sem_unlock_i
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
SUB STATE_BLOCKED
JZ bloco_then_169
JMP bloco_else_170
bloco_then_169:
MOV pcb
STA tmp_arr_base
LDA kernel_sem_unlock_i
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
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA prog_const_1
STA kernel_sem_unlock_acordou_alguem
LDA MAX_PROCESSES
STA kernel_sem_unlock_i
JMP fim_if_171
bloco_else_170:
LDA kernel_sem_unlock_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_sem_unlock_i
fim_if_171:
JMP while_start_167
while_end_168:
LDA kernel_sem_unlock_acordou_alguem
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_172
JMP fim_if_173
bloco_then_172:
LDA prog_const_0
STA SEM_STATE
fim_if_173:
fim_func_kernel_sem_unlock:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_mutex_trylock:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA MUTEX_STATE
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_174
JMP fim_if_175
bloco_then_174:
LDA prog_const_1
STA MUTEX_STATE
LDA prog_const_1
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_175:
LDA prog_const_0
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_kernel_mutex_trylock:
RET
kernel_mutex_unlock:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_0
STA MUTEX_STATE
fim_func_kernel_mutex_unlock:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_exit:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA curr_pcb
STA tmp_lhs
LDA STATE_TERMINATED
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA curr_pcb
ADD prog_const_9
STA tmp_ptr
LDI tmp_ptr
SOP PUSH_OP
CALL free
SOP POP_OP
LDA current_pid
SOP PUSH_OP
CALL wakeup_waiters
SOP POP_OP
fim_func_kernel_exit:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_wait:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_wait_target_pid
LDA tmp_left
SOP PUSH_OP
MOV pcb
STA tmp_arr_base
LDA kernel_wait_target_pid
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
JZ fim_if_177
bloco_then_176:
LDA curr_pcb
STA tmp_lhs
LDA STATE_WAITING
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA curr_pcb
ADD prog_const_10
STA tmp_lhs
LDA kernel_wait_target_pid
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_177:
fim_func_kernel_wait:
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
JZ fim_if_179
bloco_then_178:
LDA kernel_kill_signal
STA tmp_left_cond
LDA tmp_left_cond
SUB SIGKILL
JZ bloco_then_180
JMP bloco_else_181
bloco_then_180:
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
JMP fim_if_182
bloco_else_181:
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
JZ bloco_then_183
JMP fim_if_184
bloco_then_183:
LDA kernel_kill_target
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_184:
fim_if_182:
fim_if_179:
fim_func_kernel_kill:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_sleep:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_sleep_ticks_to_sleep
LDA tmp_left
SOP PUSH_OP
LDA curr_pcb
ADD prog_const_11
STA tmp_lhs
LDA system_ticks
STA tmp_left
LDA kernel_sleep_ticks_to_sleep
STA tmp_right
LDA tmp_left
ADD tmp_right
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA curr_pcb
STA tmp_lhs
LDA STATE_SLEEPING
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_func_kernel_sleep:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_alarm:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_alarm_ticks
LDA tmp_left
SOP PUSH_OP
LDA kernel_alarm_ticks
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_185
JMP bloco_else_186
bloco_then_185:
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
ADD prog_const_12
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
JMP fim_if_187
bloco_else_186:
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
ADD prog_const_12
STA tmp_lhs
LDA system_ticks
STA tmp_left
LDA kernel_alarm_ticks
STA tmp_right
LDA tmp_left
ADD tmp_right
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_187:
fim_func_kernel_alarm:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_pause:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA curr_pcb
STA tmp_lhs
LDA STATE_PAUSED
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_func_kernel_pause:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
create_process:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA create_process_mem_base
SOP POP_OP
STA create_process_priority
SOP POP_OP
STA create_process_stack_base
SOP POP_OP
STA create_process_task_addr
SOP POP_OP
STA create_process_pid
LDA tmp_left
SOP PUSH_OP
MOV pcb
STA tmp_arr_base
LDA create_process_pid
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
STA create_process_p
LDA create_process_p
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_2
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_3
STA tmp_lhs
LDA create_process_task_addr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_4
STA tmp_lhs
LDA KERNEL_CS
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_5
STA tmp_lhs
LDA KERNEL_DS
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_6
STA tmp_lhs
LDA KERNEL_SS
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_7
STA tmp_lhs
LDA create_process_priority
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_8
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_9
STA tmp_lhs
LDA create_process_mem_base
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
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
LDA create_process_p
ADD prog_const_11
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_12
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_13
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_14
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_15
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_16
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_17
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_18
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_19
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_20
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_21
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_22
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_23
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_24
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_25
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_27
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_28
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
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
LDA create_process_stack_base
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
ADD tmp_arr_base
STA create_process_sp_ptr
LDA create_process_sp_ptr
STA tmp_lhs
LDA create_process_task_addr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_sp_ptr
LDA create_process_sp_ptr
STA tmp_lhs
LDA prog_const_8
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_sp_ptr
LDA create_process_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_sp_ptr
LDA create_process_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_sp_ptr
LDA create_process_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_sp_ptr
LDA create_process_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_sp_ptr
LDA create_process_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_sp_ptr
LDA create_process_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_sp_ptr
LDA create_process_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_sp_ptr
LDA create_process_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_sp_ptr
LDA create_process_sp_ptr
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_p
ADD prog_const_1
STA tmp_lhs
LDA create_process_stack_base
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
fim_func_create_process:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_spawn:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_spawn_priority
SOP POP_OP
STA kernel_spawn_task_addr
LDA tmp_left
SOP PUSH_OP
LDA prog_const_0
STA kernel_spawn_i
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA kernel_spawn_free_pid
while_start_188:
LDA kernel_spawn_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN and_next_190
JMP while_end_189
and_next_190:
LDA kernel_spawn_free_pid
STA tmp_left_cond
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ while_start_188_true
JMP while_end_189
while_start_188_true:
MOV pcb
STA tmp_arr_base
LDA kernel_spawn_i
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
JZ bloco_then_191
JMP fim_if_192
bloco_then_191:
LDA kernel_spawn_i
STA kernel_spawn_free_pid
fim_if_192:
LDA kernel_spawn_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_spawn_i
JMP while_start_188
while_end_189:
LDA kernel_spawn_free_pid
STA tmp_left_cond
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_193
JMP fim_if_194
bloco_then_193:
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
fim_if_194:
LDA prog_const_40
SOP PUSH_OP
CALL malloc
SOP POP_OP
STA kernel_spawn_mem
LDA kernel_spawn_mem
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_195
JMP fim_if_196
bloco_then_195:
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
fim_if_196:
LDA kernel_spawn_free_pid
SOP PUSH_OP
LDA kernel_spawn_task_addr
SOP PUSH_OP
LDA kernel_spawn_mem
STA tmp_left
LDA prog_const_40
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
LDA kernel_spawn_priority
SOP PUSH_OP
LDA kernel_spawn_mem
SOP PUSH_OP
CALL create_process
SOP POP_OP
LDA kernel_spawn_free_pid
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_kernel_spawn:
RET
kernel_signal:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_signal_handler_addr
LDA tmp_left
SOP PUSH_OP
LDA curr_pcb
ADD prog_const_14
STA tmp_lhs
LDA kernel_signal_handler_addr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_func_kernel_signal:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_sigreturn:
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
STA kernel_sigreturn_curr
LDA kernel_sigreturn_curr
ADD prog_const_16
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_sigreturn_curr
ADD prog_const_13
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_sigreturn_curr
ADD prog_const_17
STA tmp_ptr
LDI tmp_ptr
STA kernel_sigreturn_orig_sp
LDA kernel_sigreturn_curr
ADD prog_const_2
STA tmp_lhs
LDA kernel_sigreturn_curr
ADD prog_const_18
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA ram
STA tmp_arr_base
LDA kernel_sigreturn_orig_sp
ADD tmp_arr_base
STA kernel_sigreturn_sp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_lhs
LDA kernel_sigreturn_curr
ADD prog_const_19
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_sigreturn_sp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_lhs
LDA kernel_sigreturn_curr
ADD prog_const_20
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_sigreturn_sp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_lhs
LDA kernel_sigreturn_curr
ADD prog_const_21
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_sigreturn_sp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_lhs
LDA kernel_sigreturn_curr
ADD prog_const_22
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_sigreturn_sp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_lhs
LDA kernel_sigreturn_curr
ADD prog_const_23
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_sigreturn_sp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_lhs
LDA kernel_sigreturn_curr
ADD prog_const_24
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_sigreturn_sp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_lhs
LDA kernel_sigreturn_curr
ADD prog_const_25
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_sigreturn_sp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_lhs
LDA kernel_sigreturn_curr
ADD prog_const_26
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_sigreturn_sp_ptr
LDA kernel_sigreturn_sp_ptr
STA tmp_lhs
LDA kernel_sigreturn_curr
ADD prog_const_15
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_sigreturn_curr
ADD prog_const_1
STA tmp_lhs
LDA kernel_sigreturn_orig_sp
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_func_kernel_sigreturn:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_get_signal:
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
ADD prog_const_13
STA tmp_ptr
LDI tmp_ptr
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_kernel_get_signal:
RET
kernel_print_char:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_print_char_ascii_code
LDA tmp_left
SOP PUSH_OP
MOV 0
ADD kernel_print_char_ascii_code
INT OUT_INT
fim_func_kernel_print_char:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_read_char:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 256
INT IN_INT
STA isr_tmp_ac
LDA isr_tmp_ac
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_kernel_read_char:
RET
init_ipc_mailbox:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV ipc_mailbox
STA tmp_arr_base
LDA tmp_arr_base
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
MOV ipc_mailbox
STA tmp_arr_base
LDA tmp_arr_base
ADD prog_const_1
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_func_init_ipc_mailbox:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_msg_send:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_msg_send_msg
SOP POP_OP
STA kernel_msg_send_target_pid
LDA tmp_left
SOP PUSH_OP
LDA kernel_msg_send_target_pid
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JN bloco_then_197
or_next_199:
LDA kernel_msg_send_target_pid
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JZ bloco_then_197
JN fim_if_198
bloco_then_197:
LDA prog_const_0
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_198:
MOV ipc_mailbox
STA tmp_arr_base
LDA kernel_msg_send_target_pid
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ fim_if_201
bloco_then_200:
LDA prog_const_0
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_201:
MOV ipc_mailbox
STA tmp_arr_base
LDA kernel_msg_send_target_pid
ADD tmp_arr_base
STA tmp_lhs
LDA kernel_msg_send_msg
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA prog_const_1
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_kernel_msg_send:
RET
kernel_msg_recv:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV ipc_mailbox
STA tmp_arr_base
LDA current_pid
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_msg_recv_msg
LDA kernel_msg_recv_msg
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_202
JMP fim_if_203
bloco_then_202:
LDA prog_const_0
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_203:
MOV ipc_mailbox
STA tmp_arr_base
LDA current_pid
ADD tmp_arr_base
STA tmp_lhs
LDA prog_const_0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA kernel_msg_recv_msg
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_kernel_msg_recv:
RET
kernel_thread_create:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_thread_create_priority
SOP POP_OP
STA kernel_thread_create_task_addr
LDA tmp_left
SOP PUSH_OP
LDA prog_const_0
STA kernel_thread_create_i
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA kernel_thread_create_free_pid
while_start_204:
LDA kernel_thread_create_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN and_next_206
JMP while_end_205
and_next_206:
LDA kernel_thread_create_free_pid
STA tmp_left_cond
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ while_start_204_true
JMP while_end_205
while_start_204_true:
MOV pcb
STA tmp_arr_base
LDA kernel_thread_create_i
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
JZ bloco_then_207
JMP fim_if_208
bloco_then_207:
LDA kernel_thread_create_i
STA kernel_thread_create_free_pid
fim_if_208:
LDA kernel_thread_create_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_thread_create_i
JMP while_start_204
while_end_205:
LDA kernel_thread_create_free_pid
STA tmp_left_cond
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_209
JMP fim_if_210
bloco_then_209:
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
fim_if_210:
LDA curr_pcb
ADD prog_const_9
STA tmp_ptr
LDI tmp_ptr
STA kernel_thread_create_shared_mem
LDA kernel_thread_create_free_pid
STA tmp_left
LDA prog_const_20
STA tmp_right
LDA tmp_left
LDA kernel_thread_create_free_pid
STA tmp_a_mul
LDA prog_const_0
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
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_res_mul
ADD tmp_a_mul
STA tmp_res_mul
LDA tmp_res_mul
STA kernel_thread_create_stack_offset
LDA prog_const_60
STA tmp_left
LDA kernel_thread_create_stack_offset
STA tmp_right
LDA tmp_left
SUB tmp_right
STA kernel_thread_create_stack_offset
LDA kernel_thread_create_free_pid
SOP PUSH_OP
LDA kernel_thread_create_task_addr
SOP PUSH_OP
LDA kernel_thread_create_shared_mem
STA tmp_left
LDA kernel_thread_create_stack_offset
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
LDA kernel_thread_create_priority
SOP PUSH_OP
LDA kernel_thread_create_shared_mem
SOP PUSH_OP
CALL create_process
SOP POP_OP
LDA kernel_thread_create_free_pid
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_kernel_thread_create:
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
JZ fim_if_212
bloco_then_211:
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
fim_if_212:
LDA ram
STA tmp_arr_base
LDA kernel_spawn_overlay_overlay_img
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_spawn_overlay_version
LDA kernel_spawn_overlay_version
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_2
JZ bloco_then_213
JMP bloco_else_214
bloco_then_213:
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
LDA prog_const_4
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
LDA prog_const_5
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_spawn_overlay_data_size
LDA prog_const_0
STA kernel_spawn_overlay_bss_size
LDA prog_const_40
STA kernel_spawn_overlay_stack_size
LDA prog_const_6
STA kernel_spawn_overlay_header_size
JMP fim_if_215
bloco_else_214:
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
JZ bloco_then_216
JMP fim_if_217
bloco_then_216:
LDA prog_const_40
STA kernel_spawn_overlay_stack_size
fim_if_217:
LDA OVERLAY_HEADER_SIZE
STA kernel_spawn_overlay_header_size
fim_if_215:
LDA prog_const_0
STA kernel_spawn_overlay_i
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA kernel_spawn_overlay_free_pid
while_start_218:
LDA kernel_spawn_overlay_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN and_next_220
JMP while_end_219
and_next_220:
LDA kernel_spawn_overlay_free_pid
STA tmp_left_cond
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ while_start_218_true
JMP while_end_219
while_start_218_true:
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
JZ bloco_then_221
JMP fim_if_222
bloco_then_221:
LDA kernel_spawn_overlay_i
STA kernel_spawn_overlay_free_pid
fim_if_222:
LDA kernel_spawn_overlay_i
STA tmp_left
LDA prog_const_1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_spawn_overlay_i
JMP while_start_218
while_end_219:
LDA kernel_spawn_overlay_free_pid
STA tmp_left_cond
LDA prog_const_1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_223
JMP fim_if_224
bloco_then_223:
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
fim_if_224:
LDA kernel_spawn_overlay_overlay_img
STA tmp_left
LDA kernel_spawn_overlay_header_size
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
JZ bloco_then_225
JMP fim_if_226
bloco_then_225:
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
fim_if_226:
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
MOV overlay_0_app_counter_image
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

; ============================================================
; OVERLAYS INJETADOS PELA IDE
; Formato compacto v2: [0xCAFE, 2, entry_pc, ds_delta, code_size, data_size, code..., data...]
; ============================================================
overlay_count: DD 1
overlay_table: INITD overlay_0_app_counter_image

; --- /mnt/data/SO_reorganizado/apps/app_counter.c ---
overlay_0_app_counter_image: INITD 0xcafe, 0x0002, 0x0000, 0x1000, 0x00fc, 0x002c, 0x0006, 0x1010, 0x0007, 0x5006, 0xa01d, 0x7000
INITD 0x600c, 0x304c, 0x600d, 0x0010, 0x600c, 0x307a, 0x600d, 0x0008, 0x600c, 0x3028, 0x600d, 0x0010
INITD 0x1026, 0x0007, 0x102a, 0x0026, 0x402a, 0x1010, 0x0009, 0x600c, 0x303a, 0x600d, 0x8002, 0x7000
INITD 0x600c, 0x7001, 0x600c, 0x2005, 0x7000, 0x600c, 0x7009, 0x600c, 0x2005, 0x8022, 0x600d, 0x1026
INITD 0x600d, 0x1011, 0x0026, 0x600c, 0x0011, 0x600c, 0x700a, 0x600c, 0x2005, 0x600d, 0x1026, 0x0006
INITD 0x600c, 0x0026, 0x600c, 0xf000, 0x600d, 0x1026, 0x600d, 0x1012, 0x0026, 0x600c, 0x0012, 0x600c
INITD 0x700c, 0x600c, 0x2005, 0x600d, 0x1026, 0x0006, 0x600c, 0x0026, 0x600c, 0xf000, 0x600d, 0x1026
INITD 0x600d, 0x1013, 0x0026, 0x600c, 0x0006, 0x1014, 0x0013, 0x1025, 0x0014, 0x4025, 0x1029, 0xb029
INITD 0x1015, 0x0015, 0x1027, 0x0027, 0x5006, 0xa073, 0x0015, 0x600c, 0x3028, 0x600d, 0x0014, 0x1026
INITD 0x0007, 0x102a, 0x0026, 0x402a, 0x1014, 0x0013, 0x1025, 0x0014, 0x4025, 0x1029, 0xb029, 0x1015
INITD 0x805b, 0x600d, 0x1026, 0x0006, 0x600c, 0x0026, 0x600c, 0xf000, 0x600d, 0x1026, 0x600d, 0x1016
INITD 0x0026, 0x600c, 0x0016, 0x1027, 0x0027, 0x5006, 0xa086, 0x808b, 0x000a, 0x600c, 0x3028, 0x600d
INITD 0x80f5, 0x0016, 0x1027, 0x0027, 0x5006, 0x9091, 0x809c, 0x000b, 0x600c, 0x3028, 0x600d, 0x0006
INITD 0x1026, 0x0016, 0x102a, 0x0026, 0x502a, 0x1016, 0x0006, 0x1023, 0x0016, 0x1027, 0x0027, 0x5006
INITD 0xa0d7, 0x90d7, 0x0006, 0x1017, 0x0016, 0x1018, 0x0018, 0x1027, 0x0027, 0x5008, 0xa0ae, 0x90bd
INITD 0x0018, 0x1026, 0x0008, 0x102a, 0x0026, 0x502a, 0x1018, 0x0017, 0x1026, 0x0007, 0x102a, 0x0026
INITD 0x402a, 0x1017, 0x80a8, 0x7019, 0x1025, 0x0023, 0x4025, 0x1028, 0x0018, 0x1026, 0x000a, 0x102a
INITD 0x0026, 0x402a, 0x102b, 0x0028, 0x1029, 0x002b, 0xc029, 0x0023, 0x1026, 0x0007, 0x102a, 0x0026
INITD 0x402a, 0x1023, 0x0017, 0x1016, 0x809e, 0x0023, 0x1026, 0x0007, 0x102a, 0x0026, 0x502a, 0x1024
INITD 0x0024, 0x1027, 0x0027, 0x5006, 0xa0e4, 0x90f5, 0x7019, 0x1025, 0x0024, 0x4025, 0x1029, 0xb029
INITD 0x600c, 0x3028, 0x600d, 0x0024, 0x1026, 0x0007, 0x102a, 0x0026, 0x502a, 0x1024, 0x80de, 0x600d
INITD 0x1026, 0x0006, 0x600c, 0x0026, 0x600c, 0xf000, 0x0041, 0x0050, 0x0050, 0x0020, 0x0000, 0x001a
INITD 0x0000, 0x0001, 0x000a, 0x0005, 0x0030, 0x002d, 0x0000, 0x0001, 0x0019, 0x0000, 0x0000, 0x0000
INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
INITD 0x0000, 0x0000

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
prog_const_4: DD 4
prog_const_5: DD 5
prog_const_7: DD 7
prog_const_8: DD 8
prog_const_9: DD 9
prog_const_10: DD 10
prog_const_15: DD 15
prog_const_16: DD 16
prog_const_17: DD 17
prog_const_20: DD 20
prog_const_21: DD 21
prog_const_28: DD 28
prog_const_18: DD 18
prog_const_24: DD 24
prog_const_23: DD 23
prog_const_22: DD 22
prog_const_19: DD 19
prog_const_26: DD 26
prog_const_40: DD 40
prog_const_60: DD 60
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
init_ipc_shm_i: RESD 1
kernel_shmget_size: RESD 1
kernel_shmget_key: RESD 1
kernel_shmget_i: RESD 1
kernel_shmget_ptr: RESD 1
kernel_write_pipe_val: RESD 1
kernel_write_pipe_i: RESD 1
kernel_write_pipe_p: RESD 1
kernel_read_pipe_i: RESD 1
kernel_read_pipe_val: RESD 1
kernel_read_pipe_p: RESD 1
wakeup_waiters_dead_pid: RESD 1
wakeup_waiters_i: RESD 1
wakeup_waiters_p: RESD 1
wakeup_all_i: RESD 1
kernel_sem_unlock_i: RESD 1
kernel_sem_unlock_acordou_alguem: RESD 1
kernel_wait_target_pid: RESD 1
kernel_kill_signal: RESD 1
kernel_kill_target_pid: RESD 1
kernel_kill_target: RESD 1
kernel_sleep_ticks_to_sleep: RESD 1
kernel_alarm_ticks: RESD 1
create_process_mem_base: RESD 1
create_process_priority: RESD 1
create_process_stack_base: RESD 1
create_process_task_addr: RESD 1
create_process_pid: RESD 1
create_process_p: RESD 1
create_process_sp_ptr: RESD 1
kernel_spawn_priority: RESD 1
kernel_spawn_task_addr: RESD 1
kernel_spawn_i: RESD 1
kernel_spawn_free_pid: RESD 1
kernel_spawn_mem: RESD 1
kernel_signal_handler_addr: RESD 1
kernel_sigreturn_curr: RESD 1
kernel_sigreturn_orig_sp: RESD 1
kernel_sigreturn_sp_ptr: RESD 1
kernel_print_char_ascii_code: RESD 1
kernel_read_char_val: RESD 1
kernel_msg_send_msg: RESD 1
kernel_msg_send_target_pid: RESD 1
kernel_msg_recv_msg: RESD 1
kernel_thread_create_priority: RESD 1
kernel_thread_create_task_addr: RESD 1
kernel_thread_create_i: RESD 1
kernel_thread_create_free_pid: RESD 1
kernel_thread_create_shared_mem: RESD 1
kernel_thread_create_stack_offset: RESD 1
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
kernel_spawn_overlay_version: RESD 1
kernel_spawn_overlay_entry_pc: RESD 1
kernel_spawn_overlay_text_size: RESD 1
kernel_spawn_overlay_data_size: RESD 1
kernel_spawn_overlay_bss_size: RESD 1
kernel_spawn_overlay_stack_size: RESD 1
kernel_spawn_overlay_header_size: RESD 1
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
