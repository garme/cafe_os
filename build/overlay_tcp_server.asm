.code
main:
MOV 0
STA failed
CALL net_socket_tcp
SOP POP_OP
STA server_socket
LDA server_socket
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JN bloco_then_1
JMP fim_if_2
bloco_then_1:
MOV prog_str_0
SOP PUSH_OP
CALL net_server_log
SOP POP_OP
MOV 1
STA failed
fim_if_2:
LDA failed
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_3
JMP fim_if_4
bloco_then_3:
LDA server_socket
SOP PUSH_OP
MOV 127
SOP PUSH_OP
MOV 0
SOP PUSH_OP
MOV 0
SOP PUSH_OP
MOV 1
SOP PUSH_OP
MOV 145
SOP PUSH_OP
MOV 31
SOP PUSH_OP
CALL net_bind_ipv4
SOP POP_OP
STA bind_result
LDA bind_result
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JN bloco_then_5
JMP fim_if_6
bloco_then_5:
MOV prog_str_1
SOP PUSH_OP
CALL net_server_log
SOP POP_OP
MOV 1
STA failed
fim_if_6:
fim_if_4:
LDA failed
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_7
JMP fim_if_8
bloco_then_7:
LDA server_socket
SOP PUSH_OP
MOV 2
SOP PUSH_OP
CALL net_listen_socket
SOP POP_OP
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JN bloco_then_9
JMP fim_if_10
bloco_then_9:
MOV prog_str_2
SOP PUSH_OP
CALL net_server_log
SOP POP_OP
MOV 1
STA failed
fim_if_10:
fim_if_8:
LDA failed
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_11
JMP fim_if_12
bloco_then_11:
MOV prog_str_3
SOP PUSH_OP
CALL net_server_log
SOP POP_OP
MOV 1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA client_socket
while_start_13:
LDA client_socket
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JN while_start_13_true
JMP while_end_14
while_start_13_true:
LDA server_socket
SOP PUSH_OP
CALL net_accept
SOP POP_OP
STA client_socket
CALL net_has_error
SOP POP_OP
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_15
JMP bloco_else_16
bloco_then_15:
MOV 1
STA failed
MOV 0
STA client_socket
JMP fim_if_17
bloco_else_16:
CALL yield
SOP POP_OP
fim_if_17:
JMP while_start_13
while_end_14:
fim_if_12:
LDA failed
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ bloco_then_18
JMP fim_if_19
bloco_then_18:
MOV prog_str_4
SOP PUSH_OP
CALL net_server_log
SOP POP_OP
MOV 0
STA available
while_start_20:
LDA available
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ while_start_20_true
JMP while_end_21
while_start_20_true:
LDA client_socket
SOP PUSH_OP
MOV 40
SOP PUSH_OP
CALL net_wait_rx_socket
SOP POP_OP
STA available
CALL yield
SOP POP_OP
JMP while_start_20
while_end_21:
LDA available
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ fim_if_23
JN fim_if_23
bloco_then_22:
CALL sem_lock
SOP POP_OP
MOV prog_str_5
SOP PUSH_OP
CALL printstr
SOP POP_OP
LDA client_socket
SOP PUSH_OP
CALL net_select_socket
SOP POP_OP
while_start_24:
CALL net_rx_available
SOP POP_OP
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ while_start_24_true
JMP while_end_25
while_start_24_true:
CALL net_recv_byte
SOP POP_OP
STA received
LDA received
SOP PUSH_OP
CALL print_char
SOP POP_OP
LDA received
SOP PUSH_OP
CALL net_send_byte
SOP POP_OP
JMP while_start_24
while_end_25:
CALL net_send
SOP POP_OP
CALL sem_unlock
SOP POP_OP
fim_if_23:
LDA client_socket
SOP PUSH_OP
CALL net_close_socket
SOP POP_OP
LDA server_socket
SOP PUSH_OP
CALL net_close_socket
SOP POP_OP
MOV prog_str_6
SOP PUSH_OP
CALL net_server_log
SOP POP_OP
fim_if_19:
CALL exit
SOP POP_OP
fim_func_main:
MOV 0
SOP PUSH_OP
MOV 1
SOP PUSH_OP
INT SYSCALL_INT
overlay_exit_loop_26:
MOV 0
SOP PUSH_OP
MOV 9
SOP PUSH_OP
INT SYSCALL_INT
JMP overlay_exit_loop_26
net_sys_out:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_sys_out_io_word
LDA tmp_left
SOP PUSH_OP
LDA net_sys_out_io_word
SOP PUSH_OP
MOV 30
SOP PUSH_OP
INT SYSCALL_INT
STA sys_ret_val
LDA sys_ret_val
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_sys_out:
RET
net_sys_in:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_sys_in_io_word
LDA tmp_left
SOP PUSH_OP
LDA net_sys_in_io_word
SOP PUSH_OP
MOV 31
SOP PUSH_OP
INT SYSCALL_INT
STA sys_ret_val
LDA sys_ret_val
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_sys_in:
RET
net_command:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_command_command
LDA tmp_left
SOP PUSH_OP
LDA prog_const_10240
STA tmp_left
LDA net_command_command
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
CALL net_sys_out
SOP POP_OP
fim_func_net_command:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_poll:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 5
SOP PUSH_OP
CALL net_command
SOP POP_OP
fim_func_net_poll:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_close:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 6
SOP PUSH_OP
CALL net_command
SOP POP_OP
fim_func_net_close:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_select_socket:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_select_socket_socket_id
LDA tmp_left
SOP PUSH_OP
LDA prog_const_10752
STA tmp_left
LDA net_select_socket_socket_id
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
CALL net_sys_out
SOP POP_OP
fim_func_net_select_socket:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_set_ip0:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_set_ip0_value
LDA tmp_left
SOP PUSH_OP
LDA prog_const_12032
STA tmp_left
LDA net_set_ip0_value
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
CALL net_sys_out
SOP POP_OP
fim_func_net_set_ip0:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_set_ip1:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_set_ip1_value
LDA tmp_left
SOP PUSH_OP
LDA prog_const_12288
STA tmp_left
LDA net_set_ip1_value
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
CALL net_sys_out
SOP POP_OP
fim_func_net_set_ip1:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_set_ip2:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_set_ip2_value
LDA tmp_left
SOP PUSH_OP
LDA prog_const_12544
STA tmp_left
LDA net_set_ip2_value
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
CALL net_sys_out
SOP POP_OP
fim_func_net_set_ip2:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_set_ip3:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_set_ip3_value
LDA tmp_left
SOP PUSH_OP
LDA prog_const_12800
STA tmp_left
LDA net_set_ip3_value
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
CALL net_sys_out
SOP POP_OP
fim_func_net_set_ip3:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_set_port_low:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_set_port_low_value
LDA tmp_left
SOP PUSH_OP
LDA prog_const_13056
STA tmp_left
LDA net_set_port_low_value
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
CALL net_sys_out
SOP POP_OP
fim_func_net_set_port_low:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_set_port_high:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_set_port_high_value
LDA tmp_left
SOP PUSH_OP
LDA prog_const_13312
STA tmp_left
LDA net_set_port_high_value
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
CALL net_sys_out
SOP POP_OP
fim_func_net_set_port_high:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_set_backlog:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_set_backlog_value
LDA tmp_left
SOP PUSH_OP
LDA prog_const_15616
STA tmp_left
LDA net_set_backlog_value
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
CALL net_sys_out
SOP POP_OP
fim_func_net_set_backlog:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_configure_ipv4:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_configure_ipv4_port_high
SOP POP_OP
STA net_configure_ipv4_port_low
SOP POP_OP
STA net_configure_ipv4_ip3
SOP POP_OP
STA net_configure_ipv4_ip2
SOP POP_OP
STA net_configure_ipv4_ip1
SOP POP_OP
STA net_configure_ipv4_ip0
SOP POP_OP
STA net_configure_ipv4_socket_id
LDA tmp_left
SOP PUSH_OP
LDA net_configure_ipv4_socket_id
SOP PUSH_OP
CALL net_select_socket
SOP POP_OP
LDA net_configure_ipv4_ip0
SOP PUSH_OP
CALL net_set_ip0
SOP POP_OP
LDA net_configure_ipv4_ip1
SOP PUSH_OP
CALL net_set_ip1
SOP POP_OP
LDA net_configure_ipv4_ip2
SOP PUSH_OP
CALL net_set_ip2
SOP POP_OP
LDA net_configure_ipv4_ip3
SOP PUSH_OP
CALL net_set_ip3
SOP POP_OP
LDA net_configure_ipv4_port_low
SOP PUSH_OP
CALL net_set_port_low
SOP POP_OP
LDA net_configure_ipv4_port_high
SOP PUSH_OP
CALL net_set_port_high
SOP POP_OP
fim_func_net_configure_ipv4:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_status:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_10496
SOP PUSH_OP
CALL net_sys_in
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_status:
RET
net_result_low:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_11008
SOP PUSH_OP
CALL net_sys_in
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_result_low:
RET
net_result_high:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_11264
SOP PUSH_OP
CALL net_sys_in
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_result_high:
RET
net_result:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
CALL net_result_low
SOP POP_OP
STA net_result_result_lo_value
CALL net_result_high
SOP POP_OP
STA net_result_result_hi_value
LDA net_result_result_hi_value
STA tmp_left
MOV 256
STA tmp_right
LDA tmp_left
LDA net_result_result_hi_value
STA tmp_a_mul
LDA prog_const_0
STA tmp_res_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
LDA tmp_a_mul
SHIFT prog_const_1
STA tmp_a_mul
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
STA net_result_result_hi_value
LDA net_result_result_lo_value
STA tmp_left
LDA net_result_result_hi_value
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
fim_func_net_result:
RET
net_has_rx_or_accept:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
CALL net_status
SOP POP_OP
STA net_has_rx_or_accept_status
LDA net_has_rx_or_accept_status
STA tmp_left
MOV 8
STA tmp_right
LDA tmp_left
NAND tmp_right
STA tmp_and
NAND tmp_and
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ fim_if_28
bloco_then_27:
MOV 1
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_28:
MOV 0
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_has_rx_or_accept:
RET
net_rx_available:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
CALL net_has_rx_or_accept
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_rx_available:
RET
net_has_error:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
CALL net_status
SOP POP_OP
STA net_has_error_status
LDA net_has_error_status
STA tmp_left
MOV 32
STA tmp_right
LDA tmp_left
NAND tmp_right
STA tmp_and
NAND tmp_and
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ fim_if_30
bloco_then_29:
MOV 1
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_30:
MOV 0
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_has_error:
RET
net_send_byte:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_send_byte_value
LDA tmp_left
SOP PUSH_OP
LDA prog_const_13568
STA tmp_left
LDA net_send_byte_value
STA tmp_right
LDA tmp_left
ADD tmp_right
SOP PUSH_OP
CALL net_sys_out
SOP POP_OP
fim_func_net_send_byte:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_recv_byte:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_14336
SOP PUSH_OP
CALL net_sys_in
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_recv_byte:
RET
net_close_socket:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_close_socket_socket_id
LDA tmp_left
SOP PUSH_OP
LDA net_close_socket_socket_id
SOP PUSH_OP
CALL net_select_socket
SOP POP_OP
CALL net_close
SOP POP_OP
fim_func_net_close_socket:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_send:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 4
SOP PUSH_OP
CALL net_command
SOP POP_OP
fim_func_net_send:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_bind_start:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 9
SOP PUSH_OP
CALL net_command
SOP POP_OP
fim_func_net_bind_start:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_listen_start:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 10
SOP PUSH_OP
CALL net_command
SOP POP_OP
fim_func_net_listen_start:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_accept_start:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 11
SOP PUSH_OP
CALL net_command
SOP POP_OP
fim_func_net_accept_start:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_socket_tcp:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 2
SOP PUSH_OP
CALL net_command
SOP POP_OP
CALL net_result
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_socket_tcp:
RET
net_bind_ipv4:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_bind_ipv4_port_high
SOP POP_OP
STA net_bind_ipv4_port_low
SOP POP_OP
STA net_bind_ipv4_ip3
SOP POP_OP
STA net_bind_ipv4_ip2
SOP POP_OP
STA net_bind_ipv4_ip1
SOP POP_OP
STA net_bind_ipv4_ip0
SOP POP_OP
STA net_bind_ipv4_socket_id
LDA tmp_left
SOP PUSH_OP
LDA net_bind_ipv4_socket_id
SOP PUSH_OP
LDA net_bind_ipv4_ip0
SOP PUSH_OP
LDA net_bind_ipv4_ip1
SOP PUSH_OP
LDA net_bind_ipv4_ip2
SOP PUSH_OP
LDA net_bind_ipv4_ip3
SOP PUSH_OP
LDA net_bind_ipv4_port_low
SOP PUSH_OP
LDA net_bind_ipv4_port_high
SOP PUSH_OP
CALL net_configure_ipv4
SOP POP_OP
CALL net_bind_start
SOP POP_OP
CALL net_has_error
SOP POP_OP
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_31
JMP fim_if_32
bloco_then_31:
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
fim_if_32:
CALL net_result
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_bind_ipv4:
RET
net_listen_socket:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_listen_socket_backlog
SOP POP_OP
STA net_listen_socket_socket_id
LDA tmp_left
SOP PUSH_OP
LDA net_listen_socket_socket_id
SOP PUSH_OP
CALL net_select_socket
SOP POP_OP
LDA net_listen_socket_backlog
SOP PUSH_OP
CALL net_set_backlog
SOP POP_OP
CALL net_listen_start
SOP POP_OP
CALL net_has_error
SOP POP_OP
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_33
JMP fim_if_34
bloco_then_33:
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
fim_if_34:
MOV 0
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_listen_socket:
RET
net_accept:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_accept_server_socket
LDA tmp_left
SOP PUSH_OP
LDA net_accept_server_socket
SOP PUSH_OP
CALL net_select_socket
SOP POP_OP
CALL net_accept_start
SOP POP_OP
CALL net_result
SOP POP_OP
STA net_accept_accepted
LDA net_accept_accepted
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_accept:
RET
net_wait_rx:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_wait_rx_max_polls
LDA tmp_left
SOP PUSH_OP
MOV 0
STA net_wait_rx_i
while_start_35:
LDA net_wait_rx_i
STA tmp_left_cond
LDA tmp_left_cond
SUB net_wait_rx_max_polls
JN while_start_35_true
JMP while_end_36
while_start_35_true:
CALL net_poll
SOP POP_OP
CALL net_rx_available
SOP POP_OP
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_37
JMP fim_if_38
bloco_then_37:
MOV 1
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_38:
CALL net_has_error
SOP POP_OP
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_39
JMP fim_if_40
bloco_then_39:
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
fim_if_40:
LDA net_wait_rx_i
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA net_wait_rx_i
JMP while_start_35
while_end_36:
MOV 0
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_wait_rx:
RET
net_wait_rx_socket:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_wait_rx_socket_max_polls
SOP POP_OP
STA net_wait_rx_socket_socket_id
LDA tmp_left
SOP PUSH_OP
LDA net_wait_rx_socket_socket_id
SOP PUSH_OP
CALL net_select_socket
SOP POP_OP
LDA net_wait_rx_socket_max_polls
SOP PUSH_OP
CALL net_wait_rx
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_wait_rx_socket:
RET
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
while_start_41:
LDA printstr_c
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ while_end_42
while_start_41_true:
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
JMP while_start_41
while_end_42:
fim_func_printstr:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
yield:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 0
SOP PUSH_OP
MOV 9
SOP PUSH_OP
INT SYSCALL_INT
fim_func_yield:
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
while_start_43:
MOV 1
SUB prog_const_0
JZ while_end_44
CALL yield
SOP POP_OP
JMP while_start_43
while_end_44:
fim_func_exit:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
sem_lock:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 0
SOP PUSH_OP
MOV 4
SOP PUSH_OP
INT SYSCALL_INT
fim_func_sem_lock:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
sem_unlock:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 0
SOP PUSH_OP
MOV 5
SOP PUSH_OP
INT SYSCALL_INT
fim_func_sem_unlock:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
net_server_log:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_server_log_text
LDA tmp_left
SOP PUSH_OP
CALL sem_lock
SOP POP_OP
LDA net_server_log_text
SOP PUSH_OP
CALL printstr
SOP POP_OP
CALL sem_unlock
SOP POP_OP
fim_func_net_server_log:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
.data
prog_str_0: INITB 78,69,84,32,83,69,82,86,69,82,58,32,115,101,109,32,115,111,99,107,101,116,10,0
prog_str_1: INITB 78,69,84,32,83,69,82,86,69,82,58,32,98,105,110,100,32,102,97,108,104,111,117,10,0
prog_str_2: INITB 78,69,84,32,83,69,82,86,69,82,58,32,108,105,115,116,101,110,32,102,97,108,104,111,117,10,0
prog_str_3: INITB 78,69,84,32,83,69,82,86,69,82,58,32,111,117,118,105,110,100,111,32,56,48,56,49,10,0
prog_str_4: INITB 78,69,84,32,83,69,82,86,69,82,58,32,99,108,105,101,110,116,101,32,97,99,101,105,116,111,10,0
prog_str_5: INITB 78,69,84,32,83,69,82,86,69,82,32,82,88,58,32,0
prog_str_6: INITB 78,69,84,32,83,69,82,86,69,82,58,32,101,110,99,101,114,114,97,100,111,10,0
SYSCALL_INT: DD 26
prog_const_0: DD 0
prog_const_1: DD 1
prog_const_10240: DD 10240
prog_const_10752: DD 10752
prog_const_12032: DD 12032
prog_const_12288: DD 12288
prog_const_12544: DD 12544
prog_const_12800: DD 12800
prog_const_13056: DD 13056
prog_const_13312: DD 13312
prog_const_15616: DD 15616
prog_const_10496: DD 10496
prog_const_11008: DD 11008
prog_const_11264: DD 11264
prog_const_13568: DD 13568
prog_const_14336: DD 14336
PUSH_OP: DD 0
POP_OP: DD 1
HALT_INT: DD 25
.bss
sys_ret_val: RESD 1
server_socket: RESD 1
client_socket: RESD 1
bind_result: RESD 1
available: RESD 1
received: RESD 1
failed: RESD 1
net_sys_out_io_word: RESD 1
net_sys_in_io_word: RESD 1
net_command_command: RESD 1
net_select_socket_socket_id: RESD 1
net_set_ip0_value: RESD 1
net_set_ip1_value: RESD 1
net_set_ip2_value: RESD 1
net_set_ip3_value: RESD 1
net_set_port_low_value: RESD 1
net_set_port_high_value: RESD 1
net_set_backlog_value: RESD 1
net_configure_ipv4_port_high: RESD 1
net_configure_ipv4_port_low: RESD 1
net_configure_ipv4_ip3: RESD 1
net_configure_ipv4_ip2: RESD 1
net_configure_ipv4_ip1: RESD 1
net_configure_ipv4_ip0: RESD 1
net_configure_ipv4_socket_id: RESD 1
net_result_result_lo_value: RESD 1
net_result_result_hi_value: RESD 1
net_has_rx_or_accept_status: RESD 1
net_has_error_status: RESD 1
net_send_byte_value: RESD 1
net_close_socket_socket_id: RESD 1
net_bind_ipv4_port_high: RESD 1
net_bind_ipv4_port_low: RESD 1
net_bind_ipv4_ip3: RESD 1
net_bind_ipv4_ip2: RESD 1
net_bind_ipv4_ip1: RESD 1
net_bind_ipv4_ip0: RESD 1
net_bind_ipv4_socket_id: RESD 1
net_listen_socket_backlog: RESD 1
net_listen_socket_socket_id: RESD 1
net_accept_server_socket: RESD 1
net_accept_accepted: RESD 1
net_wait_rx_max_polls: RESD 1
net_wait_rx_i: RESD 1
net_wait_rx_socket_max_polls: RESD 1
net_wait_rx_socket_socket_id: RESD 1
print_char_ascii: RESD 1
printstr_str: RESD 1
printstr_i: RESD 1
printstr_c: RESD 1
net_server_log_text: RESD 1
tmp_a_mul: RESD 1
tmp_and: RESD 1
tmp_arr_base: RESD 1
tmp_left: RESD 1
tmp_left_cond: RESD 1
tmp_ptr: RESD 1
tmp_res_mul: RESD 1
tmp_right: RESD 1
tmp_val: RESD 1
.stack 100
