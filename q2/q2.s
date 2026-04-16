.section .data
input_fmt: .string "%d"
output_fmt: .string "%d "
output_fmt_new: .string "%d\n"

.section .bss # block starting symbol helps in initialisation
# ASSUMPTION : max value of n will be 1000 (int = 4)
.lcomm arr, 4000
.lcomm result, 4000
.lcomm stack, 4000

.section .text
.globl main # local->global

main: # like int main
    mv s0, a0 # s0 = argc
    mv s1, a1 # s1 = argv
    addi s0, s0, -1
    # read array
    li t0, 0
read_loop:
    bge t0, s0, process # end cond
    # get argv[i+1]
    addi t1, t0, 1
    slli t1, t1, 3
    add t1, s1, t1
    ld a0, 0(t1) # load string pointer
    # calling atoi to convert arg to int
    addi sp, sp, -16
    sd t0, 0(sp)
    sd ra, 8(sp)
    call atoi
    ld t0, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16
    la t1, arr
    slli t2, t0, 2
    add t3, t1, t2 # t3 = t0*4 + &arr = &arr[i]
    sw a0, 0(t3)
    addi t0, t0, 1
    j read_loop

process:
    li t0, -1 # if empty we need to store -1 (stack top, -1 = empty)
    li t1, 0

outer_loop:
    bge t1, s0, drain
    la t2, arr
    slli t3, t1, 2
    add t4, t2, t3 # t4 = &arr[i]
    lw t5, 0(t4)   # t5 = arr[i]

inner_loop:
    blt t0, zero, push 
    la t6, stack
    slli t2, t0, 2  
    add t3, t6, t2  
    lw t4, 0(t3) # t4 = stack.top() (this is index)
    la t2, arr
    slli t3, t4, 2
    add t3, t2, t3
    lw t2, 0(t3) # t2 = arr[stack.top()]
    blt t2, t5, pop_stack
    j push # arr[top] >= arr[i], stop popping, just push

pop_stack:
    # arr[top] < arr[i] so next greater for stack.top() is arr[i]
    la t3, result
    slli t6, t4, 2
    add t6, t3, t6
    sw t1, 0(t6)
    addi t0, t0, -1 # pop
    j inner_loop

push:
    addi t0, t0, 1
    la t6, stack
    slli t4, t0, 2 
    add t4, t6, t4 
    sw t1, 0(t4) # stack.top() = i
    addi t1, t1, 1
    j outer_loop

drain:
    blt t0, zero, print
    la t6, stack
    slli t2, t0, 2
    add t3, t6, t2
    lw t4, 0(t3)   # t4 = stack.top() (index)
    la t3, result
    slli t2, t4, 2
    add t2, t3, t2
    li t5, -1
    sw t5, 0(t2)   # result[index] = -1
    addi t0, t0, -1 # pop
    j drain

print:
    li t0, 0

print_loop:
    bge t0, s0, exit # from 0->n-1
    la t1, result
    slli t2, t0, 2
    add t3, t1, t2
    lw a1, 0(t3)   # a1 = result[i]
    # if t0 == s0-1 output_fmt_new
    addi s0, s0, -1
    beq t0, s0, last
    addi s0, s0, 1
    bne t0, s0, not_last
last :
    la a0, output_fmt_new
    addi sp, sp, -16
    sd t0, 0(sp)
    sd ra, 8(sp)
    call printf
    ld t0, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16
    addi t0, t0, 1
    j print_loop
not_last:
    la a0, output_fmt
    addi sp, sp, -16
    sd t0, 0(sp)
    sd ra, 8(sp)
    call printf
    ld t0, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16
    addi t0, t0, 1
    j print_loop

done:
    li a0, 0
    call exit