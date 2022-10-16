    .text
### --------------------------------------------------------
### x0 holds array address
### x1 holds array count
### x2 holds compare address
### returns pointer of sorted array and count
    .global bubble_sort
    .type   bubble_sort, %function
bubble_sort:
    stp     x29, x30, [sp, #-16]!
    stp     x25, x26, [sp, #-16]!
    stp     x23, x24, [sp, #-16]!
    stp     x21, x22, [sp, #-16]!
    stp     x19, x20, [sp, #-16]!

    mov     x19, x0
    mov     x20, x1
    mov     x25, x2

    mov     x21, #0                  // counter i
0:
    cmp     x21, x20                 // i >= array count
    bge     4f

    add     x22, x21, #1             // counter j = i + 1
1:
    cmp     x22, x20                 // j >= array count
    bge     3f

    ldr     x23, [x19, x21, lsl #3]  // x23 = array[i]
    ldr     x24, [x19, x22, lsl #3]  // x24 = array[j]

    mov     x0, x23
    mov     x1, x24
    blr     x25

    cmp     x0, #0                   // array[i] <= array[j]
    ble     no_swap
    str     x24, [x19, x21, lsl #3]  // array[i] = array[j]
    str     x23, [x19, x22, lsl #3]  // array[j] = array[i]
no_swap:
    add     x22, x22, #1
    b       1b
3:
    add     x21, x21, #1
    b       0b
4:
    mov     x0, x19
    mov     x1, x20
    ldp     x19, x20, [sp], #16
    ldp     x21, x22, [sp], #16
    ldp     x23, x24, [sp], #16
    ldp     x25, x26, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    .size   bubble_sort, (. - bubble_sort)
