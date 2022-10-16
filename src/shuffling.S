    #include "key_value_pair.h"

    .data
empty:
    .string " "

    .text

### ----------------------------------------------------------
### x0 holds address of sorted array
### x1 holds array size
### returns grouping lists
    .global shuffle
    .type   shuffle, %function
shuffle:
    stp     x29, x30, [sp, #-16]!
    stp     x25, x26, [sp, #-16]!
    stp     x23, x24, [sp, #-16]!
    stp     x21, x22, [sp, #-16]!
    stp     x19, x20, [sp, #-16]!

    mov     x19, x0                 // array
    mov     x20, x1                 // size
    mov     x21, #0                 // counter

    ldr     x0, =empty
    mov     x1, #1
    bl      key_value_pair_new
    mov     x22, x0                 // previous key

    bl      linked_list_new         // linked_list
    mov     x25, x0
0:
    cmp     x21, x20
    bge     1f

    ldr     x24, [x19, x21, lsl #3]             // current key_value_pair

    mov     x0, x24
    mov     x1, x22
    bl      key_value_pair_cmp

    // current_key == previous_key
    cmp     x0, #0
    beq     2f

    // create new node list in linked_list
    bl      linked_list_new
    mov     x23, x0

    // push node list to linked_list
    mov     x0, x25
    mov     x1, x23
    bl      linked_list_push
2:
    mov     x0, x23
    mov     x1, x24
    bl      linked_list_push

    mov     x22, x24
    add     x21, x21, #1
    b       0b
1:
    mov     x0, x25
    ldp     x19, x20, [sp], #16
    ldp     x21, x22, [sp], #16
    ldp     x23, x24, [sp], #16
    ldp     x25, x26, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    .size   shuffle, (. - shuffle)
