    #include "key_value_pair.h"

    .section .rodata
whitespace:
    .string " "

    .text

### --------------------------------------------------------
### x0 - holds address string line
    .global map
    .type   map, %function
map:
    stp     x29, x30, [sp, #-16]!
    stp     x21, x22, [sp, #-16]!
    stp     x19, x20, [sp, #-16]!

    mov     x19, x0                     // addres string line
    ldr     x20, =whitespace             // addres whitespace

    bl      linked_list_new
    mov     x21, x0

    // split by whitespace
    mov     x0, x19
    mov     x1, x20
    bl      strtok
    mov     x19, x0

0:
    cmp     x19, #0
    beq     1f

    // create key_value_pair
    mov     x0, x19
    mov     x1, #1
    bl      key_value_pair_new

    // push key_value_pair to list
    mov     x1, x0
    mov     x0, x21
    bl      linked_list_push

    // split by whitespace
    mov     x0, #0
    mov     x1, x20
    bl      strtok
    mov     x19, x0

    b       0b
1:
    mov     x0, x21
    ldp     x19, x20, [sp], #16
    ldp     x21, x22, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    .size   map, (. - map)