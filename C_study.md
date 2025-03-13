
**BASIC**

**install pkg-config on Debian**

```
sudo apt install pkg-config
pkg-config --version

```

**Get all**

```
find /usr/lib/x86_64-linux-gnu/pkgconfig /usr/lib/pkgconfig /usr/share/pkgconfig -name "*.pc"

```

**General Syntax**

```
pkg-config [options] <library_name>
```

**Check Library Paths**

```
ldconfig -p | grep <library_name>

```

**Get compiler flags (-I include paths)**

```
pkg-config --cflags --libs <library_name>

pkg-config --cflags --libs openssl

```

**Get linker flags (-L library paths and -l linking flags)**

```
pkg-config --libs openssl

```

**Get static linking flags (if available)**

```
pkg-config --static --libs openssl
```

**Check installed version of a library**

```
pkg-config --modversion openssl

```

**List all available pkg-config libraries**

```
pkg-config --list-all

```

**Check if a library is installed (no output = not found)**

pkg-config --exists openssl && echo "OpenSSL is installed"


**Get detailed OpenSSL info**

```
pkg-config --print-provides openssl

```

**Show installation prefix (base directory)**

```
pkg-config --variable=prefix openssl

```

**Show library directory**

```
pkg-config --variable=libdir openssl

```

**Show include directory**

```
pkg-config --variable=includedir openssl

```


If openssl.pc is missing

If OpenSSL is installed but pkg-config can't find it, 
manually set:

```
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH

pkg-config --cflags --libs openssl

```


Example openssl.pc File


```

prefix=/usr
exec_prefix=${prefix}
libdir=${exec_prefix}/lib/x86_64-linux-gnu
includedir=${prefix}/include

Name: OpenSSL
Description: Secure Sockets Layer and cryptography libraries and tools
Version: 3.0.15
Requires: libssl libcrypto


```



Where to Place It?

```
/usr/lib/x86_64-linux-gnu/pkgconfig/openssl.pc
or

/usr/local/lib/pkgconfig/openssl.pc

Updating pkg-config

```




export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH


```
pkg-config --cflags --libs openssl

```





**Find Library Files (.so)**

```
find /usr/lib /lib -name "lib<name>*.so"

```




To **view all warnings** during compilation in **GCC (GNU Compiler Collection)**, use the following flags:

### **1. Basic Warning Flags**
```sh
gcc -Wall program.c -o program
```
- `-Wall` → Enables **most** common warnings.

### **2. Enable Even More Warnings**
```sh
gcc -Wall -Wextra program.c -o program
```
- `-Wextra` → Enables **additional** warnings.

### **3. Show **All Possible** Warnings**
```sh
gcc -Wall -Wextra -Wpedantic program.c -o program
```
- `-Wpedantic` → Warns about **strict standard compliance issues**.

### **4. Treat Warnings as Errors (Optional)**
```sh
gcc -Wall -Wextra -Werror program.c -o program
```
- `-Werror` → Treats **warnings as errors** (stops compilation on warnings).

### **5. Maximum Warnings for Debugging**
```sh
gcc -Wall -Wextra -Wpedantic -Wconversion -Wshadow -Wstrict-overflow -Wfloat-equal -Wpointer-arith -Wcast-qual -Wformat=2 -Wuninitialized program.c -o program
```
This includes:
- **`-Wconversion`** → Warns about implicit type conversions.
- **`-Wshadow`** → Warns if a local variable **shadows** a global variable.
- **`-Wstrict-overflow`** → Detects possible overflow in optimizations.
- **`-Wfloat-equal`** → Warns about **floating-point comparisons**.
- **`-Wpointer-arith`** → Detects pointer arithmetic issues.
- **`-Wcast-qual`** → Warns about discarding `const` or `volatile` qualifiers.
- **`-Wformat=2`** → Detects **unsafe `printf` usage**.
- **`-Wuninitialized`** → Warns about **using variables before initialization**.

### **6. Using `-fanalyzer` for Deep Static Analysis**
```sh
gcc -Wall -Wextra -fanalyzer program.c -o program
```
- **`-fanalyzer`** → Runs a **static code analysis** to detect **potential runtime errors**.

---

### **Example Output:**
```sh
gcc -Wall -Wextra -Wpedantic myprogram.c -o myprogram
```
🚨 **Compiler Warnings Example:**
```
myprogram.c:10:5: warning: unused variable ‘x’ [-Wunused-variable]
    10 | int x;
       |     ^
```






**FORMAT SPECIFIERS**


`printf` statement syntax is:  

```c
printf("value is %d", some_integer);
```

Here’s a full list of commonly used format specifiers in `printf`:

| Specifier | Description |
|-----------|-------------|
| `%d` or `%i` | Integer (decimal) |
| `%u` | Unsigned integer |
| `%x` or `%X` | Hexadecimal integer (lower/uppercase) |
| `%o` | Octal integer |
| `%c` | Character |
| `%s` | String |
| `%f` | Floating-point (decimal notation) |
| `%e` or `%E` | Scientific notation (lower/uppercase) |
| `%g` or `%G` | Shortest representation of `%f` or `%e` |
| `%p` | Pointer address |
| `%n` | Stores the number of characters printed so far into a variable |
| `%%` | Prints a literal `%` sign |




### **Integer Types**
| Specifier | Description | Example |
|-----------|-------------|---------|
| `%d` or `%i` | Signed integer (decimal) | `printf("%d", -123);` → `-123` |
| `%u` | Unsigned integer (decimal) | `printf("%u", 123);` → `123` |
| `%x` | Unsigned hexadecimal (lowercase) | `printf("%x", 255);` → `ff` |
| `%X` | Unsigned hexadecimal (uppercase) | `printf("%X", 255);` → `FF` |
| `%o` | Unsigned octal | `printf("%o", 255);` → `377` |

### **Floating-Point Types**
| Specifier | Description | Example |
|-----------|-------------|---------|
| `%f` | Floating-point (decimal notation) | `printf("%f", 3.14);` → `3.140000` |
| `%.nf` | Floating-point with `n` decimal places | `printf("%.2f", 3.14159);` → `3.14` |
| `%e` or `%E` | Scientific notation (lower/uppercase) | `printf("%e", 3.14);` → `3.140000e+00` |
| `%g` or `%G` | Shortest representation of `%f` or `%e` | `printf("%g", 3.14);` → `3.14` |

### **Character & String Types**
| Specifier | Description | Example |
|-----------|-------------|---------|
| `%c` | Single character | `printf("%c", 'A');` → `A` |
| `%s` | String | `printf("%s", "Hello");` → `Hello` |

### **Pointer & Special Specifiers**
| Specifier | Description | Example |
|-----------|-------------|---------|
| `%p` | Pointer address | `printf("%p", ptr);` → `0x7ffeeffab1c0` |
| `%n` | Stores number of characters printed so far | `int count; printf("Hello%n", &count);` → `count = 5` |
| `%%` | Prints a `%` character | `printf("%%");` → `%` |

### **Modifiers for Size**
| Modifier | Use Case | Example |
|----------|---------|---------|
| `%ld`, `%li` | Long integer | `printf("%ld", 1234567890L);` |
| `%lld`, `%lli` | Long long integer | `printf("%lld", 123456789012345LL);` |
| `%lu` | Unsigned long | `printf("%lu", 1234567890UL);` |
| `%llu` | Unsigned long long | `printf("%llu", 123456789012345ULL);` |
| `%Lf` | Long double | `printf("%Lf", 3.14L);` |





## **6. Flags for Formatting**
You can add flags to control width, alignment, and padding.

| Flag | Description | Example |
|------|------------|---------|
| `-`  | Left-align | `printf("%-10d", 123);` → `123       ` |
| `+`  | Always show sign | `printf("%+d", 123);` → `+123` |
| `0`  | Zero padding | `printf("%05d", 42);` → `00042` |
| `#`  | Alternate format | `printf("%#x", 255);` → `0xff` |
| ` ` (space) | Puts a space before positive numbers | `printf("% d", 42);` → ` 42` |

---

## **7. Field Width & Precision**
| Format | Description | Example |
|--------|------------|---------|
| `%10d` | Minimum width of 10 | `printf("%10d", 123);` → `       123` |
| `%010d` | Zero-padded width of 10 | `printf("%010d", 123);` → `0000000123` |
| `%.2f` | Floating-point with 2 decimal places | `printf("%.2f", 3.14159);` → `3.14` |
| `%10.2f` | Width 10, 2 decimal places | `printf("%10.2f", 3.14159);` → `      3.14` |

---

## **8. Combining Flags & Width**
You can combine multiple formatting options.

```c
printf("%-+10.2f", 3.14159);
```
**Output:**
```
+3.14     
```
- `-` → Left-align
- `+` → Always show sign
- `10` → Minimum




**POINTER BASIC**


There is no difference between:  

```c
int *ptr;
int * ptr;
int* ptr;
```

All three declare `ptr` as a pointer to an `int`. The placement of `*` is just a matter of style and personal preference. However, some conventions exist:  

- `int *ptr;` → Common style, emphasizing that `ptr` is a pointer.  
- `int * ptr;` → Same as above, but with extra spacing.  
- `int* ptr;` → Some prefer this, thinking `int*` groups the type together, but it can be misleading when declaring multiple variables (e.g., `int* p1, p2;` makes `p1` a pointer and `p2` an `int`).  

Most programmers use `int *ptr;` for clarity.



**RECURSIVE FUNCTION**



```

int factorial(int a) {
    if (a == 0 || a == 1)  // Base case
        return 1;
    return a * factorial(a - 1);
}

```



**PREPROCESSOR DIRECTIVES**


Here’s a complete list of **C Preprocessor Directives** with explanations and examples:

---

### 1. **`#define` (Macro Definition)**  
Defines a macro (constant or function-like macro).  

```c
#include <stdio.h>
#define PI 3.14  // Defining a constant

int main() {
    printf("Value of PI: %.2f\n", PI);
    return 0;
}
```

---

### 2. **`#undef` (Undefine a Macro)**  
Removes a previously defined macro.  

```c
#include <stdio.h>
#define VALUE 100

#undef VALUE  // Now VALUE is undefined

int main() {
    // printf("%d", VALUE);  // This would cause an error since VALUE is undefined
    return 0;
}
```

---

### 3. **`#include` (File Inclusion)**  
Includes header files.  

```c
#include <stdio.h>  // Standard library
#include "myheader.h"  // User-defined header file
```

---

### 4. **`#if`, `#elif`, `#else`, `#endif` (Conditional Compilation)**  
Used to conditionally compile code based on a condition.  

```c
#include <stdio.h>
#define X 10

#if X > 5
    #define MESSAGE "X is greater than 5"
#elif X == 5
    #define MESSAGE "X is 5"
#else
    #define MESSAGE "X is less than 5"
#endif

int main() {
    printf("%s\n", MESSAGE);
    return 0;
}
```

---

### 5. **`#ifdef` (If Defined)**  
Checks if a macro is defined.  

```c
#include <stdio.h>
#define DEBUG  // Uncommenting this enables debugging

int main() {
#ifdef DEBUG
    printf("Debugging mode enabled\n");
#endif
    return 0;
}
```

---

### 6. **`#ifndef` (If Not Defined)**  
Checks if a macro is **not** defined.  

```c
#include <stdio.h>
#ifndef PI
    #define PI 3.14
#endif

int main() {
    printf("PI: %.2f\n", PI);
    return 0;
}
```

---

### 7. **`#pragma` (Compiler-Specific Directives)**  
Used for compiler-specific instructions.  

- **Disable warnings:**  
  ```c
  #pragma warning(disable : 4996)
  ```

- **Once header inclusion:**  
  ```c
  #pragma once  // Ensures this file is included only once
  ```

---

### 8. **`#error` (Stop Compilation with Error Message)**  
Stops compilation and shows an error.  

```c
#if __STDC__ != 1
    #error "This compiler does not support standard C"
#endif
```

---

### 9. **`#line` (Change Line Number for Debugging)**  
Changes the line number in error messages.  

```c
#include <stdio.h>
#line 100 "myfile.c"  // Changes the line number

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

---

### 10. **`#` (Stringizing Operator in Macros)**  
Converts an argument into a string.  

```c
#include <stdio.h>
#define STR(x) #x  // Converts argument to string

int main() {
    printf("%s\n", STR(Hello World!));
    return 0;
}
```

---

### 11. **`##` (Token-Pasting Operator in Macros)**  
Concatenates two tokens.  

```c
#include <stdio.h>
#define CONCAT(a, b) a##b

int main() {
    int xy = 10;
    printf("%d\n", CONCAT(x, y));  // Expands to xy
    return 0;
}
```

---




```
// if we define DEBUG_OUTPUT, the below debug code will be included when the
// source code is compiled

#define DEBUG_OUTPUT 0



  #ifdef DEBUG_OUTPUT
  int sum = 0;
  for (int i = 0; i < 10; i++)
    printf("a[%d] = %d : %d \n", i, a[i], sum);
  #endif


```




```

#define SOFTWARE_VERSION 10001

int main()
{

  #if SOFTWARE_VERSION == 10000
  printf("SOFTWARE_VERSION == 10000 \n");
  #endif

  #if SOFTWARE_VERSION == 10001
  printf("SOFTWARE_VERSION == 10001 \n");
  #endif

  #if SOFTWARE_VERSION == 10002
  printf("SOFTWARE_VERSION == 10002 \n");
  #endif

}

```



Yes, but using `#if SOFTWARE_VERSION == 10002` means that the preprocessor removes any code that doesn't match the defined `SOFTWARE_VERSION`. This approach is useful for conditional compilation but has limitations because it's resolved before compilation.  


### **When to Use `#if` vs. `if`**
- **`#if SOFTWARE_VERSION == X`** → Used for compile-time conditions (code is included/excluded before compilation).
- **`if (SOFTWARE_VERSION == X)`** → Used for runtime conditions (executes based on variable values).  





### **How to Use `#if` in C?**  

The `#if` directive is part of the C preprocessor and is used for **conditional compilation**. It allows or excludes parts of code at **compile time**, based on conditions.

---

### **1. Basic `#if` Example**  
Only one condition is checked. If `SOFTWARE_VERSION == 10001`, the code inside `#if` is compiled. Otherwise, it's ignored.

```c
#include <stdio.h>

#define SOFTWARE_VERSION 10001

int main() {
    #if SOFTWARE_VERSION == 10001
        printf("Version 10001\n");
    #endif

    return 0;
}
```
**Output:**  
```
Version 10001
```

---

### **2. Using `#elif` (Else If)**
Multiple conditions can be checked. Only the first matching condition is included.

```c
#include <stdio.h>

#define SOFTWARE_VERSION 10002

int main() {
    #if SOFTWARE_VERSION == 10000
        printf("Version 10000\n");
    #elif SOFTWARE_VERSION == 10001
        printf("Version 10001\n");
    #elif SOFTWARE_VERSION == 10002
        printf("Version 10002\n");
    #else
        printf("Unknown Version\n");
    #endif

    return 0;
}
```
**Output:**  
```
Version 10002
```
Only the matching `#elif` block gets compiled.

---

### **3. Using `#else` (Default Case)**
If no conditions match, the `#else` block runs.

```c
#include <stdio.h>

#define SOFTWARE_VERSION 9999  // Undefined version

int main() {
    #if SOFTWARE_VERSION == 10000
        printf("Version 10000\n");
    #elif SOFTWARE_VERSION == 10001
        printf("Version 10001\n");
    #else
        printf("Unknown Version\n");
    #endif

    return 0;
}
```
**Output:**  
```
Unknown Version
```

---

### **4. Using `#ifdef` and `#ifndef`**
These check if a macro is **defined** or **not defined**.

```c
#include <stdio.h>

#define DEBUG  // Define DEBUG mode

int main() {
    #ifdef DEBUG
        printf("Debug mode is ON\n");
    #endif

    #ifndef RELEASE
        printf("Release mode is OFF\n");
    #endif

    return 0;
}
```
**Output:**  
```
Debug mode is ON
Release mode is OFF
```
- `#ifdef DEBUG` → Runs because `DEBUG` is defined.
- `#ifndef RELEASE` → Runs because `RELEASE` is **not** defined.

---

### **5. Using `#if` with Logical Operators (`&&`, `||`)**
You can use `&&` (AND) and `||` (OR) to check multiple conditions.

```c
#include <stdio.h>

#define VERSION 10001
#define FEATURE_ENABLED 1

int main() {
    #if VERSION == 10001 && FEATURE_ENABLED
        printf("Feature is enabled in version 10001\n");
    #endif

    return 0;
}
```
**Output:**  
```
Feature is enabled in version 10001
```

---

### **6. Using `#define` for Debugging**
Enable debugging messages only if `DEBUG` is defined.

```c
#include <stdio.h>

// Uncomment to enable debugging
#define DEBUG

int main() {
    #ifdef DEBUG
        printf("Debugging enabled\n");
    #endif
    return 0;
}
```
**Output:**  
```
Debugging enabled
```
If `#define DEBUG` is **removed**, the output will be empty.

---

### **Summary Table: When to Use Each Method**
| Directive  | Purpose |
|------------|---------|
| `#if` | Compiles code only if condition is `true`. |
| `#elif` | Adds more conditions after `#if`. |
| `#else` | Provides a default case if no conditions match. |
| `#ifdef` | Checks if a macro is defined. |
| `#ifndef` | Checks if a macro is **not** defined. |

---

### **When to Use `#if` vs. `if`**
| Feature  | `#if` | `if` |
|----------|------|-----|
| **Checked at** | Compile-time | Runtime |
| **Can check macros?** | ✅ Yes | ❌ No |
| **Can check variables?** | ❌ No | ✅ Yes |
| **Where can it be used?** | Anywhere in the file | Inside functions |

---

### **Final Thought**
- Use `#if` **when different code should be included/excluded at compile time**.
- Use `if` **when different code should execute based on runtime conditions**.

