    #include "hashtable.h"

    .section .rodata
null_term:
    .byte '\0'

    .text

### --------------------------------------------------------
### x0 form hash value for string
### returns allocated hashtable
    .global hashtable_new
    .type   hashtable_new, %function
hashtable_new:
    stp     x29, x30, [sp, #-16]!
    mov     x0, #(HASHTABLE_SIZE * NLIST_SIZE)
    bl      malloc
    mov     x1, #0              // counter
0:
    // counter >= HASHTABLE_SIZE
    cmp     x1, (HASHTABLE_SIZE * NLIST_SIZE)
    bge     1f
    ldr     x2, [x0, x1]
    mov     x3, #0
    str     x3, [x2, #NLIST_NEXT]
    str     x3, [x2, #NLIST_NAME]
    str     x3, [x2, #NLIST_DEFN]
    add     x1, x1, #NLIST_SIZE
    b       0b
1:
    ldp     x29, x30, [sp], #16
    ret
    .size   hashtable_new, (. - hashtable_new)

### --------------------------------------------------------
### x0 holds address of hashtable
### returns allocated hashtable
    .global hashtable_free
    .type   hashtable_free, %function
hashtable_free:
    stp     x29, x30, [sp, #-16]!
    bl      free
    ldp     x29, x30, [sp], #16
    ret
    .size   hashtable_free, (. - hashtable_free)


### --------------------------------------------------------
### x0 holds hashtable pointer
### x1 holds char pointer to find string in hashtable
### returns nlist element of hashtable
    .global hashtable_lookup
    .type   hashtable_lookup, %function
hashtable_lookup:
    stp     x19, x20, [sp, #-16]!
    stp     x21, x22, [sp, #-16]!
    stp     x29, x30, [sp, #-16]!

    mov     x19, x0                 // hastable_t* hashtable
    mov     x20, x1                 // char* str

    // get hash of string
    mov     x0, x20
    bl      hashtable_hash
    mov     x21, x0                 // x21 - hash

    // get nlist element by hash
    mov     x1, x0
    mov     x0, x19
    bl      hashtable_get
    mov     x22, x0                 // x22 - nlist element
0:
    cmp     x22, #0                // hastable[hash] == NULL
    beq     1f
    mov     x0, x20
    ldr     x1, [x22, #NLIST_NAME]
    bl      strcmp
    cmp     x0, #0
    beq     2f
    ldr     x22, [x22, #NLIST_NEXT]
    b       0b
1:
    mov     x0, #0
    b       return
2:
    mov     x0, x22
return:
    ldp     x29, x30, [sp], #16
    ldp     x21, x22, [sp], #16
    ldp     x19, x20, [sp], #16
    ret
    .size   hashtable_lookup, (. - hashtable_lookup)

### --------------------------------------------------------
### x0 form hash value for string
### returns hash of string
    .type   hashtable_push, %function
hashtable_push:
    stp     x29, x30, [sp, #-16]!


    ldp     x29, x30, [sp], #16
    ret
    .size   hashtable_push, (. - hashtable_push)

### --------------------------------------------------------
### x0 form hash value for string
### returns hash of string
    .type   hashtable_hash, %function
hashtable_hash:
    stp     x29, x30, [sp, #-16]!
    mov     x5, #0                  // counter
    mov     x1, #0                  // hashval
    adrp    x3, null_term
    ldrb    w3, [x3]
0:
    ldrb    w2, [x0, x5]            // load next byte of string
    cmp     w2, w3                  // char == '\0'
    beq     1f
    mov     x6, #31
    madd    w1, w1, w6, w2          // ch + 31 * hashval;
    add     x5, x5, #1
    b       0b
1:
    mov     x5, #HASHTABLE_SIZE
    udiv    x2, x1, x5              // x2 = hashval / HASHTABLE_SIZE
    msub    x3, x2, x5, x1          // x3 = x2 * HASHTABLE_SIZE - hashval
    // hashval % HASHTABLE_SIZE: x5 = quotient, x1 = remainder
    mov     x0, x1
    ldp     x29, x30, [sp], #16
    ret
    .size   hashtable_hash, (. - hashtable_hash)

### --------------------------------------------------------
### x0 holds hashtable pointer
### x1 holds index to get value of hashtable
### returns nlist element of hashtable
    .type   hashtable_get, %function
hashtable_get:
    stp     x29, x30, [sp, #-16]!
    mov     x2, #NLIST_SIZE
    mul     x1, x1, x2              // index = hash * NLIST_SIZE
    ldr     x0, [x0, x1]            // hashtable[index]
    ldp     x29, x30, [sp], #16
    ret
    .size   hashtable_get, (. - hashtable_get)

### --------------------------------------------------------
### x0 holds hashtable pointer
### x1 holds index to get value of hashtable
### x2 holds nlist address to assign
### sets value to nlist* by index
    .type   hashtable_set, %function
hashtable_set:
    stp     x29, x30, [sp, #-16]!
    mov     x3, #NLIST_SIZE
    mul     x1, x1, x3              // index = hash * NLIST_SIZE
    str     x2, [x0, x1]            // hashtable[index]
    ldp     x29, x30, [sp], #16
    ret
    .size   hashtable_set, (. - hashtable_set)

### --------------------------------------------------------
### x0 holds string address
### returns duplicate of string
    .type   hashtable_strdup, %function
hashtable_strdup:
    stp     x19, x20, [sp, #-16]!
    stp     x29, x30, [sp, #-16]!
    mov     x19, x0

    bl      strlen
    add     x0, x0, #1
    bl      malloc
    mov     x20, x0

    cmp     x20, #0
    beq     0f
    mov     x1, x19
    bl      strcpy
0:
    mov     x0, x20
    ldp     x29, x30, [sp], #16
    ldp     x19, x20, [sp], #16
    ret
    .size   hashtable_strdup, (. - hashtable_strdup)
