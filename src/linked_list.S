    #include "linked_list.h"
    #include "key_value_pair.h"

    .section .rodata
printf_el_fmt: .string "%s\n"

    .text
    .equ    NULL, 0

### --------------------------------------------------------
### creates empty linked list
    .global linked_list_new
    .type   linked_list_new, %function
linked_list_new:
    stp     x29, x30, [sp, #-16]!
    mov     x0, #LINKED_LIST_SIZE
    bl      malloc
    mov     x3, #0
    str     x3, [x0, #LINKED_LIST_HEAD]
    str     x3, [x0, #LINKED_LIST_TAIL]
    str     x3, [x0, #LINKED_LIST_COUNT]
    ldp     x29, x30, [sp], #16
    ret
    .size   linked_list_new, (. - linked_list_new)

### --------------------------------------------------------
### x0 holds linked_list
### x1 holds value
    .global linked_list_push
    .type   linked_list_push, %function
linked_list_push:
    stp     x29, x30, [sp, #-16]!
    stp     x19, x20, [sp, #-16]!

    mov     x19, x0                 // linked_list
    mov     x20, x1                 // value
    mov     x0, #NODE_SIZE          // allocate struct node
    bl      malloc
    str     x20, [x0, #NODE_VALUE]
    ldr     x2,  [x19, #LINKED_LIST_HEAD]
    cmp     x2, #NULL
    bne     list_head_ne_null
    str     x0, [x19, #LINKED_LIST_HEAD]
    b       list_head_ne_null_endif
list_head_ne_null:
    ldr     x4, [x19, #LINKED_LIST_TAIL]
    str     x0, [x4, #NODE_NEXT]
list_head_ne_null_endif:
    str     x0, [x19, #LINKED_LIST_TAIL]
    ldr     x5, [x19, #LINKED_LIST_COUNT]
    add     x5, x5, #1
    str     x5, [x19, #LINKED_LIST_COUNT]

    ldp     x19, x20, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    .size linked_list_push, (. - linked_list_push)

### ----------------------------------------------------------
### x0 holds linked_list
### x1 holds linked_list to merge to first list
    .global linked_list_merge
    .type   linked_list_merge, %function
linked_list_merge:
    stp     x19, x20, [sp, #-16]!
    stp     x29, x30, [sp, #-16]!
    mov     x19, x0
    ldr     x20, [x1, #LINKED_LIST_HEAD]        // current node
0:
    cmp     x20, #NULL
    beq     1f
    mov     x0, x19
    ldr     x1, [x20, #NODE_VALUE]
    bl      linked_list_push
    ldr     x20, [x20, #NODE_NEXT]
    b       0b
1:
    ldp     x29, x30, [sp], #16
    ldp     x19, x20, [sp], #16
    ret
    .size   linked_list_merge, (. - linked_list_merge)

### ----------------------------------------------------------
### x0 holds linked_list
### returns array converted from linked_list
    .global linked_list_to_array
    .type   linked_list_to_array, %function
linked_list_to_array:
    stp     x19, x20, [sp, #-16]!
    stp     x29, x30, [sp, #-16]!
    mov     x19, x0

    ldr     x20, [x19, #LINKED_LIST_COUNT]
    lsl     x0, x20, #3
    bl      malloc

    ldr     x1, [x19, #LINKED_LIST_HEAD]    // current node
    mov     x2, #0
0:
    cmp     x1, #0
    beq     1f
    ldr     x3, [x1, #NODE_VALUE]
    str     x3, [x0, x2, lsl #3]            // array[x2] = x3
    ldr     x1, [x1, #NODE_NEXT]
    add     x2, x2, #1
    b       0b
1:
    mov     x1, x20
    ldp     x29, x30, [sp], #16
    ldp     x19, x20, [sp], #16
    ret
    .size   linked_list_to_array, (. - linked_list_to_array)

### ----------------------------------------------------------
### x0 holds linked_list
### returns reduced key value pair
    .global linked_list_reduce
    .type   linked_list_reduce, %function
linked_list_reduce:
    stp     x29, x30, [sp, #-16]!
    mov     x2, x0
    ldr     x0, [x2, #LINKED_LIST_HEAD]
    ldr     x0, [x0, #NODE_VALUE]
    ldr     x0, [x0, #KEY_VALUE_PAIR_KEY]
    ldr     x1, [x2, #LINKED_LIST_COUNT]
    bl      key_value_pair_new
    ldp     x29, x30, [sp], #16
    ret
    .size   linked_list_reduce, (. - linked_list_reduce)

### ----------------------------------------------------------
### x0 holds linked_list
### x1 holds branch address
    .global linked_list_print
    .type   linked_list_print, %function
linked_list_print:
    stp     x19, x20, [sp, #-16]!
    stp     x29, x30, [sp, #-16]!
    mov     x20, x1
    ldr     x19, [x0, #LINKED_LIST_HEAD]        // current node
0:
    cmp     x19, #NULL
    beq     1f
    ldr     x0, [x19, #NODE_VALUE]
    blr     x20
    ldr     x19, [x19, #NODE_NEXT]
    b       0b
1:
    ldp     x29, x30, [sp], #16
    ldp     x19, x20, [sp], #16
    ret
    .size   linked_list_print, (. - linked_list_print)
