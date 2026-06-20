.code
main:
CALL net_udp_socket
SOP POP_OP
STA udp_server_socket
LDA udp_server_socket
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JN bloco_then_1
JMP fim_if_2
bloco_then_1:
MOV prog_str_0
SOP PUSH_OP
CALL printstr
SOP POP_OP
CALL udp_server_newline
SOP POP_OP
CALL exit
SOP POP_OP
fim_if_2:
LDA udp_server_socket
SOP PUSH_OP
MOV 0
SOP PUSH_OP
MOV 0
SOP PUSH_OP
MOV 0
SOP PUSH_OP
MOV 0
SOP PUSH_OP
MOV 146
SOP PUSH_OP
MOV 31
SOP PUSH_OP
CALL net_udp_bind_ipv4
SOP POP_OP
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JN bloco_then_3
JMP fim_if_4
bloco_then_3:
MOV prog_str_1
SOP PUSH_OP
CALL printstr
SOP POP_OP
CALL udp_server_newline
SOP POP_OP
LDA udp_server_socket
SOP PUSH_OP
CALL net_udp_close
SOP POP_OP
CALL exit
SOP POP_OP
fim_if_4:
MOV prog_str_2
SOP PUSH_OP
CALL printstr
SOP POP_OP
CALL udp_server_newline
SOP POP_OP
while_start_5:
MOV 1
SUB prog_const_0
JZ while_end_6
LDA udp_server_socket
SOP PUSH_OP
CALL net_udp_recvfrom
SOP POP_OP
STA udp_packet_size
LDA udp_packet_size
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JN bloco_then_7
JMP bloco_else_8
bloco_then_7:
CALL net_has_error
SOP POP_OP
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_10
JMP fim_if_11
bloco_then_10:
MOV prog_str_3
SOP PUSH_OP
CALL printstr
SOP POP_OP
CALL udp_server_newline
SOP POP_OP
LDA udp_server_socket
SOP PUSH_OP
CALL net_udp_close
SOP POP_OP
CALL exit
SOP POP_OP
fim_if_11:
CALL yield
SOP POP_OP
JMP fim_if_9
bloco_else_8:
CALL net_udp_sender_ip0
SOP POP_OP
STA udp_sender0
CALL net_udp_sender_ip1
SOP POP_OP
STA udp_sender1
CALL net_udp_sender_ip2
SOP POP_OP
STA udp_sender2
CALL net_udp_sender_ip3
SOP POP_OP
STA udp_sender3
CALL net_udp_sender_port_low
SOP POP_OP
STA udp_sender_port_low_value
CALL net_udp_sender_port_high
SOP POP_OP
STA udp_sender_port_high_value
MOV prog_str_4
SOP PUSH_OP
CALL printstr
SOP POP_OP
MOV 0
STA udp_index
while_start_12:
LDA udp_index
STA tmp_left_cond
LDA tmp_left_cond
SUB udp_packet_size
JN while_start_12_true
JMP while_end_13
while_start_12_true:
CALL net_recv_byte
SOP POP_OP
STA udp_received
LDA udp_received
SOP PUSH_OP
CALL print_char
SOP POP_OP
LDA udp_received
SOP PUSH_OP
CALL net_send_byte
SOP POP_OP
LDA udp_index
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA udp_index
JMP while_start_12
while_end_13:
CALL udp_server_newline
SOP POP_OP
LDA udp_server_socket
SOP PUSH_OP
LDA udp_sender0
SOP PUSH_OP
LDA udp_sender1
SOP PUSH_OP
LDA udp_sender2
SOP PUSH_OP
LDA udp_sender3
SOP PUSH_OP
LDA udp_sender_port_low_value
SOP PUSH_OP
LDA udp_sender_port_high_value
SOP PUSH_OP
CALL net_udp_sendto_ipv4
SOP POP_OP
fim_if_9:
JMP while_start_5
while_end_6:
fim_func_main:
MOV 0
SOP PUSH_OP
MOV 1
SOP PUSH_OP
INT SYSCALL_INT
overlay_exit_loop_14:
MOV 0
SOP PUSH_OP
MOV 9
SOP PUSH_OP
INT SYSCALL_INT
JMP overlay_exit_loop_14
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
net_get_ip0:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_12032
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
fim_func_net_get_ip0:
RET
net_get_ip1:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_12288
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
fim_func_net_get_ip1:
RET
net_get_ip2:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_12544
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
fim_func_net_get_ip2:
RET
net_get_ip3:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_12800
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
fim_func_net_get_ip3:
RET
net_get_port_low:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_13056
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
fim_func_net_get_port_low:
RET
net_get_port_high:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
LDA prog_const_13312
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
fim_func_net_get_port_high:
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
JZ fim_if_16
bloco_then_15:
MOV 1
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_16:
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
net_udp_socket:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 12
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
fim_func_net_udp_socket:
RET
net_udp_bind_ipv4:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_udp_bind_ipv4_port_high
SOP POP_OP
STA net_udp_bind_ipv4_port_low
SOP POP_OP
STA net_udp_bind_ipv4_ip3
SOP POP_OP
STA net_udp_bind_ipv4_ip2
SOP POP_OP
STA net_udp_bind_ipv4_ip1
SOP POP_OP
STA net_udp_bind_ipv4_ip0
SOP POP_OP
STA net_udp_bind_ipv4_socket_id
LDA tmp_left
SOP PUSH_OP
LDA net_udp_bind_ipv4_socket_id
SOP PUSH_OP
LDA net_udp_bind_ipv4_ip0
SOP PUSH_OP
LDA net_udp_bind_ipv4_ip1
SOP PUSH_OP
LDA net_udp_bind_ipv4_ip2
SOP PUSH_OP
LDA net_udp_bind_ipv4_ip3
SOP PUSH_OP
LDA net_udp_bind_ipv4_port_low
SOP PUSH_OP
LDA net_udp_bind_ipv4_port_high
SOP PUSH_OP
CALL net_configure_ipv4
SOP POP_OP
MOV 13
SOP PUSH_OP
CALL net_command
SOP POP_OP
CALL net_has_error
SOP POP_OP
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_17
JMP fim_if_18
bloco_then_17:
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
fim_if_18:
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
fim_func_net_udp_bind_ipv4:
RET
net_udp_sendto_ipv4:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_udp_sendto_ipv4_port_high
SOP POP_OP
STA net_udp_sendto_ipv4_port_low
SOP POP_OP
STA net_udp_sendto_ipv4_ip3
SOP POP_OP
STA net_udp_sendto_ipv4_ip2
SOP POP_OP
STA net_udp_sendto_ipv4_ip1
SOP POP_OP
STA net_udp_sendto_ipv4_ip0
SOP POP_OP
STA net_udp_sendto_ipv4_socket_id
LDA tmp_left
SOP PUSH_OP
LDA net_udp_sendto_ipv4_socket_id
SOP PUSH_OP
LDA net_udp_sendto_ipv4_ip0
SOP PUSH_OP
LDA net_udp_sendto_ipv4_ip1
SOP PUSH_OP
LDA net_udp_sendto_ipv4_ip2
SOP PUSH_OP
LDA net_udp_sendto_ipv4_ip3
SOP PUSH_OP
LDA net_udp_sendto_ipv4_port_low
SOP PUSH_OP
LDA net_udp_sendto_ipv4_port_high
SOP PUSH_OP
CALL net_configure_ipv4
SOP POP_OP
MOV 14
SOP PUSH_OP
CALL net_command
SOP POP_OP
CALL net_has_error
SOP POP_OP
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_19
JMP fim_if_20
bloco_then_19:
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
fim_if_20:
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
fim_func_net_udp_sendto_ipv4:
RET
net_udp_recvfrom:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_udp_recvfrom_socket_id
LDA tmp_left
SOP PUSH_OP
LDA net_udp_recvfrom_socket_id
SOP PUSH_OP
CALL net_select_socket
SOP POP_OP
MOV 15
SOP PUSH_OP
CALL net_command
SOP POP_OP
CALL net_result
SOP POP_OP
STA net_udp_recvfrom_size
LDA net_udp_recvfrom_size
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_65535
JZ bloco_then_21
JMP fim_if_22
bloco_then_21:
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
fim_if_22:
LDA net_udp_recvfrom_size
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_udp_recvfrom:
RET
net_udp_sender_ip0:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
CALL net_get_ip0
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_udp_sender_ip0:
RET
net_udp_sender_ip1:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
CALL net_get_ip1
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_udp_sender_ip1:
RET
net_udp_sender_ip2:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
CALL net_get_ip2
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_udp_sender_ip2:
RET
net_udp_sender_ip3:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
CALL net_get_ip3
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_udp_sender_ip3:
RET
net_udp_sender_port_low:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
CALL net_get_port_low
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_udp_sender_port_low:
RET
net_udp_sender_port_high:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
CALL net_get_port_high
SOP POP_OP
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_func_net_udp_sender_port_high:
RET
net_udp_close:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_udp_close_socket_id
LDA tmp_left
SOP PUSH_OP
LDA net_udp_close_socket_id
SOP PUSH_OP
CALL net_close_socket
SOP POP_OP
fim_func_net_udp_close:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
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
while_start_23:
LDA printstr_c
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ while_end_24
while_start_23_true:
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
JMP while_start_23
while_end_24:
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
while_start_25:
MOV 1
SUB prog_const_0
JZ while_end_26
MOV 0
SOP PUSH_OP
MOV 9
SOP PUSH_OP
INT SYSCALL_INT
JMP while_start_25
while_end_26:
fim_func_exit:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
udp_server_newline:
SOP POP_OP
STA tmp_left
LDA tmp_left
SOP PUSH_OP
MOV 13
SOP PUSH_OP
CALL print_char
SOP POP_OP
MOV 10
SOP PUSH_OP
CALL print_char
SOP POP_OP
fim_func_udp_server_newline:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
.data
prog_str_0: INITB 85,68,80,32,83,69,82,86,69,82,58,32,115,101,109,32,115,111,99,107,101,116,0
prog_str_1: INITB 85,68,80,32,83,69,82,86,69,82,58,32,98,105,110,100,32,102,97,108,104,111,117,0
prog_str_2: INITB 85,68,80,32,83,69,82,86,69,82,58,32,111,117,118,105,110,100,111,32,56,48,56,50,0
prog_str_3: INITB 85,68,80,32,83,69,82,86,69,82,58,32,101,114,114,111,32,100,101,32,114,101,99,101,112,99,97,111,0
prog_str_4: INITB 85,68,80,32,83,69,82,86,69,82,32,82,88,58,32,0
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
prog_const_10496: DD 10496
prog_const_11008: DD 11008
prog_const_11264: DD 11264
prog_const_13568: DD 13568
prog_const_14336: DD 14336
prog_const_65535: DD 65535
PUSH_OP: DD 0
POP_OP: DD 1
HALT_INT: DD 25
.bss
sys_ret_val: RESD 1
udp_server_socket: RESD 1
udp_packet_size: RESD 1
udp_received: RESD 1
udp_index: RESD 1
udp_sender0: RESD 1
udp_sender1: RESD 1
udp_sender2: RESD 1
udp_sender3: RESD 1
udp_sender_port_low_value: RESD 1
udp_sender_port_high_value: RESD 1
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
net_configure_ipv4_port_high: RESD 1
net_configure_ipv4_port_low: RESD 1
net_configure_ipv4_ip3: RESD 1
net_configure_ipv4_ip2: RESD 1
net_configure_ipv4_ip1: RESD 1
net_configure_ipv4_ip0: RESD 1
net_configure_ipv4_socket_id: RESD 1
net_result_result_lo_value: RESD 1
net_result_result_hi_value: RESD 1
net_has_error_status: RESD 1
net_send_byte_value: RESD 1
net_close_socket_socket_id: RESD 1
net_udp_bind_ipv4_port_high: RESD 1
net_udp_bind_ipv4_port_low: RESD 1
net_udp_bind_ipv4_ip3: RESD 1
net_udp_bind_ipv4_ip2: RESD 1
net_udp_bind_ipv4_ip1: RESD 1
net_udp_bind_ipv4_ip0: RESD 1
net_udp_bind_ipv4_socket_id: RESD 1
net_udp_sendto_ipv4_port_high: RESD 1
net_udp_sendto_ipv4_port_low: RESD 1
net_udp_sendto_ipv4_ip3: RESD 1
net_udp_sendto_ipv4_ip2: RESD 1
net_udp_sendto_ipv4_ip1: RESD 1
net_udp_sendto_ipv4_ip0: RESD 1
net_udp_sendto_ipv4_socket_id: RESD 1
net_udp_recvfrom_socket_id: RESD 1
net_udp_recvfrom_size: RESD 1
net_udp_close_socket_id: RESD 1
print_char_ascii: RESD 1
printstr_str: RESD 1
printstr_i: RESD 1
printstr_c: RESD 1
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
