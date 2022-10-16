    #include "linked_list.h"

    .data
split_fmt:
    .string "%s\n"
new_ln:
    .string "\r\n"

    .text
### --------------------------------------------------------
### x0 holds string of file
### x1 holds linked_list
### returns list of lines
    .global split
    .type   split, %function
split:
    stp     x29, x30, [sp, #-16]!
    stp     x19, x20, [sp, #-16]!

    mov     x20, x1

    // split by line
    adr     x1, new_ln
    bl      strtok
    mov     x19, x0

1:
    cmp     x19, #0 // split result == NULL
    beq     0f

    // push strtok result to linked_list
    mov     x0, x20
    mov     x1, x19
    bl      linked_list_push

    // split by line
    mov     x0, #0
    adr     x1, new_ln
    bl      strtok
    mov     x19, x0
    b       1b
0:
    ldp     x19, x20, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    .size   split, (. - split)

### --------------------------------------------------------
### x0 holds splitted string address
### returns allocated hashtable
    .global split_print
    .type   split_print, %function
split_print:
    stp     x29, x30, [sp, #-16]!
    mov     x1, x0
    adr     x0, split_fmt
    bl      printf
    ldp     x29, x30, [sp], #16
    ret
    .size  split_print, (. - split_print)