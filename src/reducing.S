    #include "linked_list.h"

    .data
nl:
    .string "\n"

    .text
### ----------------------------------------------------------
### x0 holds address linked list of grouped lists
### returns grouping lists
    .global reduce
    .type   reduce, %function
reduce:
    stp     x29, x30, [sp, #-16]!
    stp     x23, x24, [sp, #-16]!
    stp     x21, x22, [sp, #-16]!
    stp     x19, x20, [sp, #-16]!
    mov     x19, x0

    ldr     x20, [x19, #LINKED_LIST_COUNT]
    lsl     x0, x20, #3
    bl      malloc
    mov     x23, x0

    ldr     x21, [x19, #LINKED_LIST_HEAD] // current node
    mov     x22, #0
0:
    cmp     x21, #0
    beq     1f
    ldr     x0, [x21, #NODE_VALUE]
    bl      linked_list_reduce
    str     x0, [x23, x22, lsl #3]
    ldr     x21, [x21, #NODE_NEXT]
    add     x22, x22, #1
    b       0b
1:
    mov     x0, x23
    mov     x1, x20
    ldp     x19, x20, [sp], #16
    ldp     x21, x22, [sp], #16
    ldp     x23, x24, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    .size   reduce, (. - reduce)
