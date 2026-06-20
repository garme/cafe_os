# Validação TCP/UDP e impacto nos segmentos de 4K

## Resultado funcional

- Periférico Python: cliente/servidor TCP preservados.
- Periférico Python: eco UDP real validado com sockets não bloqueantes.
- Contextos de registradores por PID preservados na porta 63.
- Modos Overlay, Kernel e Kernel+Overlay compilados pela toolchain Cariri.

## Overlays isolados

| Overlay | Código | Dados + pilha | Margem código | Margem dados |
|---|---:|---:|---:|---:|
| TCP cliente | 1252/4096 | 350/4096 | 2844 | 3746 |
| TCP servidor | 1262/4096 | 349/4096 | 2834 | 3747 |
| UDP cliente | 971/4096 | 314/4096 | 3125 | 3782 |
| UDP servidor | 1202/4096 | 300/4096 | 2894 | 3796 |

## Kernel + overlays

| Build | Código | Dados + pilha + imagens | Margem código | Margem dados | Protocolos |
|---|---:|---:|---:|---:|---|
| Hello | 2582/4096 | 737/4096 | 1514 | 3359 | — |
| TCP cliente | 2924/4096 | 2116/4096 | 1172 | 1980 | TCP |
| TCP servidor | 2924/4096 | 2125/4096 | 1172 | 1971 | TCP |
| UDP cliente | 2729/4096 | 1796/4096 | 1367 | 2300 | UDP |
| UDP servidor | 2729/4096 | 2013/4096 | 1367 | 2083 | UDP |
| UDP cliente + servidor | 2737/4096 | 3206/4096 | 1359 | 890 | UDP |
| TCP cliente + UDP cliente | 2932/4096 | 3309/4096 | 1164 | 787 | TCP, UDP |
| TCP cliente + servidor | 2932/4096 | 3635/4096 | 1164 | 461 | TCP |

## Cenário bloqueado

A seleção simultânea de cliente e servidor TCP mais cliente e servidor UDP foi corretamente rejeitada: `Kernel+Overlay excede o limite arquitetural de 4 Ki palavras: segmento de dados+pilha: 6238/4096 palavras`

A restrição vem do segmento de dados: as imagens compactas dos quatro overlays são armazenadas junto de `.data`, `.bss` e pilha.

## Kernel isolado

O modo Kernel compilou com 5573 palavras de instrução e 6138 linhas ASM. Como o fallback inclui todos os módulos, ele ultrapassa 4096 instruções e deve ser usado para inspeção. O modo executável recomendado permanece Kernel+Overlay seletivo.

## Arquivos seletivos de rede

- `usr_net_core.c`: núcleo comum.
- `usr_net_tcp.c`: somente TCP.
- `usr_net_udp.c`: somente UDP.
- `usr_net.c`: compatibilidade TCP.
- `sys_net.c`: driver genérico compartilhado.
