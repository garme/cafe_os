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
CALL kernel_tick_update
SOP POP_OP
CALL kernel_dispatch_syscall
SOP POP_OP
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
SOP PUSH_OP
LDA main_target_sp
SOP PUSH_OP
CALL kernel_signal_inject
SOP POP_OP
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
MOV 0
STA main_i
for_start_7:
LDA main_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN for_start_7_true
JMP for_end_9
for_start_7_true:
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
for_inc_8:
MOV main_i
STA tmp_ptr
LDI tmp_ptr
STA tmp_old_val
ADD prog_const_1
STI tmp_ptr
LDA tmp_old_val
JMP for_start_7
for_end_9:
MOV 0
STA ram
MOV os_heap
STA HEAP_START
CALL init_heap
SOP POP_OP
CALL init_kernel_services
SOP POP_OP
CALL boot_overlays
SOP POP_OP
MOV 0
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
JZ bloco_then_10
JMP fim_if_11
bloco_then_10:
LDA schedule_curr
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_11:
MOV 0
STA schedule_any_alive
MOV 0
STA schedule_i
while_start_12:
LDA schedule_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_12_true
JMP while_end_13
while_start_12_true:
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
JZ fim_if_15
bloco_then_14:
MOV 1
STA schedule_any_alive
fim_if_15:
LDA schedule_i
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA schedule_i
JMP while_start_12
while_end_13:
LDA schedule_any_alive
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_16
JMP fim_if_17
bloco_then_16:
INT CLI_INT
INT HALT_INT
while_start_18:
MOV 1
SUB prog_const_0
JZ while_end_19
JMP while_start_18
while_end_19:
fim_if_17:
MOV 1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA schedule_next_pid
while_start_20:
LDA schedule_next_pid
STA tmp_left_cond
MOV 1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ while_start_20_true
JMP while_end_21
while_start_20_true:
MOV 1
STA schedule_i
while_start_22:
LDA schedule_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_22_true
JZ while_start_22_true
JMP while_end_23
while_start_22_true:
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
JZ bloco_then_24
JN fim_if_25
bloco_then_24:
LDA schedule_temp_pid
STA tmp_left
LDA MAX_PROCESSES
STA tmp_right
LDA tmp_left
SUB tmp_right
STA schedule_temp_pid
fim_if_25:
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
JZ bloco_then_26
JMP bloco_else_27
bloco_then_26:
LDA schedule_temp_pid
STA schedule_next_pid
LDA MAX_PROCESSES
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA schedule_i
JMP fim_if_28
bloco_else_27:
LDA schedule_i
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA schedule_i
fim_if_28:
JMP while_start_22
while_end_23:
LDA schedule_next_pid
STA tmp_left_cond
MOV 1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_29
JMP fim_if_30
bloco_then_29:
LDA system_ticks
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA system_ticks
MOV 0
STA schedule_i
while_start_31:
LDA schedule_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_31_true
JMP while_end_32
while_start_31_true:
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
JZ bloco_then_33
JMP fim_if_34
bloco_then_33:
LDA system_ticks
STA tmp_left_cond
LDA schedule_p
ADD prog_const_11
STA tmp_ptr
LDI tmp_ptr
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_35
JN fim_if_36
bloco_then_35:
LDA schedule_p
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_36:
fim_if_34:
LDA schedule_p
ADD prog_const_12
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ fim_if_38
JN fim_if_38
bloco_then_37:
LDA system_ticks
STA tmp_left_cond
LDA schedule_p
ADD prog_const_12
STA tmp_ptr
LDI tmp_ptr
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_39
JN fim_if_40
bloco_then_39:
LDA schedule_p
ADD prog_const_13
STA tmp_lhs
MOV 14
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA schedule_p
ADD prog_const_12
STA tmp_lhs
MOV 0
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
JZ bloco_then_41
JMP fim_if_42
bloco_then_41:
LDA schedule_p
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_42:
fim_if_40:
fim_if_38:
LDA schedule_i
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA schedule_i
JMP while_start_31
while_end_32:
fim_if_30:
JMP while_start_20
while_end_21:
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
JZ bloco_then_43
JMP fim_if_44
bloco_then_43:
INT CLI_INT
INT HALT_INT
fim_if_44:
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
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_lhs
MOV 1
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
MOV 2
STA tmp_right
LDA tmp_left
ADD tmp_right
STA malloc_needed_size
while_start_45:
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
JN while_start_45_true
JMP while_end_46
while_start_45_true:
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
MOV 1
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
JZ bloco_then_47
JMP fim_if_48
bloco_then_47:
LDA malloc_block_size
STA tmp_left_cond
LDA tmp_left_cond
SUB malloc_needed_size
JZ bloco_then_49
JN fim_if_50
bloco_then_49:
LDA ram
STA tmp_arr_base
LDA malloc_ptr
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_lhs
MOV 0
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
JZ fim_if_52
JN fim_if_52
bloco_then_51:
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
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_lhs
MOV 1
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_52:
LDA malloc_ptr
STA tmp_left
MOV 2
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
fim_if_50:
fim_if_48:
LDA malloc_ptr
STA tmp_left
LDA malloc_block_size
STA tmp_right
LDA tmp_left
ADD tmp_right
STA malloc_ptr
JMP while_start_45
while_end_46:
MOV 0
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
MOV 2
STA tmp_right
LDA tmp_left
SUB tmp_right
STA free_header_ptr
LDA ram
STA tmp_arr_base
LDA free_header_ptr
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_lhs
MOV 1
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
while_start_53:
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
JN while_start_53_true
JMP while_end_54
while_start_53_true:
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
MOV 1
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
JZ bloco_then_55
JMP bloco_else_56
bloco_then_55:
LDA kernel_defrag_ptr
STA tmp_left
LDA kernel_defrag_block_size
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_defrag_next_ptr
MOV 0
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
JN bloco_then_58
JMP fim_if_59
bloco_then_58:
LDA ram
STA tmp_arr_base
LDA kernel_defrag_next_ptr
STA tmp_left
MOV 1
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
JZ bloco_then_60
JMP fim_if_61
bloco_then_60:
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
MOV 1
STA kernel_defrag_merged
fim_if_61:
fim_if_59:
LDA kernel_defrag_merged
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_62
JMP fim_if_63
bloco_then_62:
LDA kernel_defrag_next_ptr
STA kernel_defrag_ptr
fim_if_63:
JMP fim_if_57
bloco_else_56:
LDA kernel_defrag_ptr
STA tmp_left
LDA kernel_defrag_block_size
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_defrag_ptr
fim_if_57:
JMP while_start_53
while_end_54:
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
MOV 0
STA wakeup_waiters_i
MOV pcb
STA tmp_arr_base
LDA tmp_arr_base
STA wakeup_waiters_p
while_start_64:
LDA wakeup_waiters_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_64_true
JMP while_end_65
while_start_64_true:
LDA wakeup_waiters_p
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB STATE_WAITING
JZ bloco_then_66
JMP fim_if_67
bloco_then_66:
LDA wakeup_waiters_p
ADD prog_const_10
STA tmp_ptr
LDI tmp_ptr
STA tmp_left_cond
LDA tmp_left_cond
SUB wakeup_waiters_dead_pid
JZ bloco_then_68
JMP fim_if_69
bloco_then_68:
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
MOV 1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_69:
fim_if_67:
LDA wakeup_waiters_p
STA tmp_left
MOV 1
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
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA wakeup_waiters_i
JMP while_start_64
while_end_65:
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
MOV 0
STA wakeup_all_i
while_start_70:
LDA wakeup_all_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN while_start_70_true
JMP while_end_71
while_start_70_true:
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
JZ bloco_then_72
JMP fim_if_73
bloco_then_72:
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
fim_if_73:
LDA wakeup_all_i
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA wakeup_all_i
JMP while_start_70
while_end_71:
fim_func_wakeup_all:
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
JZ fim_if_75
bloco_then_74:
LDA kernel_kill_signal
STA tmp_left_cond
LDA tmp_left_cond
SUB SIGKILL
JZ bloco_then_76
JMP bloco_else_77
bloco_then_76:
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
JMP fim_if_78
bloco_else_77:
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
JZ bloco_then_79
JMP fim_if_80
bloco_then_79:
LDA kernel_kill_target
STA tmp_lhs
LDA STATE_READY
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
fim_if_80:
fim_if_78:
fim_if_75:
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
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_2
STA tmp_lhs
MOV 0
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
MOV 0
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
MOV 1
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
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_12
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_13
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_14
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_15
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_16
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_17
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_18
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_19
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_20
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_21
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_22
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_23
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_24
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_25
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_27
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_28
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_p
ADD prog_const_26
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA ram
STA tmp_arr_base
LDA create_process_overlay_stack_base
STA tmp_left
MOV 1
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
MOV 1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
MOV 8
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
MOV 0
STA tmp_val
LDA tmp_lhs
STA tmp_ptr
LDA tmp_val
STI tmp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
SUB tmp_right
STA create_process_overlay_sp_ptr
LDA create_process_overlay_sp_ptr
STA tmp_lhs
MOV 0
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
MOV 11
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
JZ fim_if_82
bloco_then_81:
MOV 1
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
fim_if_82:
LDA ram
STA tmp_arr_base
LDA kernel_spawn_overlay_overlay_img
STA tmp_left
MOV 1
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
JZ bloco_then_83
JMP bloco_else_84
bloco_then_83:
LDA ram
STA tmp_arr_base
LDA kernel_spawn_overlay_overlay_img
STA tmp_left
MOV 2
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
MOV 4
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
MOV 5
STA tmp_right
LDA tmp_left
ADD tmp_right
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA kernel_spawn_overlay_data_size
MOV 0
STA kernel_spawn_overlay_bss_size
MOV 40
STA kernel_spawn_overlay_stack_size
MOV 6
STA kernel_spawn_overlay_header_size
JMP fim_if_85
bloco_else_84:
LDA ram
STA tmp_arr_base
LDA kernel_spawn_overlay_overlay_img
STA tmp_left
MOV 2
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
MOV 3
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
MOV 4
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
MOV 5
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
MOV 6
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
JZ bloco_then_86
JMP fim_if_87
bloco_then_86:
MOV 40
STA kernel_spawn_overlay_stack_size
fim_if_87:
LDA OVERLAY_HEADER_SIZE
STA kernel_spawn_overlay_header_size
fim_if_85:
MOV 0
STA kernel_spawn_overlay_i
MOV 1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA kernel_spawn_overlay_free_pid
while_start_88:
LDA kernel_spawn_overlay_i
STA tmp_left_cond
LDA tmp_left_cond
SUB MAX_PROCESSES
JN and_next_90
JMP while_end_89
and_next_90:
LDA kernel_spawn_overlay_free_pid
STA tmp_left_cond
MOV 1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ while_start_88_true
JMP while_end_89
while_start_88_true:
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
JZ bloco_then_91
JMP fim_if_92
bloco_then_91:
LDA kernel_spawn_overlay_i
STA kernel_spawn_overlay_free_pid
fim_if_92:
LDA kernel_spawn_overlay_i
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA kernel_spawn_overlay_i
JMP while_start_88
while_end_89:
LDA kernel_spawn_overlay_free_pid
STA tmp_left_cond
MOV 1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA tmp_right_cond
LDA tmp_left_cond
SUB tmp_right_cond
JZ bloco_then_93
JMP fim_if_94
bloco_then_93:
MOV 1
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
fim_if_94:
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
JZ bloco_then_95
JMP fim_if_96
bloco_then_95:
MOV 1
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
kernel_net_out:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_net_out_io_word
LDA tmp_left
SOP PUSH_OP
LDA kernel_net_out_io_word
STA tmp_left_cond
LDA tmp_left_cond
SUB NET_IO_WORD_MIN
JN bloco_then_97
or_next_99:
LDA kernel_net_out_io_word
STA tmp_left_cond
LDA tmp_left_cond
SUB NET_IO_WORD_MAX
JZ fim_if_98
JN fim_if_98
bloco_then_97:
MOV 1
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
fim_if_98:
LDA kernel_net_out_io_word
INT OUT_INT
MOV 0
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_kernel_net_out:
RET
kernel_net_in:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_net_in_io_word
LDA tmp_left
SOP PUSH_OP
LDA kernel_net_in_io_word
STA tmp_left_cond
LDA tmp_left_cond
SUB NET_IO_WORD_MIN
JN bloco_then_100
or_next_102:
LDA kernel_net_in_io_word
STA tmp_left_cond
LDA tmp_left_cond
SUB NET_IO_WORD_MAX
JZ fim_if_101
JN fim_if_101
bloco_then_100:
MOV 1
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
fim_if_101:
LDA kernel_net_in_io_word
INT IN_INT
STA kernel_net_result
LDA kernel_net_result
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_kernel_net_in:
RET
kernel_dispatch_syscall:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_103
JMP fim_if_104
bloco_then_103:
CALL kernel_exit
SOP POP_OP
fim_if_104:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_9
JZ bloco_then_105
JMP fim_if_106
bloco_then_105:
fim_if_106:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_10
JZ bloco_then_107
JMP fim_if_108
bloco_then_107:
LDA tmp_sys_arg
SOP PUSH_OP
CALL kernel_print_char
SOP POP_OP
fim_if_108:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_30
JZ bloco_then_109
JMP fim_if_110
bloco_then_109:
LDA tmp_sys_arg
SOP PUSH_OP
CALL kernel_net_out
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
fim_if_110:
LDA tmp_sys_id
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_31
JZ bloco_then_111
JMP fim_if_112
bloco_then_111:
LDA tmp_sys_arg
SOP PUSH_OP
CALL kernel_net_in
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
fim_if_112:
fim_func_kernel_dispatch_syscall:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
init_kernel_services:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
fim_func_init_kernel_services:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_tick_update:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA system_ticks
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA system_ticks
fim_func_kernel_tick_update:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
kernel_signal_inject:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA kernel_signal_inject_target_sp
SOP POP_OP
STA kernel_signal_inject_curr
LDA tmp_left
SOP PUSH_OP
fim_func_kernel_signal_inject:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
boot_overlays:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV overlay_0_app_net_client_image
STA overlay_boot_addr_0
LDA overlay_boot_addr_0
SOP PUSH_OP
MOV 4
SOP PUSH_OP
CALL kernel_spawn_overlay
SOP POP_OP
MOV overlay_1_app_net_server_image
STA overlay_boot_addr_1
LDA overlay_boot_addr_1
SOP PUSH_OP
MOV 4
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
overlay_count: DD 2
overlay_table: INITD overlay_0_app_net_client_image, overlay_1_app_net_server_image

; --- SO/apps/app_net_client.c ---
overlay_0_app_net_client_image: INITD 0xcafe, 0x0002, 0x0000, 0x1000, 0x0474, 0x00f2, 0x7000, 0x60b2, 0x342d, 0x60b3, 0x30dc, 0x60b3
INITD 0x10b6, 0x00b6, 0x10ed, 0x00ed, 0x509f, 0xa00d, 0x9063, 0x00b6, 0x60b2, 0x707f, 0x60b2, 0x7000
INITD 0x60b2, 0x7000, 0x60b2, 0x7001, 0x60b2, 0x7090, 0x60b2, 0x701f, 0x60b2, 0x32b3, 0x60b3, 0x00b6
INITD 0x60b2, 0x712c, 0x60b2, 0x3323, 0x60b3, 0x10b7, 0x00b7, 0x10ed, 0x00ed, 0x50a0, 0xa02a, 0x805e
INITD 0x7017, 0x60b2, 0x342d, 0x60b3, 0x00b6, 0x60b2, 0x702e, 0x60b2, 0x3380, 0x60b3, 0x00b6, 0x60b2
INITD 0x7258, 0x60b2, 0x33ef, 0x60b3, 0x10b8, 0x00b8, 0x10ed, 0x00ed, 0x509f, 0xa055, 0x9055, 0x703d
INITD 0x60b2, 0x342d, 0x60b3, 0x327e, 0x60b3, 0x10ed, 0x00ed, 0x50a0, 0xa04c, 0x8054, 0x3399, 0x60b3
INITD 0x10b9, 0x00b9, 0x60b2, 0x341b, 0x60b3, 0x8045, 0x8059, 0x704d, 0x60b2, 0x342d, 0x60b3, 0x00b6
INITD 0x60b2, 0x3408, 0x60b3, 0x8062, 0x7067, 0x60b2, 0x342d, 0x60b3, 0x8067, 0x7086, 0x60b2, 0x342d
INITD 0x60b3, 0x345b, 0x60b3, 0x7000, 0x60b2, 0x7001, 0x60b2, 0x209e, 0x7000, 0x60b2, 0x7009, 0x60b2
INITD 0x209e, 0x806e, 0x60b3, 0x10ec, 0x60b3, 0x10ba, 0x00ec, 0x60b2, 0x00ba, 0x60b2, 0x701e, 0x60b2
INITD 0x209e, 0x10b5, 0x00b5, 0x10f1, 0x60b3, 0x10ec, 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0xf000
INITD 0x60b3, 0x10ec, 0x60b3, 0x10bb, 0x00ec, 0x60b2, 0x00bb, 0x60b2, 0x701f, 0x60b2, 0x209e, 0x10b5
INITD 0x00b5, 0x10f1, 0x60b3, 0x10ec, 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0xf000, 0x60b3, 0x10ec
INITD 0x00ec, 0x60b2, 0x00a1, 0x60b2, 0x3074, 0x60b3, 0x60b3, 0x10ec, 0x009f, 0x60b2, 0x00ec, 0x60b2
INITD 0xf000, 0x60b3, 0x10ec, 0x00ec, 0x60b2, 0x00a2, 0x60b2, 0x3074, 0x60b3, 0x60b3, 0x10ec, 0x009f
INITD 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x00ec, 0x60b2, 0x00a3, 0x60b2, 0x3074, 0x60b3
INITD 0x60b3, 0x10ec, 0x009f, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x00ec, 0x60b2, 0x00a4
INITD 0x60b2, 0x3074, 0x60b3, 0x60b3, 0x10ec, 0x009f, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec
INITD 0x00ec, 0x60b2, 0x00a5, 0x60b2, 0x3074, 0x60b3, 0x31f1, 0x60b3, 0x10f1, 0x60b3, 0x10ec, 0x00f1
INITD 0x60b2, 0x00ec, 0x60b2, 0xf000, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10bc, 0x00ec, 0x60b2, 0x00a6
INITD 0x10ec, 0x00bc, 0x10f0, 0x00ec, 0x40f0, 0x60b2, 0x3074, 0x60b3, 0x60b3, 0x10ec, 0x009f, 0x60b2
INITD 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10bd, 0x00ec, 0x60b2, 0x00a7, 0x10ec, 0x00bd
INITD 0x10f0, 0x00ec, 0x40f0, 0x60b2, 0x3074, 0x60b3, 0x60b3, 0x10ec, 0x009f, 0x60b2, 0x00ec, 0x60b2
INITD 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10be, 0x00ec, 0x60b2, 0x00a8, 0x10ec, 0x00be, 0x10f0, 0x00ec
INITD 0x40f0, 0x60b2, 0x3074, 0x60b3, 0x60b3, 0x10ec, 0x009f, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x60b3
INITD 0x10ec, 0x60b3, 0x10bf, 0x00ec, 0x60b2, 0x00a9, 0x10ec, 0x00bf, 0x10f0, 0x00ec, 0x40f0, 0x60b2
INITD 0x3074, 0x60b3, 0x60b3, 0x10ec, 0x009f, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x60b3
INITD 0x10c0, 0x00ec, 0x60b2, 0x00aa, 0x10ec, 0x00c0, 0x10f0, 0x00ec, 0x40f0, 0x60b2, 0x3074, 0x60b3
INITD 0x60b3, 0x10ec, 0x009f, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10c1, 0x00ec
INITD 0x60b2, 0x00ab, 0x10ec, 0x00c1, 0x10f0, 0x00ec, 0x40f0, 0x60b2, 0x3074, 0x60b3, 0x60b3, 0x10ec
INITD 0x009f, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10c2, 0x00ec, 0x60b2, 0x00ac
INITD 0x10ec, 0x00c2, 0x10f0, 0x00ec, 0x40f0, 0x60b2, 0x3074, 0x60b3, 0x60b3, 0x10ec, 0x009f, 0x60b2
INITD 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10c3, 0x60b3, 0x10c4, 0x60b3, 0x10c5, 0x60b3
INITD 0x10c6, 0x60b3, 0x10c7, 0x60b3, 0x10c8, 0x60b3, 0x10c9, 0x00ec, 0x60b2, 0x00c9, 0x60b2, 0x30ef
INITD 0x60b3, 0x00c8, 0x60b2, 0x3105, 0x60b3, 0x00c7, 0x60b2, 0x311b, 0x60b3, 0x00c6, 0x60b2, 0x3131
INITD 0x60b3, 0x00c5, 0x60b2, 0x3147, 0x60b3, 0x00c4, 0x60b2, 0x315d, 0x60b3, 0x00c3, 0x60b2, 0x3173
INITD 0x60b3, 0x60b3, 0x10ec, 0x009f, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x00ec, 0x60b2
INITD 0x00ad, 0x60b2, 0x308a, 0x60b3, 0x10f1, 0x60b3, 0x10ec, 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000
INITD 0xf000, 0x60b3, 0x10ec, 0x00ec, 0x60b2, 0x00ae, 0x60b2, 0x308a, 0x60b3, 0x10f1, 0x60b3, 0x10ec
INITD 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0xf000, 0x60b3, 0x10ec, 0x00ec, 0x60b2, 0x00af, 0x60b2
INITD 0x308a, 0x60b3, 0x10f1, 0x60b3, 0x10ec, 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0xf000, 0x60b3
INITD 0x10ec, 0x00ec, 0x60b2, 0x31cf, 0x60b3, 0x10ca, 0x31e0, 0x60b3, 0x10cb, 0x00cb, 0x10ec, 0x7100
INITD 0x10f0, 0x00ec, 0x00cb, 0x10e9, 0x009f, 0x10ef, 0x00e9, 0xe0a0, 0x10e9, 0x00e9, 0xe0a0, 0x10e9
INITD 0x00e9, 0xe0a0, 0x10e9, 0x00e9, 0xe0a0, 0x10e9, 0x00e9, 0xe0a0, 0x10e9, 0x00e9, 0xe0a0, 0x10e9
INITD 0x00e9, 0xe0a0, 0x10e9, 0x00e9, 0xe0a0, 0x10e9, 0x00ef, 0x40e9, 0x10ef, 0x00ef, 0x10cb, 0x00ca
INITD 0x10ec, 0x00cb, 0x10f0, 0x00ec, 0x40f0, 0x10ca, 0x00ca, 0x10f1, 0x60b3, 0x10ec, 0x00f1, 0x60b2
INITD 0x00ec, 0x60b2, 0xf000, 0xf000, 0x60b3, 0x10ec, 0x00ec, 0x60b2, 0x31be, 0x60b3, 0x10cc, 0x00cc
INITD 0x10ec, 0x7004, 0x10f0, 0x00ec, 0xd0f0, 0x10ea, 0xd0ea, 0x10ed, 0x00ed, 0x509f, 0xa24e, 0x7001
INITD 0x10f1, 0x60b3, 0x10ec, 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x7000, 0x10f1, 0x60b3, 0x10ec
INITD 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0xf000, 0x60b3, 0x10ec, 0x00ec, 0x60b2, 0x31be, 0x60b3
INITD 0x10cd, 0x00cd, 0x10ec, 0x7008, 0x10f0, 0x00ec, 0xd0f0, 0x10ea, 0xd0ea, 0x10ed, 0x00ed, 0x509f
INITD 0xa274, 0x7001, 0x10f1, 0x60b3, 0x10ec, 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x7000, 0x10f1
INITD 0x60b3, 0x10ec, 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0xf000, 0x60b3, 0x10ec, 0x00ec, 0x60b2
INITD 0x3258, 0x60b3, 0x10f1, 0x60b3, 0x10ec, 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0xf000, 0x60b3
INITD 0x10ec, 0x00ec, 0x60b2, 0x31be, 0x60b3, 0x10ce, 0x00ce, 0x10ec, 0x7020, 0x10f0, 0x00ec, 0xd0f0
INITD 0x10ea, 0xd0ea, 0x10ed, 0x00ed, 0x509f, 0xa2a9, 0x7001, 0x10f1, 0x60b3, 0x10ec, 0x00f1, 0x60b2
INITD 0x00ec, 0x60b2, 0xf000, 0x7000, 0x10f1, 0x60b3, 0x10ec, 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000
INITD 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10cf, 0x60b3, 0x10d0, 0x60b3, 0x10d1, 0x60b3, 0x10d2, 0x60b3
INITD 0x10d3, 0x60b3, 0x10d4, 0x60b3, 0x10d5, 0x00ec, 0x60b2, 0x00d5, 0x60b2, 0x00d4, 0x60b2, 0x00d3
INITD 0x60b2, 0x00d2, 0x60b2, 0x00d1, 0x60b2, 0x00d0, 0x60b2, 0x00cf, 0x60b2, 0x3189, 0x60b3, 0x30a0
INITD 0x60b3, 0x60b3, 0x10ec, 0x009f, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10d6
INITD 0x00ec, 0x60b2, 0x7000, 0x10d7, 0x00d7, 0x10ed, 0x00ed, 0x50d6, 0x92ec, 0x8319, 0x30be, 0x60b3
INITD 0x3232, 0x60b3, 0x10ed, 0x00ed, 0x50a0, 0xa2f5, 0x82fe, 0x7001, 0x10f1, 0x60b3, 0x10ec, 0x00f1
INITD 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x328d, 0x60b3, 0x10ed, 0x00ed, 0x50a0, 0xa305, 0x8311, 0x7001
INITD 0x10f1, 0x009f, 0x50f1, 0x10f1, 0x60b3, 0x10ec, 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x00d7
INITD 0x10ec, 0x7001, 0x10f0, 0x00ec, 0x40f0, 0x10d7, 0x82e6, 0x7000, 0x10f1, 0x60b3, 0x10ec, 0x00f1
INITD 0x60b2, 0x00ec, 0x60b2, 0xf000, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10d8, 0x60b3, 0x10d9, 0x00ec
INITD 0x60b2, 0x00d9, 0x60b2, 0x30ef, 0x60b3, 0x00d8, 0x60b2, 0x32de, 0x60b3, 0x10f1, 0x60b3, 0x10ec
INITD 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10da, 0x00ec, 0x60b2
INITD 0x00b0, 0x10ec, 0x00da, 0x10f0, 0x00ec, 0x40f0, 0x60b2, 0x3074, 0x60b3, 0x60b3, 0x10ec, 0x009f
INITD 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10db, 0x00ec, 0x60b2, 0x7000, 0x10dc
INITD 0x00db, 0x10eb, 0x00dc, 0x40eb, 0x10ee, 0xb0ee, 0x10dd, 0x00dd, 0x10ed, 0x00ed, 0x509f, 0xa379
INITD 0x00dd, 0x60b2, 0x333c, 0x60b3, 0x00dc, 0x10ec, 0x7001, 0x10f0, 0x00ec, 0x40f0, 0x10dc, 0x00db
INITD 0x10eb, 0x00dc, 0x40eb, 0x10ee, 0xb0ee, 0x10dd, 0x8361, 0x60b3, 0x10ec, 0x009f, 0x60b2, 0x00ec
INITD 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10de, 0x60b3, 0x10df, 0x00ec, 0x60b2, 0x00df, 0x60b2
INITD 0x30ef, 0x60b3, 0x00de, 0x60b2, 0x3352, 0x60b3, 0x30af, 0x60b3, 0x60b3, 0x10ec, 0x009f, 0x60b2
INITD 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x00ec, 0x60b2, 0x00b1, 0x60b2, 0x308a, 0x60b3, 0x10f1
INITD 0x60b3, 0x10ec, 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10e0
INITD 0x00ec, 0x60b2, 0x7000, 0x10e1, 0x00e1, 0x10ed, 0x00ed, 0x50e0, 0x93b8, 0x83e5, 0x30be, 0x60b3
INITD 0x327e, 0x60b3, 0x10ed, 0x00ed, 0x50a0, 0xa3c1, 0x83ca, 0x7001, 0x10f1, 0x60b3, 0x10ec, 0x00f1
INITD 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x328d, 0x60b3, 0x10ed, 0x00ed, 0x50a0, 0xa3d1, 0x83dd, 0x7001
INITD 0x10f1, 0x009f, 0x50f1, 0x10f1, 0x60b3, 0x10ec, 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x00e1
INITD 0x10ec, 0x7001, 0x10f0, 0x00ec, 0x40f0, 0x10e1, 0x83b2, 0x7000, 0x10f1, 0x60b3, 0x10ec, 0x00f1
INITD 0x60b2, 0x00ec, 0x60b2, 0xf000, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10e2, 0x60b3, 0x10e3, 0x00ec
INITD 0x60b2, 0x00e3, 0x60b2, 0x30ef, 0x60b3, 0x00e2, 0x60b2, 0x33aa, 0x60b3, 0x10f1, 0x60b3, 0x10ec
INITD 0x00f1, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10e4, 0x00ec, 0x60b2
INITD 0x00e4, 0x60b2, 0x30ef, 0x60b3, 0x30cd, 0x60b3, 0x60b3, 0x10ec, 0x009f, 0x60b2, 0x00ec, 0x60b2
INITD 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10e5, 0x00ec, 0x60b2, 0x00e5, 0x60b2, 0x700a, 0x60b2, 0x209e
INITD 0x60b3, 0x10ec, 0x009f, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x60b3, 0x10e6, 0x00ec
INITD 0x60b2, 0x7000, 0x10e7, 0x00e6, 0x10eb, 0x00e7, 0x40eb, 0x10ee, 0xb0ee, 0x10e8, 0x00e8, 0x10ed
INITD 0x00ed, 0x509f, 0xa454, 0x00e8, 0x60b2, 0x341b, 0x60b3, 0x00e7, 0x10ec, 0x7001, 0x10f0, 0x00ec
INITD 0x40f0, 0x10e7, 0x00e6, 0x10eb, 0x00e7, 0x40eb, 0x10ee, 0xb0ee, 0x10e8, 0x843c, 0x60b3, 0x10ec
INITD 0x009f, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x60b3, 0x10ec, 0x00ec, 0x60b2, 0x7000, 0x60b2, 0x7001
INITD 0x60b2, 0x209e, 0x7001, 0x509f, 0xa46d, 0x7000, 0x60b2, 0x7009, 0x60b2, 0x209e, 0x8464, 0x60b3
INITD 0x10ec, 0x009f, 0x60b2, 0x00ec, 0x60b2, 0xf000, 0x004e, 0x0045, 0x0054, 0x0020, 0x0043, 0x004c
INITD 0x0049, 0x0045, 0x004e, 0x0054, 0x003a, 0x0020, 0x0069, 0x006e, 0x0069, 0x0063, 0x0069, 0x0061
INITD 0x006e, 0x0064, 0x006f, 0x000a, 0x0000, 0x004e, 0x0045, 0x0054, 0x0020, 0x0043, 0x004c, 0x0049
INITD 0x0045, 0x004e, 0x0054, 0x003a, 0x0020, 0x0063, 0x006f, 0x006e, 0x0065, 0x0063, 0x0074, 0x0061
INITD 0x0064, 0x006f, 0x000a, 0x0000, 0x004f, 0x004c, 0x0041, 0x0020, 0x0044, 0x004f, 0x0020, 0x0047
INITD 0x0055, 0x0049, 0x004c, 0x0049, 0x0058, 0x000a, 0x0000, 0x004e, 0x0045, 0x0054, 0x0020, 0x0043
INITD 0x004c, 0x0049, 0x0045, 0x004e, 0x0054, 0x0020, 0x0052, 0x0058, 0x003a, 0x0020, 0x0000, 0x004e
INITD 0x0045, 0x0054, 0x0020, 0x0043, 0x004c, 0x0049, 0x0045, 0x004e, 0x0054, 0x003a, 0x0020, 0x0073
INITD 0x0065, 0x006d, 0x0020, 0x0072, 0x0065, 0x0073, 0x0070, 0x006f, 0x0073, 0x0074, 0x0061, 0x000a
INITD 0x0000, 0x004e, 0x0045, 0x0054, 0x0020, 0x0043, 0x004c, 0x0049, 0x0045, 0x004e, 0x0054, 0x003a
INITD 0x0020, 0x0066, 0x0061, 0x006c, 0x0068, 0x0061, 0x0020, 0x0061, 0x006f, 0x0020, 0x0063, 0x006f
INITD 0x006e, 0x0065, 0x0063, 0x0074, 0x0061, 0x0072, 0x000a, 0x0000, 0x004e, 0x0045, 0x0054, 0x0020
INITD 0x0043, 0x004c, 0x0049, 0x0045, 0x004e, 0x0054, 0x003a, 0x0020, 0x0073, 0x0065, 0x006d, 0x0020
INITD 0x0073, 0x006f, 0x0063, 0x006b, 0x0065, 0x0074, 0x000a, 0x0000, 0x001a, 0x0000, 0x0001, 0x2803
INITD 0x2804, 0x2805, 0x2806, 0x2802, 0x2a00, 0x2f00, 0x3000, 0x3100, 0x3200, 0x3300, 0x3400, 0x2900
INITD 0x2b00, 0x2c00, 0x3500, 0x3800, 0x0000, 0x0001, 0x0019, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000

; --- SO/apps/app_net_server.c ---
overlay_1_app_net_server_image: INITD 0xcafe, 0x0002, 0x0000, 0x1000, 0x04a8, 0x0114, 0x7000, 0x60d7, 0x3451, 0x60d8, 0x7000, 0x10e0
INITD 0x3156, 0x60d8, 0x10db, 0x00db, 0x110f, 0x010f, 0x50c1, 0x900f, 0x8015, 0x7017, 0x60d7, 0x3451
INITD 0x60d8, 0x7001, 0x10e0, 0x00e0, 0x110f, 0x010f, 0x50c1, 0xa01b, 0x8038, 0x00db, 0x60d7, 0x7000
INITD 0x60d7, 0x7000, 0x60d7, 0x7000, 0x60d7, 0x7000, 0x60d7, 0x7091, 0x60d7, 0x701f, 0x60d7, 0x331d
INITD 0x60d8, 0x10dd, 0x00dd, 0x110f, 0x010f, 0x50c1, 0x9032, 0x8038, 0x702f, 0x60d7, 0x3451, 0x60d8
INITD 0x7001, 0x10e0, 0x00e0, 0x110f, 0x010f, 0x50c1, 0xa03e, 0x804f, 0x00db, 0x60d7, 0x7002, 0x60d7
INITD 0x335f, 0x60d8, 0x110f, 0x010f, 0x50c1, 0x9049, 0x804f, 0x7048, 0x60d7, 0x3451, 0x60d8, 0x7001
INITD 0x10e0, 0x00e0, 0x110f, 0x010f, 0x50c1, 0xa055, 0x8078, 0x7063, 0x60d7, 0x3451, 0x60d8, 0x7001
INITD 0x1113, 0x00c1, 0x5113, 0x10dc, 0x00dc, 0x110f, 0x010f, 0x50c1, 0x9064, 0x8078, 0x00db, 0x60d7
INITD 0x338e, 0x60d8, 0x10dc, 0x32f7, 0x60d8, 0x110f, 0x010f, 0x50c2, 0xa070, 0x8075, 0x7001, 0x10e0
INITD 0x7000, 0x10dc, 0x8077, 0x347f, 0x60d8, 0x805e, 0x00e0, 0x110f, 0x010f, 0x50c1, 0xa07e, 0x80c3
INITD 0x707d, 0x60d7, 0x3451, 0x60d8, 0x7000, 0x10de, 0x00de, 0x110f, 0x010f, 0x50c1, 0xa08a, 0x8094
INITD 0x00dc, 0x60d7, 0x7028, 0x60d7, 0x3413, 0x60d8, 0x10de, 0x347f, 0x60d8, 0x8084, 0x00de, 0x110f
INITD 0x010f, 0x50c1, 0xa0b7, 0x90b7, 0x7099, 0x60d7, 0x3451, 0x60d8, 0x00dc, 0x60d7, 0x3169, 0x60d8
INITD 0x32e8, 0x60d8, 0x110f, 0x010f, 0x50c2, 0xa0a9, 0x80b5, 0x33bd, 0x60d8, 0x10df, 0x00df, 0x60d7
INITD 0x343f, 0x60d8, 0x00df, 0x60d7, 0x33a7, 0x60d8, 0x80a2, 0x30fc, 0x60d8, 0x00dc, 0x60d7, 0x342c
INITD 0x60d8, 0x00db, 0x60d7, 0x342c, 0x60d8, 0x70a9, 0x60d7, 0x3451, 0x60d8, 0x348f, 0x60d8, 0x7000
INITD 0x60d7, 0x7001, 0x60d7, 0x20c0, 0x7000, 0x60d7, 0x7009, 0x60d7, 0x20c0, 0x80ca, 0x60d8, 0x110e
INITD 0x60d8, 0x10e1, 0x010e, 0x60d7, 0x00e1, 0x60d7, 0x701e, 0x60d7, 0x20c0, 0x10da, 0x00da, 0x1113
INITD 0x60d8, 0x110e, 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x10e2
INITD 0x010e, 0x60d7, 0x00e2, 0x60d7, 0x701f, 0x60d7, 0x20c0, 0x10da, 0x00da, 0x1113, 0x60d8, 0x110e
INITD 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8, 0x110e, 0x010e, 0x60d7, 0x00c3, 0x60d7
INITD 0x30d0, 0x60d8, 0x60d8, 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x010e
INITD 0x60d7, 0x00c4, 0x60d7, 0x30d0, 0x60d8, 0x60d8, 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000
INITD 0x60d8, 0x110e, 0x010e, 0x60d7, 0x00c5, 0x60d7, 0x30d0, 0x60d8, 0x60d8, 0x110e, 0x00c1, 0x60d7
INITD 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x010e, 0x60d7, 0x00c6, 0x60d7, 0x30d0, 0x60d8, 0x60d8
INITD 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x010e, 0x60d7, 0x00c7, 0x60d7
INITD 0x30d0, 0x60d8, 0x60d8, 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x010e
INITD 0x60d7, 0x00c8, 0x60d7, 0x30d0, 0x60d8, 0x60d8, 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000
INITD 0x60d8, 0x110e, 0x010e, 0x60d7, 0x00c9, 0x60d7, 0x30d0, 0x60d8, 0x3281, 0x60d8, 0x1113, 0x60d8
INITD 0x110e, 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x10e3, 0x010e
INITD 0x60d7, 0x00ca, 0x110e, 0x00e3, 0x1112, 0x010e, 0x4112, 0x60d7, 0x30d0, 0x60d8, 0x60d8, 0x110e
INITD 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x10e4, 0x010e, 0x60d7, 0x00cb
INITD 0x110e, 0x00e4, 0x1112, 0x010e, 0x4112, 0x60d7, 0x30d0, 0x60d8, 0x60d8, 0x110e, 0x00c1, 0x60d7
INITD 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x10e5, 0x010e, 0x60d7, 0x00cc, 0x110e, 0x00e5
INITD 0x1112, 0x010e, 0x4112, 0x60d7, 0x30d0, 0x60d8, 0x60d8, 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7
INITD 0xf000, 0x60d8, 0x110e, 0x60d8, 0x10e6, 0x010e, 0x60d7, 0x00cd, 0x110e, 0x00e6, 0x1112, 0x010e
INITD 0x4112, 0x60d7, 0x30d0, 0x60d8, 0x60d8, 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x60d8
INITD 0x110e, 0x60d8, 0x10e7, 0x010e, 0x60d7, 0x00ce, 0x110e, 0x00e7, 0x1112, 0x010e, 0x4112, 0x60d7
INITD 0x30d0, 0x60d8, 0x60d8, 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x60d8
INITD 0x10e8, 0x010e, 0x60d7, 0x00cf, 0x110e, 0x00e8, 0x1112, 0x010e, 0x4112, 0x60d7, 0x30d0, 0x60d8
INITD 0x60d8, 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x10e9, 0x010e
INITD 0x60d7, 0x00d0, 0x110e, 0x00e9, 0x1112, 0x010e, 0x4112, 0x60d7, 0x30d0, 0x60d8, 0x60d8, 0x110e
INITD 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x10ea, 0x010e, 0x60d7, 0x00d1
INITD 0x110e, 0x00ea, 0x1112, 0x010e, 0x4112, 0x60d7, 0x30d0, 0x60d8, 0x60d8, 0x110e, 0x00c1, 0x60d7
INITD 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x10eb, 0x60d8, 0x10ec, 0x60d8, 0x10ed, 0x60d8
INITD 0x10ee, 0x60d8, 0x10ef, 0x60d8, 0x10f0, 0x60d8, 0x10f1, 0x010e, 0x60d7, 0x00f1, 0x60d7, 0x3169
INITD 0x60d8, 0x00f0, 0x60d7, 0x317f, 0x60d8, 0x00ef, 0x60d7, 0x3195, 0x60d8, 0x00ee, 0x60d7, 0x31ab
INITD 0x60d8, 0x00ed, 0x60d7, 0x31c1, 0x60d8, 0x00ec, 0x60d7, 0x31d7, 0x60d8, 0x00eb, 0x60d7, 0x31ed
INITD 0x60d8, 0x60d8, 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x010e, 0x60d7
INITD 0x00d2, 0x60d7, 0x30e6, 0x60d8, 0x1113, 0x60d8, 0x110e, 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000
INITD 0xf000, 0x60d8, 0x110e, 0x010e, 0x60d7, 0x00d3, 0x60d7, 0x30e6, 0x60d8, 0x1113, 0x60d8, 0x110e
INITD 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8, 0x110e, 0x010e, 0x60d7, 0x00d4, 0x60d7
INITD 0x30e6, 0x60d8, 0x1113, 0x60d8, 0x110e, 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8
INITD 0x110e, 0x010e, 0x60d7, 0x325f, 0x60d8, 0x10f2, 0x3270, 0x60d8, 0x10f3, 0x00f3, 0x110e, 0x7100
INITD 0x1112, 0x010e, 0x00f3, 0x110b, 0x00c1, 0x1111, 0x010b, 0xe0c2, 0x110b, 0x010b, 0xe0c2, 0x110b
INITD 0x010b, 0xe0c2, 0x110b, 0x010b, 0xe0c2, 0x110b, 0x010b, 0xe0c2, 0x110b, 0x010b, 0xe0c2, 0x110b
INITD 0x010b, 0xe0c2, 0x110b, 0x010b, 0xe0c2, 0x110b, 0x0111, 0x410b, 0x1111, 0x0111, 0x10f3, 0x00f2
INITD 0x110e, 0x00f3, 0x1112, 0x010e, 0x4112, 0x10f2, 0x00f2, 0x1113, 0x60d8, 0x110e, 0x0113, 0x60d7
INITD 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8, 0x110e, 0x010e, 0x60d7, 0x324e, 0x60d8, 0x10f4, 0x00f4
INITD 0x110e, 0x7008, 0x1112, 0x010e, 0xd112, 0x110c, 0xd10c, 0x110f, 0x010f, 0x50c1, 0xa2de, 0x7001
INITD 0x1113, 0x60d8, 0x110e, 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x7000, 0x1113, 0x60d8, 0x110e
INITD 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8, 0x110e, 0x010e, 0x60d7, 0x32c2, 0x60d8
INITD 0x1113, 0x60d8, 0x110e, 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8, 0x110e, 0x010e
INITD 0x60d7, 0x324e, 0x60d8, 0x10f5, 0x00f5, 0x110e, 0x7020, 0x1112, 0x010e, 0xd112, 0x110c, 0xd10c
INITD 0x110f, 0x010f, 0x50c1, 0xa313, 0x7001, 0x1113, 0x60d8, 0x110e, 0x0113, 0x60d7, 0x010e, 0x60d7
INITD 0xf000, 0x7000, 0x1113, 0x60d8, 0x110e, 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8
INITD 0x110e, 0x60d8, 0x10f6, 0x60d8, 0x10f7, 0x60d8, 0x10f8, 0x60d8, 0x10f9, 0x60d8, 0x10fa, 0x60d8
INITD 0x10fb, 0x60d8, 0x10fc, 0x010e, 0x60d7, 0x00fc, 0x60d7, 0x00fb, 0x60d7, 0x00fa, 0x60d7, 0x00f9
INITD 0x60d7, 0x00f8, 0x60d7, 0x00f7, 0x60d7, 0x00f6, 0x60d7, 0x3219, 0x60d8, 0x3129, 0x60d8, 0x32f7
INITD 0x60d8, 0x110f, 0x010f, 0x50c2, 0xa348, 0x8354, 0x7001, 0x1113, 0x00c1, 0x5113, 0x1113, 0x60d8
INITD 0x110e, 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x3281, 0x60d8, 0x1113, 0x60d8, 0x110e, 0x0113
INITD 0x60d7, 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x10fd, 0x60d8, 0x10fe, 0x010e
INITD 0x60d7, 0x00fe, 0x60d7, 0x3169, 0x60d8, 0x00fd, 0x60d7, 0x3203, 0x60d8, 0x3138, 0x60d8, 0x32f7
INITD 0x60d8, 0x110f, 0x010f, 0x50c2, 0xa378, 0x8384, 0x7001, 0x1113, 0x00c1, 0x5113, 0x1113, 0x60d8
INITD 0x110e, 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x7000, 0x1113, 0x60d8, 0x110e, 0x0113, 0x60d7
INITD 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x10ff, 0x010e, 0x60d7, 0x00ff, 0x60d7
INITD 0x3169, 0x60d8, 0x3147, 0x60d8, 0x3281, 0x60d8, 0x1100, 0x0100, 0x1113, 0x60d8, 0x110e, 0x0113
INITD 0x60d7, 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x1101, 0x010e, 0x60d7, 0x00d5
INITD 0x110e, 0x0101, 0x1112, 0x010e, 0x4112, 0x60d7, 0x30d0, 0x60d8, 0x60d8, 0x110e, 0x00c1, 0x60d7
INITD 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x010e, 0x60d7, 0x00d6, 0x60d7, 0x30e6, 0x60d8, 0x1113
INITD 0x60d8, 0x110e, 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x1102
INITD 0x010e, 0x60d7, 0x7000, 0x1103, 0x0103, 0x110f, 0x010f, 0x5102, 0x93dc, 0x8409, 0x310b, 0x60d8
INITD 0x32e8, 0x60d8, 0x110f, 0x010f, 0x50c2, 0xa3e5, 0x83ee, 0x7001, 0x1113, 0x60d8, 0x110e, 0x0113
INITD 0x60d7, 0x010e, 0x60d7, 0xf000, 0x32f7, 0x60d8, 0x110f, 0x010f, 0x50c2, 0xa3f5, 0x8401, 0x7001
INITD 0x1113, 0x00c1, 0x5113, 0x1113, 0x60d8, 0x110e, 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x0103
INITD 0x110e, 0x7001, 0x1112, 0x010e, 0x4112, 0x1103, 0x83d6, 0x7000, 0x1113, 0x60d8, 0x110e, 0x0113
INITD 0x60d7, 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x1104, 0x60d8, 0x1105, 0x010e
INITD 0x60d7, 0x0105, 0x60d7, 0x3169, 0x60d8, 0x0104, 0x60d7, 0x33ce, 0x60d8, 0x1113, 0x60d8, 0x110e
INITD 0x0113, 0x60d7, 0x010e, 0x60d7, 0xf000, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x1106, 0x010e, 0x60d7
INITD 0x0106, 0x60d7, 0x3169, 0x60d8, 0x311a, 0x60d8, 0x60d8, 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7
INITD 0xf000, 0x60d8, 0x110e, 0x60d8, 0x1107, 0x010e, 0x60d7, 0x0107, 0x60d7, 0x700a, 0x60d7, 0x20c0
INITD 0x60d8, 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x60d8, 0x1108, 0x010e
INITD 0x60d7, 0x7000, 0x1109, 0x0108, 0x110d, 0x0109, 0x410d, 0x1110, 0xb110, 0x110a, 0x010a, 0x110f
INITD 0x010f, 0x50c1, 0xa478, 0x010a, 0x60d7, 0x343f, 0x60d8, 0x0109, 0x110e, 0x7001, 0x1112, 0x010e
INITD 0x4112, 0x1109, 0x0108, 0x110d, 0x0109, 0x410d, 0x1110, 0xb110, 0x110a, 0x8460, 0x60d8, 0x110e
INITD 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x010e, 0x60d7, 0x7000, 0x60d7, 0x7009
INITD 0x60d7, 0x20c0, 0x60d8, 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x60d8, 0x110e, 0x010e
INITD 0x60d7, 0x7000, 0x60d7, 0x7001, 0x60d7, 0x20c0, 0x7001, 0x50c1, 0xa4a1, 0x7000, 0x60d7, 0x7009
INITD 0x60d7, 0x20c0, 0x8498, 0x60d8, 0x110e, 0x00c1, 0x60d7, 0x010e, 0x60d7, 0xf000, 0x004e, 0x0045
INITD 0x0054, 0x0020, 0x0053, 0x0045, 0x0052, 0x0056, 0x0045, 0x0052, 0x003a, 0x0020, 0x0069, 0x006e
INITD 0x0069, 0x0063, 0x0069, 0x0061, 0x006e, 0x0064, 0x006f, 0x000a, 0x0000, 0x004e, 0x0045, 0x0054
INITD 0x0020, 0x0053, 0x0045, 0x0052, 0x0056, 0x0045, 0x0052, 0x003a, 0x0020, 0x0073, 0x0065, 0x006d
INITD 0x0020, 0x0073, 0x006f, 0x0063, 0x006b, 0x0065, 0x0074, 0x000a, 0x0000, 0x004e, 0x0045, 0x0054
INITD 0x0020, 0x0053, 0x0045, 0x0052, 0x0056, 0x0045, 0x0052, 0x003a, 0x0020, 0x0062, 0x0069, 0x006e
INITD 0x0064, 0x0020, 0x0066, 0x0061, 0x006c, 0x0068, 0x006f, 0x0075, 0x000a, 0x0000, 0x004e, 0x0045
INITD 0x0054, 0x0020, 0x0053, 0x0045, 0x0052, 0x0056, 0x0045, 0x0052, 0x003a, 0x0020, 0x006c, 0x0069
INITD 0x0073, 0x0074, 0x0065, 0x006e, 0x0020, 0x0066, 0x0061, 0x006c, 0x0068, 0x006f, 0x0075, 0x000a
INITD 0x0000, 0x004e, 0x0045, 0x0054, 0x0020, 0x0053, 0x0045, 0x0052, 0x0056, 0x0045, 0x0052, 0x003a
INITD 0x0020, 0x006f, 0x0075, 0x0076, 0x0069, 0x006e, 0x0064, 0x006f, 0x0020, 0x0038, 0x0030, 0x0038
INITD 0x0031, 0x000a, 0x0000, 0x004e, 0x0045, 0x0054, 0x0020, 0x0053, 0x0045, 0x0052, 0x0056, 0x0045
INITD 0x0052, 0x003a, 0x0020, 0x0063, 0x006c, 0x0069, 0x0065, 0x006e, 0x0074, 0x0065, 0x0020, 0x0061
INITD 0x0063, 0x0065, 0x0069, 0x0074, 0x006f, 0x000a, 0x0000, 0x004e, 0x0045, 0x0054, 0x0020, 0x0053
INITD 0x0045, 0x0052, 0x0056, 0x0045, 0x0052, 0x0020, 0x0052, 0x0058, 0x003a, 0x0020, 0x0000, 0x004e
INITD 0x0045, 0x0054, 0x0020, 0x0053, 0x0045, 0x0052, 0x0056, 0x0045, 0x0052, 0x003a, 0x0020, 0x0065
INITD 0x006e, 0x0063, 0x0065, 0x0072, 0x0072, 0x0061, 0x0064, 0x006f, 0x000a, 0x0000, 0x001a, 0x0000
INITD 0x0001, 0x2804, 0x2805, 0x2806, 0x2809, 0x280a, 0x280b, 0x2802, 0x2a00, 0x2f00, 0x3000, 0x3100
INITD 0x3200, 0x3300, 0x3400, 0x3d00, 0x2900, 0x2b00, 0x2c00, 0x3500, 0x3800, 0x0000, 0x0001, 0x0019
INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
INITD 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000

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
OVERLAY_MAGIC: DD 51966
OVERLAY_HEADER_SIZE: DD 7
NET_IO_WORD_MIN: DD 10240
NET_IO_WORD_MAX: DD 16127
prog_const_3: DD 3
prog_const_6: DD 6
prog_const_25: DD 25
prog_const_27: DD 27
prog_const_29: DD 29
prog_const_2: DD 2
prog_const_1: DD 1
prog_const_0: DD 0
prog_const_4: DD 4
prog_const_5: DD 5
prog_const_11: DD 11
prog_const_12: DD 12
prog_const_13: DD 13
prog_const_10: DD 10
prog_const_9: DD 9
prog_const_7: DD 7
prog_const_8: DD 8
prog_const_14: DD 14
prog_const_15: DD 15
prog_const_16: DD 16
prog_const_17: DD 17
prog_const_18: DD 18
prog_const_19: DD 19
prog_const_20: DD 20
prog_const_21: DD 21
prog_const_22: DD 22
prog_const_23: DD 23
prog_const_24: DD 24
prog_const_28: DD 28
prog_const_26: DD 26
prog_const_30: DD 30
prog_const_31: DD 31
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
kernel_net_result: RESD 1
overlay_boot_addr_0: RESD 1
overlay_boot_addr_1: RESD 1
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
main_i: RESD 1
main_p: RESD 1
main_curr: RESD 1
main_target_sp: RESD 1
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
wakeup_all_i: RESD 1
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
kernel_print_char_ascii_code: RESD 1
kernel_read_char_val: RESD 1
kernel_net_out_io_word: RESD 1
kernel_net_in_io_word: RESD 1
kernel_signal_inject_target_sp: RESD 1
kernel_signal_inject_curr: RESD 1
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
