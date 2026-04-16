.section .data
filename: .string "input.txt"
yes_msg: .string "Yes\n"
no_msg:  .string "No\n"

.section .bss # same init of size
.lcomm ptrFront, 1
.lcomm ptrBack, 1

.section .text
.globl main

main:
    # open file
    li a7, 56
    li a0, -100 # file is in the current working directory
    la a1, filename
    # read mode v
    li a2, 0 
    li a3, 0 
    ecall
    mv s0, a0 # save somewhere 
    li a7, 62
    mv a0, s0
    li a1, 0
    li a2, 2
    ecall
    mv s1, a0 # s1 = size
    li s2, 0 # left = 0
    addi s3, s1, -1 # right = size - 1

loop:
    bge s2, s3, is_palindrome # if crossed -> done
    # read left char
    li a7, 62
    mv a0, s0
    mv a1, s2
    li a2, 0
    ecall
    li a7, 63
    mv a0, s0
    la a1, ptrFront
    li a2, 1
    ecall
    # read right char
    li a7, 62
    mv a0, s0
    mv a1, s3
    li a2, 0
    ecall
    li a7, 63
    mv a0, s0
    la a1, ptrBack
    li a2, 1
    ecall
    # compare ptrFront and ptrBack
    lb t0, ptrFront
    lb t1, ptrBack
    bne t0, t1, not_palindrome

    addi s2, s2, 1 # l++
    addi s3, s3, -1 # r--
    j loop

is_palindrome:
    li a7, 64
    li a0, 1
    la a1, yes_msg
    li a2, 4
    ecall
    j exit

not_palindrome:
    li a7, 64
    li a0, 1
    la a1, no_msg
    li a2, 3
    ecall

exit:
    li a7, 93
    li a0, 0
    ecall