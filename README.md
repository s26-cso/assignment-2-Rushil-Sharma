# CSO Assignment-2
    RUSHIL SHARMA 
    2025114009
## Q1

I implemented a binary search tree in RISC-V assembly with four functions :- make_node, insert, get, and getAtMost as asked in the question.

make_node just mallocs 12 bytes (3 ints worth:- val, left, right) and stores the val, and sets both pointers to NULL.

insert is done recursively, it finds a place where root is null and then calls make_node and returns. Otherwise it compares value with lefe and right child and goes to that node/ branch respectively looking at values. Then it rewrites the child pointer while backtracking. Base case is handled ie when root == NULL.

getAtMost is an iterative function. It has a register intialized to -1. Whenever the node has a value bigger than its value it updates to that and goes to the node's child which is smaller than the node value. If both of the node's children are smaller it goes to the bigger one until it reaches node itself.

## Q2
All of the logic was given in the question itself, the only thing I did differently is that instead of initiallizing the array with -1, I made the result array -1 only if the stack is empty at time of updating result[i] value.

I assumed that the length of the input array will be less than 1000.
## Q3
### A
First I did
> strings ./target_Rushil-Sharma > output.txt

and in that file I found the line in which the password checking takes place
. From there, I saw that the password was
__Jz9PUFCdRfysasNydiOTAWhnlAyWy9U4TehwpyM9HZM=__

And then I put the password in payload.txt. Now the command 
> ./target_Rushil-Sharma < payload.txt

Gives the output of You have passed!.
### B

Firstly I tried the same method as before by echoing the answer that I got using strings but that didnt work. So, what I did was I did object dump and to find the .pass label. 

COMMAND
> riscv64-linux-gnu-objdump -d ./target_Rushil-Sharma > dump.txt

This allowed me to see the assembly code of this file. Now I could see that the starting adrress of .pass is at __0x104e8__

Also as you we see the main function allocates 144 bytes to read the password. To reach the ra, we need to add 8 to 144 = 152. Then in <Q
(little endian format) we write our return adress to the pass return adress.

Then on running this 

> ./target_Rushil-Sharma < payload

we get You have passed! in the stdout
## Q4

The implementation uses dlopen / dlsym / dlclose from <dlfcn.h>

Read each line with scanf("%5s %d %d", op, &num1, &num2)

The %5s width limit matches the guarantee that operation names are at most 5 characters.
Then I construct the library path as ./lib<op>.so using sprintf.
After that I call dlopen with RTLD_LAZY to load the library.
Then I use dlsym to look up the function named op inside the loaded library.
After that I call the function with the two operands and print the result.
I then call dlclose immediately to unload the library before the next iteration this is what keeps memory usage within bounds. Also it is a safe practice.

So that my code doesnt fail in cases of wrong lib spelling, I print an error to the stderr and continue with the loop.

## Q5
Maintained a PtrFront and PtrBack. Set their initial values to 0 and n-1. 

Then while traversing, I check the condition, if equal then continue else break and print No. And if they crossed each other, then I print Yes.