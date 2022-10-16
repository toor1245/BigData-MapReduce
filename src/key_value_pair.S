    #include "key_value_pair.h"

    .data

key_value_pair_fmt:
    .string "%s\t%d\n"

### --------------------------------------------------------
### x0 holds key
### x1 holds value
### returns allocated key-value struct
    .text
    .global key_value_pair_new
    .type   key_value_pair_new, %function
key_value_pair_new:
    stp     x29, x30, [sp, #-16]!
    stp     x19, x20, [sp, #-16]!
    mov     x19, x0
    mov     x20, x1
    mov     x0, #KEY_VALUE_PAIR_SIZE
    bl      malloc
    str     x19, [x0, #KEY_VALUE_PAIR_KEY]
    str     x20, [x0, #KEY_VALUE_PAIR_VALUE]
    ldp     x19, x20, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    .size key_value_pair_new, (. - key_value_pair_new)

### --------------------------------------------------------
### x0 form hash value for string
### returns allocated hashtable
    .global key_value_pair_free
    .type   key_value_pair_free, %function
key_value_pair_free:
    stp     x29, x30, [sp, #-16]!
    bl      free
    ldp     x29, x30, [sp], #16
    ret
    .size key_value_pair_free, (. - key_value_pair_free)

### --------------------------------------------------------
### x0 holds key_value_pair1 address
### x1 holds key_value_pair2 address
### compare keys
    .global key_value_pair_cmp
    .type   key_value_pair_cmp, %function
key_value_pair_cmp:
    stp     x29, x30, [sp, #-16]!
    ldr     x0, [x0, #KEY_VALUE_PAIR_KEY]
    ldr     x1, [x1, #KEY_VALUE_PAIR_KEY]
    bl      strcmp
    ldp     x29, x30, [sp], #16
    ret
    .size   key_value_pair_cmp, (. - key_value_pair_cmp)

### --------------------------------------------------------
### x0 holds key value pair address
### returns allocated hashtable
    .global key_value_pair_print
    .type   key_value_pair_print, %function
key_value_pair_print:
    stp     x29, x30, [sp, #-16]!
    stp     x19, x20, [sp, #-16]!
    mov     x19, x0
    ldr     x0, =key_value_pair_fmt
    ldr     x1, [x19, #KEY_VALUE_PAIR_KEY]
    ldr     x2, [x19, #KEY_VALUE_PAIR_VALUE]
    bl      printf
    ldp     x19, x20, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    .size   key_value_pair_print, (. - key_value_pair_print)
