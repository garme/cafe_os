#ifndef SYS_THREAD_EXIT_C
#define SYS_THREAD_EXIT_C

//----------------------------------------------------------------------
// --- Encerramento explícito de thread ---
//----------------------------------------------------------------------
// thread_exit() encerra apenas a thread chamadora.
//
// Diferença para exit():
//   - exit() é a chamada genérica de encerramento da tarefa/processo atual.
//   - thread_exit() é intencionalmente restrita a tarefas criadas por
//     thread_create(). Se chamada por um processo lógico comum, retorna -1.
//
// A liberação efetiva usa kernel_release_process_resources(), que libera a
// pilha própria da thread e só libera a área .data compartilhada se esta for
// heap e se não houver mais nenhuma tarefa viva compartilhando o mesmo mem_base.
int kernel_thread_exit() {
    if (curr_pcb->is_thread != 1) {
        return -1;
    }

    curr_pcb->state = STATE_TERMINATED;
    kernel_release_process_resources(current_pid);
    wakeup_waiters(current_pid);
    kernel_need_resched = 1;
    return 0;
}

#endif
