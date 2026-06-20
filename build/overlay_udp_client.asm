.code
main:
CALL net_udp_socket
SOP POP_OP
STA udp_socket
LDA udp_socket
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
CALL udp_newline
SOP POP_OP
CALL exit
SOP POP_OP
fim_if_2:
LDA udp_socket
SOP PUSH_OP
CALL net_select_socket
SOP POP_OP
MOV prog_str_1
SOP PUSH_OP
CALL net_send_text
SOP POP_OP
LDA udp_socket
SOP PUSH_OP
MOV 127
SOP PUSH_OP
MOV 0
SOP PUSH_OP
MOV 0
SOP PUSH_OP
MOV 1
SOP PUSH_OP
MOV 146
SOP PUSH_OP
MOV 31
SOP PUSH_OP
CALL net_udp_sendto_ipv4
SOP POP_OP
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JN bloco_then_3
JMP fim_if_4
bloco_then_3:
MOV prog_str_2
SOP PUSH_OP
CALL printstr
SOP POP_OP
CALL udp_newline
SOP POP_OP
LDA udp_socket
SOP PUSH_OP
CALL net_udp_close
SOP POP_OP
CALL exit
SOP POP_OP
fim_if_4:
MOV prog_str_3
SOP PUSH_OP
CALL printstr
SOP POP_OP
CALL udp_newline
SOP POP_OP
MOV 1
STA tmp_val
LDA prog_const_0
SUB tmp_val
STA udp_size
while_start_5:
LDA udp_size
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JN while_start_5_true
JMP while_end_6
while_start_5_true:
LDA udp_socket
SOP PUSH_OP
CALL net_udp_recvfrom
SOP POP_OP
STA udp_size
LDA udp_size
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JN bloco_then_7
JMP fim_if_8
bloco_then_7:
CALL net_has_error
SOP POP_OP
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_1
JZ bloco_then_9
JMP fim_if_10
bloco_then_9:
MOV prog_str_4
SOP PUSH_OP
CALL printstr
SOP POP_OP
CALL udp_newline
SOP POP_OP
LDA udp_socket
SOP PUSH_OP
CALL net_udp_close
SOP POP_OP
CALL exit
SOP POP_OP
fim_if_10:
CALL yield
SOP POP_OP
fim_if_8:
JMP while_start_5
while_end_6:
MOV prog_str_5
SOP PUSH_OP
CALL printstr
SOP POP_OP
MOV 0
STA udp_i
while_start_11:
LDA udp_i
STA tmp_left_cond
LDA tmp_left_cond
SUB udp_size
JN while_start_11_true
JMP while_end_12
while_start_11_true:
CALL net_recv_byte
SOP POP_OP
STA udp_c
LDA udp_c
SOP PUSH_OP
CALL print_char
SOP POP_OP
LDA udp_i
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA udp_i
JMP while_start_11
while_end_12:
CALL udp_newline
SOP POP_OP
LDA udp_socket
SOP PUSH_OP
CALL net_udp_close
SOP POP_OP
CALL exit
SOP POP_OP
fim_func_main:
MOV 0
SOP PUSH_OP
MOV 1
SOP PUSH_OP
INT SYSCALL_INT
overlay_exit_loop_13:
MOV 0
SOP PUSH_OP
MOV 9
SOP PUSH_OP
INT SYSCALL_INT
JMP overlay_exit_loop_13
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
JZ fim_if_15
bloco_then_14:
MOV 1
STA tmp_val
SOP POP_OP
STA tmp_left
LDA tmp_val
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
fim_if_15:
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
net_send_text:
SOP POP_OP
STA tmp_left
SOP POP_OP
STA net_send_text_text
LDA tmp_left
SOP PUSH_OP
MOV 0
STA net_send_text_i
LDA net_send_text_text
STA tmp_arr_base
LDA net_send_text_i
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA net_send_text_c
while_start_16:
LDA net_send_text_c
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ while_end_17
while_start_16_true:
LDA net_send_text_c
SOP PUSH_OP
CALL net_send_byte
SOP POP_OP
LDA net_send_text_i
STA tmp_left
MOV 1
STA tmp_right
LDA tmp_left
ADD tmp_right
STA net_send_text_i
LDA net_send_text_text
STA tmp_arr_base
LDA net_send_text_i
ADD tmp_arr_base
STA tmp_ptr
LDI tmp_ptr
STA net_send_text_c
JMP while_start_16
while_end_17:
fim_func_net_send_text:
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
JZ bloco_then_18
JMP fim_if_19
bloco_then_18:
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
fim_if_19:
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
JZ bloco_then_20
JMP fim_if_21
bloco_then_20:
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
fim_if_21:
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
while_start_22:
LDA printstr_c
STA tmp_left_cond
LDA tmp_left_cond
SUB prog_const_0
JZ while_end_23
while_start_22_true:
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
JMP while_start_22
while_end_23:
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
while_start_24:
MOV 1
SUB prog_const_0
JZ while_end_25
MOV 0
SOP PUSH_OP
MOV 9
SOP PUSH_OP
INT SYSCALL_INT
JMP while_start_24
while_end_25:
fim_func_exit:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
udp_newline:
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
fim_func_udp_newline:
SOP POP_OP
STA tmp_left
LDA prog_const_0
SOP PUSH_OP
LDA tmp_left
SOP PUSH_OP
RET
.data
prog_str_0: INITB 85,68,80,32,67,76,73,69,78,84,58,32,115,101,109,32,115,111,99,107,101,116,0
prog_str_1: INITB 80,73,78,71,32,85,68,80,32,68,79,32,71,85,73,76,73,88,0
prog_str_2: INITB 85,68,80,32,67,76,73,69,78,84,58,32,101,110,118,105,111,32,102,97,108,104,111,117,0
prog_str_3: INITB 85,68,80,32,67,76,73,69,78,84,58,32,100,97,116,97,103,114,97,109,97,32,101,110,118,105,97,100,111,0
prog_str_4: INITB 85,68,80,32,67,76,73,69,78,84,58,32,114,101,99,101,112,99,97,111,32,102,97,108,104,111,117,0
prog_str_5: INITB 85,68,80,32,67,76,73,69,78,84,32,82,88,58,32,0
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
udp_socket: RESD 1
udp_size: RESD 1
udp_i: RESD 1
udp_c: RESD 1
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
net_send_text_text: RESD 1
net_send_text_i: RESD 1
net_send_text_c: RESD 1
net_close_socket_socket_id: RESD 1
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
