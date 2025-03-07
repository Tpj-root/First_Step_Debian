



pkg-config --cflags xinerama
pkg-config --libs xinerama




### **Understanding `pkg-config`**
`pkg-config` is a command-line tool used to retrieve information about installed libraries. It helps in compiling and linking programs by providing necessary **CFLAGS** (compiler flags) and **LDFLAGS** (linker flags).

---

### **Basic Usage of `pkg-config`**
1. **Get Compiler Flags (`--cflags`)**  
   Retrieves **include paths** and **compiler options** required for a library.
   ```bash
   pkg-config --cflags glib-2.0
   ```
   Example output:
   ```
   -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include
   ```
   **How to Use in Compilation:**
   ```bash
   gcc myprogram.c $(pkg-config --cflags glib-2.0) -o myprogram
   ```

2. **Get Linker Flags (`--libs`)**  
   Retrieves **library paths** and **linker options** required for a library.
   ```bash
   pkg-config --libs glib-2.0
   ```
   Example output:
   ```
   -lglib-2.0
   ```
   **How to Use in Compilation:**
   ```bash
   gcc myprogram.c $(pkg-config --cflags glib-2.0) $(pkg-config --libs glib-2.0) -o myprogram
   ```

3. **Get Both (`--cflags --libs`)**  
   ```bash
   pkg-config --cflags --libs glib-2.0
   ```
   Example output:
   ```
   -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -lglib-2.0
   ```
   **Usage:**
   ```bash
   gcc myprogram.c $(pkg-config --cflags --libs glib-2.0) -o myprogram
   ```

---

### **Advanced Usage**
- **Check Installed Version**  
  ```bash
  pkg-config --modversion glib-2.0
  ```
  Example output:
  ```
  2.74.6
  ```

- **List All Available Packages**  
  ```bash
  pkg-config --list-all
  ```

- **Check if a Package is Installed**  
  ```bash
  pkg-config --exists glib-2.0 && echo "GLib is installed" || echo "GLib is missing"
  ```

- **Debug Package Information**  
  ```bash
  pkg-config --debug glib-2.0
  ```

---

### **Example with `rados` (Ceph)**
```bash
gcc myprogram.c $(pkg-config --cflags --libs rados) -o myprogram
```






### **`pkg-config` with `Make` vs. `CMake`**
Both **Make** and **CMake** can use `pkg-config` to manage dependencies, but **CMake** has built-in package management (`find_package`). Here's how `pkg-config` integrates with both.

---

## **1. Using `pkg-config` with `Make`**
`pkg-config` is commonly used in `Makefile` to get compiler and linker flags dynamically.

### **Example `Makefile`**
```make
CC = gcc
CFLAGS = -Wall -Wextra $(shell pkg-config --cflags glib-2.0)
LDFLAGS = $(shell pkg-config --libs glib-2.0)

all: myprogram

myprogram: myprogram.c
	$(CC) $(CFLAGS) myprogram.c -o myprogram $(LDFLAGS)

clean:
	rm -f myprogram
```
- `$(shell pkg-config --cflags glib-2.0)`: Adds **include paths**.
- `$(shell pkg-config --libs glib-2.0)`: Adds **library linking**.

✅ **Best for:** Simple projects with manually written `Makefile`.

---

## **2. Using `pkg-config` with `CMake`**
CMake has `find_package()`, but you can use `pkg-config` if a module isn’t available.

### **Method 1: Using `PkgConfig` Module**
```cmake
cmake_minimum_required(VERSION 3.5)
project(MyProgram C)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GLIB REQUIRED glib-2.0)

add_executable(myprogram myprogram.c)
target_include_directories(myprogram PRIVATE ${GLIB_INCLUDE_DIRS})
target_link_libraries(myprogram PRIVATE ${GLIB_LIBRARIES})
target_compile_options(myprogram PRIVATE ${GLIB_CFLAGS_OTHER})
```
- `find_package(PkgConfig REQUIRED)`: Enables `pkg-config` in CMake.
- `pkg_check_modules(GLIB REQUIRED glib-2.0)`: Fetches GLib package details.

### **Method 2: Manually Using `pkg-config`**
```cmake
cmake_minimum_required(VERSION 3.5)
project(MyProgram C)

execute_process(COMMAND pkg-config --cflags --libs glib-2.0
                OUTPUT_VARIABLE PKG_CFLAGS_LDFLAGS
                OUTPUT_STRIP_TRAILING_WHITESPACE)

add_executable(myprogram myprogram.c)
target_compile_options(myprogram PRIVATE ${PKG_CFLAGS_LDFLAGS})
target_link_libraries(myprogram PRIVATE ${PKG_CFLAGS_LDFLAGS})
```

✅ **Best for:** Large projects with multiple dependencies.

---

### **Which One is Perfect?**
| Feature       | **Make + `pkg-config`** | **CMake + `pkg-config`** |
|--------------|-------------------|-------------------|
| Ease of Use  | Simple, manual | More structured |
| Dependency Management | Manual (`pkg-config` for each lib) | `find_package()` or `pkg-config` |
| Large Projects | ❌ Less scalable | ✅ Better for large projects |
| Cross-Platform | ❌ Mostly Linux | ✅ Works well on Windows, macOS, Linux |

**🔹 Verdict:**  
- **For simple projects:** `Make + pkg-config` is good.  
- **For large projects or cross-platform support:** `CMake + pkg-config` is better.







**Alias**


alias <aliasname>
type <aliasname>
declare -f open_terminals_left_2






spaceship-trajectory

```
https://github.com/phiresky/spaceship-trajectory.git
https://github.com/SrTobi/spaceship-trajectory/tree/main

```














**Plan:**



```
https://annas-archive.org/datasets/other_metadata
https://github.com/phiresky/isbn-visualization
https://phiresky.github.io/blog/2025/visualizing-all-books-in-isbn-space/


https://annas-archive.org/blog/all-isbns-winners.html



 Hosting read-only SQLite databases on static file hosters like Github Pages 
https://github.com/phiresky/sql.js-httpvfs

```