


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




---

## **1. Integer Format Specifiers**
| Specifier  | Description                          | Example Output |
|------------|--------------------------------------|---------------|
| `%d` or `%i` | Signed integer (decimal) | `printf("%d", -123);` → `-123` |
| `%u` | Unsigned integer (decimal) | `printf("%u", 123);` → `123` |
| `%o` | Unsigned octal | `printf("%o", 123);` → `173` |
| `%x` | Unsigned hexadecimal (lowercase) | `printf("%x", 255);` → `ff` |
| `%X` | Unsigned hexadecimal (uppercase) | `printf("%X", 255);` → `FF` |

---

## **2. Floating-Point Format Specifiers**
| Specifier  | Description                          | Example Output |
|------------|--------------------------------------|---------------|
| `%f` | Floating-point (decimal notation) | `printf("%f", 3.14159);` → `3.141590` |
| `%e` or `%E` | Scientific notation | `printf("%e", 3.14159);` → `3.141590e+00` |
| `%g` or `%G` | Uses `%f` or `%e`, whichever is shorter | `printf("%g", 3.14159);` → `3.14159` |
| `%a` or `%A` | Hexadecimal floating-point | `printf("%a", 3.14);` → `0x1.91eb86p+1` |

---

## **3. Character & String Format Specifiers**
| Specifier  | Description                          | Example Output |
|------------|--------------------------------------|---------------|
| `%c` | Single character | `printf("%c", 'A');` → `A` |
| `%s` | String | `printf("%s", "Hello");` → `Hello` |

---

## **4. Pointer & Special Format Specifiers**
| Specifier  | Description                          | Example Output |
|------------|--------------------------------------|---------------|
| `%p` | Pointer address | `printf("%p", ptr);` → `0x7ffeeffab1c0` |
| `%n` | Stores the number of characters printed so far | `int count; printf("Hello%n", &count);` (stores `5` in `count`) |
| `%%` | Prints a literal `%` sign | `printf("%%");` → `%` |

---

## **5. Length Modifiers**
You can combine length modifiers with format specifiers for different data types.

| Modifier | Type | Example |
|----------|------|---------|
| `h` | Short integer | `%hd`, `%hu` (short int) |
| `hh` | Signed char (tiny integer) | `%hhd`, `%hhu` |
| `l` | Long integer | `%ld`, `%lu` |
| `ll` | Long long integer | `%lld`, `%llu` |
| `L` | Long double | `%Lf` |

### **Example Usage:**
```c
short s = 10;
long l = 1234567890;
printf("%hd %ld", s, l);
```

---

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









int factorial(int a) {
    if (a == 0 || a == 1)  // Base case
        return 1;
    return a * factorial(a - 1);
}
