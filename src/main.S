    #include "linked_list.h"
    #include "key_value_pair.h"

    .data
nl:
    .string "\n"

el_fmt:
    .string "%s, %d\n"

split_fmt:
    .string "[Splitting]:\n"

map_fmt:
    .string "\n[Mapping]:"

shuffle_sort_fmt:
    .string "\n[Shuffling and Sorting]:\n"

reduce_fmt:
    .string "\n[Reducing]:\n"

file1:
    .string "number aaa arg dsf\r\ntest hello world\r\n"
file2:
    .string "wef eewf aaa\r\ntest hello aaa\r\n"

files:
    .quad   file1, file2
    .equ    FILES_COUNT, (. - files) / 8

    .text
    .global main
    .type   main, %function
main:
    stp     x29, x30, [sp, #-16]!
    stp     x23, x24, [sp, #-16]!
    stp     x21, x22, [sp, #-16]!
    stp     x19, x20, [sp, #-16]!

    // allocate memory for linked_list struct
    bl      linked_list_new
    mov     x23, x0

    adr     x19, files
    mov     x24, #0             // counter

0:
    cmp     x24, FILES_COUNT
    bge     1f

    // splitting
    ldr     x0, [x19, x24, lsl #3]
    mov     x1, x23
    bl      split
    add     x24, x24, #1
    b       0b
1:
    // print lines
    adr     x0, split_fmt
    bl      printf

    mov     x0, x23
    adr     x1, split_print
    bl      linked_list_print

    bl      linked_list_new
    mov     x20, x0

    adr     x0, map_fmt
    bl      printf

    ldr     x22, [x23, #LINKED_LIST_HEAD]
0:
    cmp     x22, #0
    beq     1f
    ldr     x0, [x22, #NODE_VALUE]
    bl      map
    mov     x19, x0

    mov     x0, x20
    mov     x1, x19
    bl      linked_list_merge

    ldr     x0, =nl
    bl      printf

    mov     x0, x19
    ldr     x1, =key_value_pair_print
    bl      linked_list_print

    ldr     x22, [x22, #NODE_NEXT]
    b       0b
1:
    mov     x0, x20
    mov     x1, #0
    bl      linked_list_to_array
    ldr     x2, =key_value_pair_cmp

    // sorting and shuffling
    bl      bubble_sort
    mov     x19, x0
    mov     x20, x1

    adr     x0, shuffle_sort_fmt
    bl      printf

    mov     x0, x19
    mov     x1, x20
    bl      show_array

    mov     x0, x19
    mov     x1, x20
    bl      shuffle
    mov     x19, x0

    // reducing
    adr     x0, reduce_fmt
    bl      printf

    mov     x0, x19
    bl      reduce
    bl      show_array

    mov     w0, #0
    ldp     x19, x20, [sp], #16
    ldp     x21, x22, [sp], #16
    ldp     x23, x24, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    .size   main, (. - main)

### ----------------------------------------------------------
### x0 holds array address
### x1 holds array size
### helper subroutine which uses for debugging
    .type   show_array, %function
show_array:
    stp     x29, x30, [sp, #-16]!
    stp     x21, x22, [sp, #-16]!
    stp     x19, x20, [sp, #-16]!
    mov     x19, x0
    mov     x20, x1
    mov     x21, #0
0:
    cmp     x21, x20                // i >= array_size
    bge     1f
    adr     x0, el_fmt
    ldr     x0, [x19, x21, lsl #3]
    bl      key_value_pair_print
    add     x21, x21, #1
    b       0b
1:
    ldp     x19, x20, [sp], #16
    ldp     x21, x22, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
    .size   show_array, (. - show_array)
