#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[6];
    int num1, num2;

    while (scanf("%5s %d %d", op, &num1, &num2) == 3) {
        char libname[24];
        sprintf(libname, "./lib%s.so", op);
        void *handle = dlopen(libname, RTLD_LAZY);
        if (handle==NULL) {
            fprintf(stderr, "Error loading %s: %s\n", libname, dlerror());
            continue;
        }
        dlerror();
        int (*func)(int, int);
        *(void **)(&func) = dlsym(handle, op);

        char *error = dlerror();
        if (error != NULL) {
            fprintf(stderr, "Error finding symbol %s: %s\n", op, error);
            dlclose(handle);
            continue;
        }

        int result = func(num1, num2);
        printf("%d\n", result);

        dlclose(handle);
    }

    return 0;
}