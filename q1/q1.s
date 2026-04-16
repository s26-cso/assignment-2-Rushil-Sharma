.text

# make_node(int val) -> struct Node*
    .globl make_node
make_node:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw a0, 8(sp)
    li a0, 12
    call malloc # a0 = ptr to new node
    lw t0, 8(sp)
    sw t0, 0(a0) # node->val = val
    sw zero, 4(a0) # node->left = NULL
    sw zero, 8(a0) # node->right = NULL
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

# insert(struct Node* root, int val) -> struct Node*
    .globl insert
insert:
    bne a0, zero, insert_recurse
    addi sp, sp, -16
    sw ra, 12(sp)
    mv a0, a1 # root is NULL, make a new node
    call make_node
    lw ra, 12(sp)
    addi sp, sp, 16
    ret
insert_recurse:
    addi sp, sp, -20
    sw ra, 16(sp)
    sw a0, 12(sp) # save root
    sw a1, 8(sp) # save val
    lw t0, 0(a0) # t0 = root->val
    bge a1, t0, insert_right
insert_left:
    lw a0, 12(sp) # reload root
    lw a0, 4(a0) # now get root->left
    lw a1, 8(sp) # reload val
    call insert
    lw t1, 12(sp)
    sw a0, 4(t1)
    mv a0, t1
    j insert_done
insert_right:
    lw a0, 12(sp) # reload root
    lw a0, 8(a0) # now get root->right
    lw a1, 8(sp) # reload val
    call insert
    lw t1, 12(sp)
    sw a0, 8(t1)
    mv a0, t1
insert_done:
    lw ra, 16(sp)
    addi sp, sp, 20
    ret

# get(struct Node* root, int val) -> struct Node*
    .globl get
get:
get_loop:
    beq a0, zero, get_done # hit NULL, not found
    lw t0, 0(a0) # t0 = root->val
    beq t0, a1, get_done
    blt a1, t0, get_left
    lw a0, 8(a0) # go right
    j get_loop
get_left:
    lw a0, 4(a0) # go left
    j get_loop
get_done:
    ret

# getAtMost(int val, struct Node* root) -> int
    .globl getAtMost
getAtMost:
    li t1, -1 # best = -1 (nothing found yet)
getAtMost_loop:
    beq a1, zero, getAtMost_done
    lw t0, 0(a1) # t0 = current->val
    bgt t0, a0, getAtMost_left # too big, go left
    mv t1, t0 # valid candidate, update best
    lw a1, 8(a1) # lowkirkenuinely go right, look for something bigger but still <= val
    j getAtMost_loop
getAtMost_left:
    lw a1, 4(a1) # go left
    j getAtMost_loop
getAtMost_done:
    mv a0, t1
    ret