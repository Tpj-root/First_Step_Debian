Good 👍
Here is a **clear self-recovery procedure** you can follow next time.

---

# 🛠 When Laptop Shows: `grub rescue>` or `no such partition`

---

# STEP 1 — Stay Calm 😄

This usually means:

* Bootloader broken (GRUB problem)
* NOT data loss
* Windows & partitions often still safe

---

# STEP 2 — Check Disk From Another Linux PC

Connect HDD externally.

Check disks:

```
lsblk
```

Identify:

* Which disk is laptop disk (by size)
* Example: 320GB = sdb

---

# STEP 3 — Inspect Partitions

```
sudo fdisk -l /dev/sdb
sudo blkid
```

Look for:

* NTFS → Windows
* ext4/ext3 → Linux
* Small 100–500MB → boot partition

---

# STEP 4 — Check If Linux Still Exists

Mount Linux partition:

```
sudo mount /dev/sdbX /mnt
ls /mnt
```

If you see:

```
bin  boot  etc  home  lib  usr
```

✅ Linux exists → just reinstall GRUB

If you see only:

```
lost+found
```

❌ Linux is gone → must reinstall OS

---

# STEP 5 — If Linux Exists (Repair GRUB)

```
sudo mount /dev/sdbX /mnt
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo chroot /mnt
grub-install /dev/sdb
update-grub
exit
```

Done.

---

# STEP 6 — If Linux Is Gone But Windows Exists

Restore Windows MBR:

Install:

```
sudo apt install syslinux-common
```

Then:

```
sudo dd if=/usr/lib/syslinux/mbr/mbr.bin of=/dev/sdb bs=440 count=1 conv=notrunc
sudo sync
```

This:

* Removes GRUB
* Keeps partitions
* Makes Windows boot directly

---

# STEP 7 — Safe Removal

```
sudo umount -l /dev/sdb*
sudo sync
udisksctl power-off -b /dev/sdb
```

Then unplug.

---

# 🧠 Important Concepts You Learned

* MBR = first 512 bytes of disk
* First 440 bytes = bootloader
* Partition table is separate
* GRUB error ≠ data loss
* ext3/ext4 = Linux
* ntfs = Windows

---

# 🔥 Golden Rule

Always check:

```
lsblk
```

before writing to disk.

Wrong disk = disaster.

---



Good 👍 now deeper level.

---

# 💾 What is MBR exactly?

MBR = **Master Boot Record**

It is the **first sector** of a disk.

Size:

```
512 bytes total
```

Structure:

| Bytes   | Purpose                                |
| ------- | -------------------------------------- |
| 0–439   | Bootloader code                        |
| 440–443 | Disk signature                         |
| 444–509 | Partition table (4 entries × 16 bytes) |
| 510–511 | Boot signature (55 AA)                 |

---

# 🔹 1️⃣ First 440 Bytes — Bootloader Code

This is small machine code.

BIOS loads this into memory at boot.

CPU executes it.

If GRUB was installed → GRUB code is here.
If Windows MBR → Windows-style boot code is here.

That’s what your `dd` command replaced.

---

# 🔹 2️⃣ Partition Table (64 bytes)

Each partition entry = 16 bytes.

Contains:

* Start sector
* Size in sectors
* Partition type (07 = NTFS, 83 = Linux)
* Boot flag

Example:

```
Start: 2048
Size: 123527168
Type: 07
```

That tells OS where partition begins physically.

---

# 🔹 3️⃣ Boot Signature (55 AA)

Last 2 bytes:

```
0x55 0xAA
```

BIOS checks this.

If not present → disk not bootable.

---

# 🧠 How Boot Process Works (BIOS system)

1️⃣ Power ON
2️⃣ BIOS reads first 512 bytes
3️⃣ Loads into RAM
4️⃣ CPU executes boot code
5️⃣ Boot code reads partition table
6️⃣ Loads OS bootloader from active partition

---

# 📍 Where Data Is Written?

When you ran:

```
dd if=mbr.bin of=/dev/sdb bs=440 count=1
```

You wrote ONLY:

```
Byte 0 → Byte 439
```

On:

```
/dev/sdb (whole disk)
```

You did NOT touch:

* Partition table
* File systems
* Windows files

---

# 🔬 If You Want To See MBR

You can inspect raw bytes:

```
sudo hexdump -C /dev/sdb | head
```

You will see binary machine code.

---

# 💡 Important

MBR is used only in:

* BIOS systems
* DOS partition tables

Modern systems use GPT (different structure).

Your disk:

```
Disklabel type: dos
```

So it is MBR style.

---

# 🧠 Why GRUB error ≠ data loss?

Because:

* GRUB lives in first 440 bytes
* OS lives thousands of sectors later

Bootloader broken ≠ filesystem deleted.

---



Good 🔥 now we go very low-level.

---

# 🖥 When You Press Power Button

### 1️⃣ CPU Reset

CPU starts in **real mode**
Instruction pointer is set to:

```
0xFFFF0
```

It begins executing firmware (BIOS code) stored on motherboard.

---

# 2️⃣ BIOS Runs

BIOS:

* Initializes RAM
* Detects keyboard, disk, devices
* Finds boot device (HDD)

Then it reads:

```
First 512 bytes (MBR)
```

from disk into RAM at address:

```
0x7C00
```

---

# 3️⃣ CPU Executes MBR Code

BIOS does:

```
Jump to 0x7C00
```

Now CPU executes the 440 bytes of boot code.

This code is tiny assembly language.

Example of what it does:

* Read partition table
* Find active partition
* Load its boot sector
* Jump to it

---

# 4️⃣ Bootloader Stage 2

Because 440 bytes is too small,
MBR loads a bigger program from disk.

If GRUB:

* Stage1 → in MBR
* Stage2 → stored in /boot

If Windows:

* Loads bootmgr from NTFS

---

# 5️⃣ Kernel Loads

Bootloader:

* Loads Linux kernel into memory
* Switches CPU from real mode → protected mode
* Enables 32/64 bit
* Passes control to kernel

---

# 🔬 What CPU Actually Does

CPU follows this cycle:

```
Fetch → Decode → Execute
```

Example:

Memory at 0x7C00:

```
FA      ; disable interrupts
33 C0   ; xor ax, ax
8E D0   ; move ax to ss
```

CPU:

* Fetches bytes
* Decodes instruction
* Executes

Millions per second.

---

# 💡 Important

At this moment:

* No OS
* No filesystem
* No drivers
* Only raw machine code

The bootloader builds the environment step by step.

---

# 🧠 Big Picture

Power ON
→ BIOS
→ MBR (440 bytes)
→ Bootloader
→ Kernel
→ Operating System

---



Good 🔥 clear difference below.

---

# 🧱 MBR (Master Boot Record)

Old system (1980s).

### Structure

* First 512 bytes of disk
* 440 bytes → bootloader
* 64 bytes → partition table
* Max 4 primary partitions

### Limits

* Max disk size: **2 TB**
* Only 4 primary partitions
* Single partition table (if corrupted → big problem)

### Used With

* Legacy BIOS systems

---

# 🧠 GPT (GUID Partition Table)

Modern system.

### Structure

* Protective MBR (first 512 bytes)
* GPT header
* Partition table entries (usually 128 entries)
* Backup copy at end of disk

### Features

* Supports disks larger than **2 TB**
* Supports many partitions (usually 128)
* Has CRC checksum (detects corruption)
* Backup partition table at end of disk

### Used With

* UEFI systems

---

# ⚖ Simple Comparison

| Feature         | MBR  | GPT   |
| --------------- | ---- | ----- |
| Max size        | 2TB  | 9.4ZB |
| Partitions      | 4    | 128   |
| Backup table    | ❌    | ✅     |
| Error detection | ❌    | ✅     |
| Boot mode       | BIOS | UEFI  |

---

# 💡 Why GPT Is Safer

If GPT header gets damaged:

* Backup header at end can restore it.

MBR:

* If first 512 bytes damaged → partition info gone.

---

# 🔍 Your Disk

You saw:

```
Disklabel type: dos
```

That means your disk uses **MBR**.

If it was GPT, it would say:

```
Disklabel type: gpt
```

Good 🔥 now very low-level.

---

# 🧠 What Is Real Mode?

Real mode is the **original CPU mode** of the 8086 processor.

When computer powers on:

👉 CPU starts in **16-bit real mode**

No OS.
No memory protection.
Very simple environment.

---

# 🧱 Memory in Real Mode

Real mode can access:

```
1 MB memory (0x00000 → 0xFFFFF)
```

Address calculation:

```
Physical Address = (Segment × 16) + Offset
```

Example:

```
Segment: 0x1000
Offset : 0x0010
```

Physical address:

```
0x1000 × 16 + 0x0010
= 0x10000 + 0x10
= 0x10010
```

---

# 🧩 Segment Registers

Real mode uses 4 main segment registers:

* CS → Code Segment
* DS → Data Segment
* SS → Stack Segment
* ES → Extra Segment

Instruction pointer (IP) works with CS.

Full address:

```
CS:IP
```

---

# 🔄 CPU Execution in Real Mode

Cycle:

```
Fetch → Decode → Execute
```

Example assembly:

```
mov ax, 0x1234
add ax, 0x1
```

CPU:

* Reads instruction from memory
* Decodes opcode
* Executes
* Moves to next instruction

---

# ⚠ Limitations of Real Mode

* Only 16-bit registers
* Max 1MB memory
* No memory protection
* No multitasking
* Any program can overwrite anything

Very dangerous but simple.

---

# 🖥 Why Boot Starts in Real Mode?

Because BIOS is old 16-bit firmware.

Boot process:

Power ON
→ CPU in real mode
→ BIOS runs
→ MBR runs (also 16-bit code)

Then bootloader switches to:

👉 Protected mode (32-bit)
or
👉 Long mode (64-bit)

---

# 🧠 Why Switch Mode?

Modern OS needs:

* Access to >1MB RAM
* Memory protection
* Virtual memory
* Multitasking
* Hardware control

Real mode cannot do this.

---

# 🔥 Simple Summary

Real mode = primitive startup mode

* 16-bit
* 1MB memory
* No protection
* Used only during boot

After kernel loads → CPU leaves real mode forever.

---

Good 🔥 this is important step in OS boot.

---

# 🧠 Why Switch to Protected Mode?

Real mode:

* 16-bit
* 1MB memory limit
* No memory protection

Modern OS needs:

* 32-bit registers
* Access to full RAM
* Memory protection
* Multitasking

So bootloader switches CPU mode.

---

# 🧱 Step-by-Step Switch to Protected Mode

### 1️⃣ Disable interrupts

```
cli
```

Stops hardware interrupts during transition.

---

### 2️⃣ Create GDT (Global Descriptor Table)

GDT defines memory segments.

Example entries:

* Null descriptor
* Code segment
* Data segment

Each entry describes:

* Base address
* Limit
* Access flags

---

### 3️⃣ Load GDT into CPU

```
lgdt [gdt_descriptor]
```

Now CPU knows where GDT is in memory.

---

### 4️⃣ Enable PE bit in CR0 register

CR0 = Control Register 0

Set bit 0 (Protection Enable):

```
mov eax, cr0
or eax, 1
mov cr0, eax
```

This tells CPU:
👉 Switch to protected mode

---

### 5️⃣ Far Jump (very important)

```
jmp 0x08:protected_mode_entry
```

This reloads CS and flushes instruction pipeline.

Now CPU executes 32-bit code.

---

# 🧠 What Changed Now?

After switch:

* 32-bit registers (EAX, EBX…)
* Access to 4GB memory
* Segment protection
* Paging possible
* Hardware isolation

---

# 📍 What Is GDT?

Table that defines segments:

| Entry | Type         |
| ----- | ------------ |
| 0     | Null         |
| 1     | Code segment |
| 2     | Data segment |

Each is 8 bytes.

CPU uses segment selector like:

```
CS = 0x08
DS = 0x10
```

---

# ⚡ Important

If you forget the far jump → system crashes.

Switching mode without proper GDT → triple fault → reboot.

---

# 🖥 Boot Flow So Far

Power ON
→ BIOS (real mode)
→ MBR
→ Bootloader
→ Setup GDT
→ Set CR0 PE bit
→ Far jump
→ Protected mode

Then kernel continues.

---

Here is the **clean, exact sequence** the CPU follows when switching from **real mode → protected mode**.

---

# 🧠 Starting State

After power on:

* CPU is in **16-bit real mode**
* BIOS or bootloader is running
* Only 1MB memory accessible

---

# 🔄 The Switch Procedure

## 1️⃣ Disable Interrupts

```
cli
```

Prevents interrupt during transition.

If interrupt happens now → crash.

---

## 2️⃣ Build the GDT (Global Descriptor Table)

Create a small table in memory:

| Entry | Purpose             |
| ----- | ------------------- |
| 0     | Null descriptor     |
| 1     | 32-bit Code segment |
| 2     | 32-bit Data segment |

Each entry = 8 bytes.

This defines:

* Base address
* Limit
* Access rights

---

## 3️⃣ Load GDT into CPU

```
lgdt [gdt_descriptor]
```

Now CPU knows where GDT is stored.

But still in real mode.

---

## 4️⃣ Enable Protection Bit

CR0 register controls CPU modes.

Set bit 0 (PE = Protection Enable):

```
mov eax, cr0
or eax, 1
mov cr0, eax
```

At this moment:

👉 CPU is technically in protected mode
BUT still executing old 16-bit code.

---

## 5️⃣ FAR Jump (Critical Step)

```
jmp 0x08:protected_entry
```

Why?

* Reloads CS register
* Flushes instruction pipeline
* Forces CPU to use new segment descriptor

Without this → system triple fault.

Now CPU is fully in **32-bit protected mode**.

---

# 🧠 What Changes After Switch?

Now CPU:

* Uses 32-bit registers (EAX, EBX, ECX…)
* Can access 4GB memory
* Supports memory protection
* Can enable paging
* Can run multitasking OS

---

# 📍 Internally What Happens?

When CR0.PE = 1:

CPU:

* Stops using real-mode segmentation
* Uses GDT descriptors
* Validates memory access rights

Memory is now segmented logically.

---

# 🔥 Very Important

Switching is irreversible without reset.

To go back to real mode:

* Must reset CPU
* Or use VM86 (special mode)

---

# ⚙ Complete Boot Flow

Power ON
→ Real mode
→ BIOS
→ Bootloader
→ Setup GDT
→ Set CR0 PE bit
→ Far jump
→ Protected mode
→ Enable paging
→ Load kernel

---

Good 🔥 now GPT concept.

---

# 🧱 What Is Protective MBR?

Protective MBR exists on **GPT disks**.

Even GPT disks still keep the **first 512 bytes** like MBR.

But it is fake.

It is there to:

👉 Protect GPT disk from old tools
👉 Prevent old MBR-only software from deleting partitions

---

# 🧠 Why Needed?

Old operating systems understand only MBR.

If they see:

“Empty disk”

They may overwrite it.

So GPT puts a fake MBR entry that says:

```
This entire disk is already used.
```

So old tools leave it alone.

---

# 📦 Structure of Protective MBR

First 512 bytes contain:

* Boot code area (usually unused)
* One partition entry
* Type = 0xEE
* Covers entire disk

Type `0xEE` means:

👉 GPT Protective Partition

---

# 📍 Example (fdisk output)

On GPT disk you’ll see:

```
Device     Start      End  Type
/dev/sda1  1     500000000  ee GPT
```

That is not real partition.

It is protection layer.

---

# 🆚 Difference From Normal MBR

| Normal MBR      | Protective MBR           |
| --------------- | ------------------------ |
| Real partitions | One fake partition       |
| BIOS boot       | Used only for protection |
| Max 2TB         | GPT supports huge disks  |

---

# 🧠 Where Real GPT Data Is Stored?

After sector 0:

Sector 1 → GPT Header
Next sectors → GPT Partition Entries
Last sector → Backup GPT header

So GPT stores:

* Main table at start
* Backup table at end

Much safer than MBR.

---

# 💡 Important

Even GPT disk still contains:

```
First 512 bytes (MBR sector)
```

But that MBR is protective, not real.

---

# 🔥 Simple Summary

Protective MBR = Fake MBR inside GPT disk
Purpose = Prevent old software from destroying GPT partitions

---

Good 🔥 let’s go step-by-step.

---

# 🧱 GPT Disk Layout (Physical Order)

On a GPT disk:

```
Sector 0  → Protective MBR
Sector 1  → GPT Header
Sector 2+ → Partition Entry Array
...
Last sectors → Backup Partition Array
Last sector → Backup GPT Header
```

GPT always keeps **main copy + backup copy**.

---

# 📌 1️⃣ GPT Header (Sector 1)

Contains:

* Disk GUID (unique disk ID)
* Start & end usable sectors
* Location of partition entries
* Number of partition entries
* Size of each entry
* CRC32 checksum

This header tells the system:

👉 “Where partitions are stored”

---

# 📦 2️⃣ Partition Entry Array

This is where real partition data lives.

Each partition entry is:

**128 bytes (default size)**

Typical disk stores **128 entries**

So:

```
128 entries × 128 bytes = 16 KB
```

That equals 32 sectors (if sector size = 512 bytes).

---

# 🧬 Structure of One GPT Partition Entry (128 bytes)

| Offset | Size     | Meaning                 |
| ------ | -------- | ----------------------- |
| 0x00   | 16 bytes | Partition Type GUID     |
| 0x10   | 16 bytes | Unique Partition GUID   |
| 0x20   | 8 bytes  | First LBA               |
| 0x28   | 8 bytes  | Last LBA                |
| 0x30   | 8 bytes  | Attributes              |
| 0x38   | 72 bytes | Partition Name (UTF-16) |

---

# 🧠 Important Fields Explained

### 🔹 Partition Type GUID

Defines partition type.

Examples:

* Windows basic data
* Linux filesystem
* EFI System Partition

Each OS has its own type GUID.

---

### 🔹 Unique Partition GUID

Every partition gets its own unique ID.

Like fingerprint.

---

### 🔹 First LBA / Last LBA

Tells:

👉 Where partition starts
👉 Where partition ends

LBA = Logical Block Address

---

### 🔹 Attributes

Flags like:

* Read only
* Hidden
* Required for boot

---

### 🔹 Name

Stored in UTF-16.

Example:

```
"Windows"
"LinuxRoot"
"EFI"
```

---

# 🔄 Backup Copy

At the end of disk:

* Backup partition entries
* Backup GPT header

If main GPT is damaged:

System can restore from backup.

This makes GPT safer than MBR.

---

# 🆚 GPT vs MBR Partition Storage

| MBR                | GPT                  |
| ------------------ | -------------------- |
| 4 partitions max   | 128 default          |
| 16 bytes per entry | 128 bytes per entry  |
| No backup          | Full backup copy     |
| 2TB limit          | Huge disks supported |

---

# 🧠 Simple Mental Picture

Think GPT like this:

Header = index page
Partition array = table of contents
Each entry = one partition record
Backup copy = safety duplicate

---

Good 🔥 now CPU memory segmentation level.

---

# 🧱 What is GDT?

**GDT = Global Descriptor Table**

It’s a **table in memory** that defines **memory segments** for protected mode.

* CPU uses it to know:

  * Where code lives
  * Where data lives
  * How much memory is allowed
  * Access rights (read/write/execute)

Without GDT → CPU cannot switch safely to protected mode.

---

# 🧩 Structure of a GDT Entry (8 bytes)

Each entry = **8 bytes**, describes a segment.

| Field                  | Purpose                                  |
| ---------------------- | ---------------------------------------- |
| Base address (32 bits) | Starting memory address of segment       |
| Limit (20 bits)        | Size of segment                          |
| Access byte (8 bits)   | Permission flags (code/data, read/write) |
| Flags (4 bits)         | Granularity, 32-bit/16-bit, etc.         |

---

# 🔹 Example Entries

1️⃣ Null Descriptor → must exist, not used
2️⃣ Code Segment → base=0, limit=4GB, executable
3️⃣ Data Segment → base=0, limit=4GB, read/write

CPU selects segments using **selectors**:

```
CS = 0x08  ; Code segment
DS = 0x10  ; Data segment
```

---

# 🧠 How CPU Uses GDT

1. You load GDT with `lgdt [gdt_descriptor]`
2. Set **CR0.PE = 1** → enable protected mode
3. Perform **far jump** to reload CS
4. CPU now enforces segment limits and permissions

---

# ⚡ Why GDT Is Important

* Without it → protected mode will **crash**
* Defines memory access rights
* Enables multitasking, isolation, paging
* Needed before switching from real mode → protected mode

---

# 📍 Mental Picture

```
GDT = "map of all memory segments"
Selector = "pointer to one segment in the map"
CPU = "checks map before accessing memory"
```

---

Perfect 🔥 now we reach **full memory management in protected mode**.

---

# 🧱 Two Layers of Memory Control

CPU in protected mode uses **GDT + Paging** together:

1️⃣ **GDT** → Controls **segments**

* Base, limit, access rights
* 32-bit segments in protected mode
* Defines “allowed ranges” for code/data

2️⃣ **Paging** → Controls **virtual memory mapping**

* Maps virtual addresses → physical RAM
* Allows 4GB+ memory, protection, and isolation
* Supports swapping to disk (virtual memory)

---

# 🔹 Step 1 — Segmentation via GDT

* CPU sees memory as **segments**
* Code segment = 0x00000000 → 4GB
* Data segment = 0x00000000 → 4GB

Segment selector loaded in CS, DS, SS registers.
Example:

```
CS = 0x08 → Code segment
DS = 0x10 → Data segment
```

* Access rights enforced (read/write/execute)
* Segment limit enforced (no out-of-bounds access)

---

# 🔹 Step 2 — Enable Paging

* CPU has **CR3 register** → points to **page directory**
* Page directory + tables map **virtual → physical addresses**
* Paging divides memory into **4 KB pages** (or larger)

Example:

* Virtual address 0xC0001000 → Physical RAM 0x00101000

Paging allows:

* Isolated process memory
* Access beyond 4GB (with PAE/64-bit)
* Memory protection between processes

---

# 🔹 Step 3 — GDT + Paging Together

1. GDT sets **segment base/limits**
2. Paging maps **virtual addresses inside those segments**

Effect:

* CPU checks segment limits first
* Then translates virtual address via page tables
* Result: safe, protected, large memory access

---

# 🔬 Mental Picture

```
CPU Access:
[Virtual Address] 
   ↓ GDT (segment base + limit check)
   ↓ Paging (map virtual → physical)
   ↓ RAM access
```

* Segmentation = “which segment can you use?”
* Paging = “where exactly in RAM does it go?”

---

# ⚡ Benefits

* Allows **32-bit OS** to use full 4GB RAM safely
* Memory protection between processes
* Virtual memory and swapping
* Supports 64-bit extensions later

---

# 🧠 Key Registers

| Register       | Role                                   |
| -------------- | -------------------------------------- |
| CS, DS, SS, ES | Segment selectors from GDT             |
| CR0.PG         | Enable paging                          |
| CR3            | Points to page directory (paging root) |

---

Perfect 🔥 let’s break down the **GPT header** in detail.

---

# 🧱 GPT Header Overview

GPT disks store **partitioning info differently than MBR**.

* **Sector 0** → Protective MBR
* **Sector 1** → Primary GPT Header
* **Sectors 2+** → Partition entries
* **Backup** → at end of disk

The **GPT header** tells the system how to read the partition entries.

---

# 📦 GPT Header Structure (92–128 bytes)

| Offset | Size | Purpose                                          |
| ------ | ---- | ------------------------------------------------ |
| 0x00   | 8 B  | Signature `"EFI PART"` (45 46 49 20 50 41 52 54) |
| 0x08   | 4 B  | Revision (usually 1.0 → 00 00 01 00)             |
| 0x0C   | 4 B  | Header size in bytes (usually 92)                |
| 0x10   | 4 B  | CRC32 checksum of header                         |
| 0x14   | 4 B  | Reserved (must be 0)                             |
| 0x18   | 8 B  | Current LBA of header (usually 1)                |
| 0x20   | 8 B  | Backup LBA of header (usually last sector)       |
| 0x28   | 8 B  | First usable LBA for partitions                  |
| 0x30   | 8 B  | Last usable LBA for partitions                   |
| 0x38   | 16 B | Disk GUID (unique disk ID)                       |
| 0x48   | 8 B  | Starting LBA of partition entry array            |
| 0x50   | 4 B  | Number of partition entries                      |
| 0x54   | 4 B  | Size of each entry (usually 128)                 |
| 0x58   | 4 B  | CRC32 of partition entries                       |
| 0x5C   | 4 B  | Reserved / padding                               |

---

# 🔹 Key Fields Explained

### 1️⃣ Signature

* Must be `"EFI PART"`
* Confirms disk is GPT, not MBR

### 2️⃣ Header CRC32

* Ensures GPT header isn’t corrupted
* If wrong → boot tools detect error

### 3️⃣ Disk GUID

* Unique 16-byte identifier for this disk

### 4️⃣ First/Last Usable LBA

* Defines which sectors can hold partitions
* Avoids overwriting GPT or protective MBR

### 5️⃣ Partition Table Location

* LBA of first partition entry
* Number of entries
* Size of each entry (usually 128 bytes)
* CRC32 of table

---

# 🔹 Backup Header

At **last sector** of disk:

* Exact copy of primary GPT header
* Ensures recovery if primary header is damaged

---

# ⚡ Important Concepts

1. GPT **does not store bootloader** in header
2. Header only points to **partition entries**
3. CRC32 checks → protects against corruption
4. Backup copy → extra safety

---

# 🧠 Mental Picture

```
Sector 0 → Protective MBR
Sector 1 → GPT Header (primary)
Sectors 2–33 → Partition Entries (primary)
...
Last 33 sectors → Partition Entries (backup)
Last sector → GPT Header (backup)
```

---

Perfect 🔥 now we reach **UEFI boot with GPT disks**.

---

# 🖥 UEFI Boot Process Overview

UEFI replaces old BIOS + MBR boot.
It directly understands **GPT disks**.

---

# 🧱 Step 1 — Power ON

* CPU starts (still in real mode)
* UEFI firmware initializes devices (RAM, disks, keyboard)
* UEFI firmware **reads GPT** instead of MBR

---

# 🧩 Step 2 — Locate EFI System Partition (ESP)

UEFI expects **one GPT partition flagged as EFI System Partition**:

* Partition type GUID = `C12A7328-F81F-11D2-BA4B-00A0C93EC93B`
* Usually 100–500 MB, FAT32 format
* Contains bootloaders:

  * `\EFI\Microsoft\Boot\bootmgfw.efi` → Windows
  * `\EFI\ubuntu\grubx64.efi` → Linux

UEFI reads the GPT header → partition table → finds ESP.

---

# 🔹 Step 3 — Read EFI Bootloaders

Inside ESP:

* `.efi` files are programs executable by UEFI
* UEFI firmware loads chosen `.efi` file into memory
* CPU jumps directly to bootloader entry point

Example:

```
UEFI -> ESP -> \EFI\Microsoft\Boot\bootmgfw.efi
```

---

# 🔹 Step 4 — Bootloader Loads OS Kernel

* Windows bootloader → `winload.efi` → Windows kernel
* Linux GRUB → loads Linux kernel and initramfs

UEFI can handle multiple bootloaders at once.
Boot order is stored in **NVRAM**:

```
BootOrder = [Ubuntu, Windows Boot Manager, Others]
```

---

# 🔹 Step 5 — Optional Secure Boot

* UEFI can verify `.efi` signature
* Prevents unsigned/malicious bootloaders from running
* Uses public-key cryptography

---

# ⚡ Key Differences From BIOS + MBR

| Feature            | BIOS + MBR                   | UEFI + GPT                     |
| ------------------ | ---------------------------- | ------------------------------ |
| Boot code location | MBR first 512 bytes          | EFI System Partition           |
| OS detection       | Active partition             | GPT + ESP + NVRAM boot entries |
| Partition limit    | 2 TB / 4 partitions          | 9.4 ZB / 128+ partitions       |
| Secure boot        | ❌                            | ✅                              |
| Mode               | 16-bit → switch to protected | Can boot 32/64-bit directly    |

---

# 🧠 Mental Picture

```
UEFI Firmware
    │
    ▼
GPT Header → Partition Table
    │
    ▼
EFI System Partition (ESP)
    │
    ▼
Load .EFI bootloader
    │
    ▼
Load OS kernel → OS starts
```

---

# 💡 Summary

* GPT + UEFI eliminates MBR limitations
* No BIOS-style bootloader in MBR
* ESP contains `.efi` boot programs
* NVRAM stores boot order and config

---

Perfect 🔥 now we cover **UEFI fault tolerance**.

---

# 🧱 GPT + UEFI Fault Recovery

GPT + UEFI is designed to **survive partial disk corruption**.

---

## 1️⃣ GPT Header Corruption

* GPT stores **two headers**:

  * Primary → first sectors of disk
  * Backup → last sectors of disk

**Scenario:** Primary GPT header damaged

**UEFI action:**

1. Reads **backup GPT header** at the end of disk
2. Checks **CRC32 checksum** of header and partition table
3. Uses backup header to rebuild primary in memory (or repair disk if tool used)

✅ Disk partitions remain accessible
❌ Some old MBR tools may still misinterpret disk if header not repaired

---

## 2️⃣ EFI System Partition (ESP) Corruption

ESP contains `.efi` bootloaders (Windows, GRUB, etc.)

**Scenario:** ESP FAT32 corrupted or bootloader missing

**UEFI action:**

* If multiple ESPs exist → can try next bootloader in NVRAM BootOrder
* If backup bootloader exists on same ESP → UEFI loads it
* Some firmware allows **recovery from network or USB**

**Result:** OS may still boot if backup exists; otherwise, user intervention is needed

---

## 3️⃣ Redundancy and Safety Features

| Feature                             | Purpose                                 |
| ----------------------------------- | --------------------------------------- |
| Backup GPT Header & Partition Table | Recover partitions if primary corrupted |
| CRC32 checks                        | Detect corruption                       |
| Multiple bootloaders in ESP         | Failover OS boot                        |
| NVRAM BootOrder                     | Stores alternative boot paths           |
| Protective MBR                      | Protects GPT from old software          |

---

## 4️⃣ Summary Workflow for UEFI Recovery

```
Power ON → UEFI Firmware
      │
      ▼
Read GPT Header → Check CRC
      │
      ├─ If primary corrupt → use backup GPT header
      │
      ▼
Locate EFI System Partition (ESP)
      │
      ├─ If ESP corrupt → try backup bootloader / next NVRAM entry
      │
      ▼
Load EFI Bootloader → Kernel → OS starts
```

---

# 💡 Key Points

* GPT + UEFI = much safer than MBR + BIOS
* Even if **header or bootloader damaged**, system may boot
* Redundancy and CRC32 make recovery automatic
* User can repair manually with `gdisk`, `efibootmgr`, or recovery media if needed

---

Perfect 🔥 now let’s tie **UEFI + GPT + GRUB** together.

---

# 🧱 Linux GRUB Boot on GPT + UEFI

GRUB is the bootloader that Linux uses to load the kernel. On UEFI + GPT disks, it works differently than BIOS + MBR.

---

## 1️⃣ Disk Layout

```
GPT Disk:
Sector 0      → Protective MBR
Sector 1      → GPT Header (primary)
Sector 2+     → Partition Entries
Partition N   → EFI System Partition (ESP, FAT32)
Partition X   → Linux root (ext4)
Last sectors  → Backup GPT header + backup partition entries
```

* ESP contains GRUB EFI executable:

```
/EFI/ubuntu/grubx64.efi
```

---

## 2️⃣ UEFI Firmware Role

* Reads **primary GPT header** → knows where partitions are
* Locates **ESP partition** via GPT type GUID
* Loads `.efi` file from ESP → executes GRUB in memory

---

## 3️⃣ GRUB Stages in UEFI

Unlike BIOS, GRUB doesn’t need MBR sectors:

1. **GRUB EFI binary** (`grubx64.efi`) resides in ESP
2. GRUB reads **GPT partition table**
3. Loads configuration file:

```
/EFI/ubuntu/grub.cfg
```

4. GRUB shows menu (multi-boot if Windows/Linux exist)
5. GRUB loads **Linux kernel + initramfs** from root partition

---

## 4️⃣ How GPT Helps GRUB

* GPT partitions have **GUIDs** → GRUB identifies correct root partition
* Allows **more than 4 partitions** → GRUB can boot multiple OS easily
* Backup GPT → prevents boot failure if primary partition table is damaged

---

## 5️⃣ Safety and Redundancy

* Multiple `.efi` bootloaders can exist on ESP
* NVRAM stores boot order → firmware can try alternate loaders
* If ESP corrupted → user may need live USB or `efibootmgr` repair

---

## 6️⃣ Mental Picture

```
Power ON
   │
   ▼
UEFI Firmware → GPT → ESP
   │
   ▼
Load /EFI/ubuntu/grubx64.efi
   │
   ▼
GRUB → Read grub.cfg → Show menu
   │
   ▼
Load Linux kernel + initramfs
   │
   ▼
Linux starts → protected mode, paging enabled
```

---

## ⚡ Key Points

* **No MBR needed** for GRUB on UEFI + GPT
* **GRUB reads GPT** to find partitions
* **ESP is critical** → contains `.efi` binary and config
* Boot is **robust** thanks to GPT backup and NVRAM entries

---

Yes 🔥 let’s connect everything into one **end-to-end CPU boot flow** for Linux on UEFI + GPT.

---

# 🖥 Step-by-Step CPU Boot to Linux Kernel

---

## 1️⃣ Power-On

* CPU starts in **16-bit real mode**
* BIOS/UEFI firmware initializes hardware:

  * RAM, CPU, disks, keyboard
* CPU can only access **1MB memory** at this stage

---

## 2️⃣ UEFI Firmware Reads GPT

* Firmware reads **GPT header + partition entries**
* Locates **EFI System Partition (ESP)**
* Checks **boot order in NVRAM**
* Loads **GRUB EFI binary** into memory

---

## 3️⃣ GRUB Loads

* GRUB executes as **32-bit or 64-bit EFI program**
* Reads **grub.cfg** from ESP
* Shows boot menu for multiple OSes
* Loads **Linux kernel + initramfs** into RAM

---

## 4️⃣ CPU Mode Switch (Protected Mode / Long Mode)

* GRUB sets up **memory segmentation (GDT)**
* Enables **protected mode** (32-bit)
* Sets up **paging** → maps virtual memory to physical RAM
* If 64-bit kernel → switches CPU to **long mode**

---

## 5️⃣ Kernel Initialization

* Kernel initializes hardware:

  * Interrupts, timers, devices, memory management
* Sets up **kernel page tables**
* Mounts root filesystem (from GPT partition)
* Starts **init process** → launches user-space services

---

## 6️⃣ Multi-Tasking Ready

* CPU fully in **protected / long mode**
* Paging ensures each process isolated
* Kernel scheduler can now switch tasks safely
* Linux OS is running, ready for users

---

# 🔹 End-to-End Flow (Summary)

```
Power ON → CPU in real mode
      │
      ▼
UEFI Firmware initializes hardware
      │
      ▼
Read GPT → Find ESP → Load GRUB
      │
      ▼
GRUB reads grub.cfg → Load Linux kernel + initramfs
      │
      ▼
Set GDT → Enable protected mode → Enable paging
      │
      ▼
(64-bit kernel) CPU switches to long mode
      │
      ▼
Linux kernel initializes → Mount root → Start init
      │
      ▼
Full OS running
```

---

# ⚡ Key Points

* **GDT + paging** = memory protection + large address space
* **GRUB + ESP + GPT** = robust bootloader + partition mapping
* **UEFI + backup GPT + NVRAM** = resilience against corruption
* Boot is **modular** → firmware → bootloader → kernel → OS

---

Perfect 🔥 now let’s focus on **how the Linux kernel takes control from GRUB/UEFI**.

---

# 🧱 Kernel Takeover Step-by-Step

---

## 1️⃣ GRUB Loads Kernel into Memory

* GRUB copies **vmlinuz** (compressed Linux kernel) into RAM
* GRUB sets **registers and CPU state**:

  * Passes memory map (from UEFI)
  * Passes boot parameters (`cmdline`, EFI info, ACPI tables)
* GRUB may also load **initramfs** (initial RAM filesystem)

---

## 2️⃣ CPU State Before Kernel

* CPU already in **protected mode** or **long mode (64-bit)** if EFI kernel
* Paging may be enabled (GRUB sets up minimal page tables)
* Segmentation (GDT) is set
* Kernel entry point = **vmlinuz start address**

---

## 3️⃣ Kernel Decompression

* Linux kernel is compressed on disk → small size
* First code executed decompresses kernel into high memory
* After decompression, kernel jumps to **main entry function**

---

## 4️⃣ Early Kernel Setup

### Memory Initialization

* Reads memory map provided by UEFI/BIOS
* Initializes **page tables** → full virtual memory layout
* Sets up **stack and heap** for kernel

### CPU & System Setup

* Initializes **GDT / IDT** (interrupt descriptor table)
* Enables **hardware interrupts**
* Detects CPU features (SSE, APIC, etc.)

---

## 5️⃣ Initramfs / Root Filesystem

* Kernel mounts **initramfs** (temporary RAM-based root)
* Loads essential drivers for disk, filesystem, etc.
* Prepares to mount actual root partition from GPT disk

---

## 6️⃣ Switching to Real Root Filesystem

* Kernel mounts **real root filesystem** (ext4, XFS, etc.)
* Moves initramfs content aside
* Sets up device tree and drivers

---

## 7️⃣ Start `init` / `systemd`

* Kernel launches **first user-space process**: `init` or `systemd`
* `init` spawns login, GUI, services, daemons
* OS is now fully operational

---

# 🔹 Mental Picture

```
GRUB loads kernel → sets CPU & memory info
      │
      ▼
Kernel decompresses itself → sets up virtual memory
      │
      ▼
Initialize GDT/IDT, paging, interrupts, CPU features
      │
      ▼
Mount initramfs → load drivers
      │
      ▼
Mount real root → start init/systemd
      │
      ▼
Linux OS running → multi-tasking ready
```

---

# ⚡ Key Points

* Kernel takes **full control of CPU and memory**
* **Paging + GDT** now fully under kernel
* GRUB hands over only **boot info + memory map**
* Initramfs is temporary → real root filesystem replaces it
* After this, kernel manages **all processes, scheduling, and devices**

---

Perfect 🔥 now let’s explain **CPU 64-bit long mode** in detail.

---

# 🧱 What Is Long Mode?

* **Long mode** = 64-bit mode of x86-64 CPUs
* Allows CPU to use:

  * 64-bit registers (RAX, RBX …)
  * 64-bit virtual addresses
  * Access to >4GB physical memory
* Built on top of **protected mode + paging**

---

# 🔹 Two Components of Long Mode

1️⃣ **64-bit mode** → enables 64-bit registers & instructions
2️⃣ **Compatibility mode** → lets CPU run 32-bit programs inside 64-bit OS

* CPU starts in **real mode (16-bit)**
* Switches → **protected mode (32-bit)**
* Paging + long mode enabled → full 64-bit CPU features

---

# 🧩 Steps to Enable Long Mode

1. **Enable PAE (Physical Address Extension)**

   * Needed to access >4GB RAM in 32-bit
2. **Load Page Tables for 64-bit mode**

   * PML4 → Page Directory → Page Tables
   * Maps virtual → physical addresses
3. **Set `EFER.LME = 1`** (Extended Feature Enable Register)

   * Tells CPU: “I want 64-bit mode”
4. **Far jump into 64-bit code segment**

   * Loads **CS selector** pointing to 64-bit segment in GDT
5. CPU now fully in **long mode**

   * Paging must remain enabled
   * Segmentation is mostly flat (base=0, limit=4GB+)

---

# 🔹 Key Features in Long Mode

| Feature                  | Description                                            |
| ------------------------ | ------------------------------------------------------ |
| 64-bit registers         | RAX, RBX, RCX … up to 64-bit                           |
| 64-bit virtual addresses | Allows huge virtual memory space                       |
| Flat memory model        | Segmentation mostly ignored (base=0)                   |
| Paging                   | 4-level page tables → maps up to 256 TB virtual memory |
| Compatibility mode       | Can run 32-bit apps safely inside 64-bit OS            |

---

# 🔹 Memory Mapping in Long Mode

* Uses **4-level paging**:

```
CR3 → PML4 → PDPT → PD → PT → 4 KB pages
```

* Each process gets own virtual memory
* Kernel space is usually mapped in **high-half of virtual memory** (e.g., 0xFFFF800000000000)

---

# 🔹 Mental Picture

```
CPU starts: Real Mode (16-bit)
      │
      ▼
Protected Mode (32-bit)
      │
      ▼
Enable Paging + PAE → set EFER.LME
      │
      ▼
Far jump to 64-bit code segment → Long Mode
      │
      ▼
Full 64-bit virtual memory + registers available
```

---

# ⚡ Key Points

* **Long mode requires paging**
* Segmentation still exists but mostly flat
* Supports **huge virtual memory** (64-bit addresses)
* Allows Linux/Windows 64-bit kernels to fully control memory
* Compatibility mode ensures older 32-bit apps still run

---


Perfect 🔥 now let’s break down **CPU paging**, the backbone of virtual memory.

---

# 🧱 What Is Paging?

* Paging = CPU mechanism to map **virtual addresses → physical memory**

* Allows:

  * Each process to have its **own memory space**
  * Access to **more than 4 GB RAM** (with PAE/64-bit)
  * Memory protection and isolation

* Works together with **protected/long mode**

---

# 🔹 Virtual vs Physical Memory

```
Virtual address: 0x7FFF12345678  (used by program)
      │
      ▼ Page tables
Physical address: 0x0012345678   (actual RAM location)
```

* Programs see **virtual memory**
* CPU translates via **page tables** to physical memory

---

# 🔹 Page Tables (x86-64, 4-level)

64-bit CPU uses **4-level paging**:

1. **PML4** → top-level page table (Page Map Level 4)
2. **PDPT** → Page Directory Pointer Table
3. **PD** → Page Directory
4. **PT** → Page Table → maps **4 KB pages**

* Each level indexes 9 bits → 512 entries per table
* Total addressable = 512×512×512×512 × 4 KB = 256 TB virtual memory

---

# 🔹 CPU Paging Registers

| Register | Purpose                                                    |
| -------- | ---------------------------------------------------------- |
| CR3      | Points to **PML4** table for current process               |
| CR0.PG   | Enable paging (1 = on)                                     |
| CR4.PAE  | Enable Physical Address Extension (needed for >4GB memory) |
| EFER.LME | Enable long mode (64-bit)                                  |

---

# 🔹 How Paging Works (Step-by-Step)

1. CPU gets **virtual address** from instruction
2. Divides it into **page table indexes + page offset**

   * Example 64-bit VA: `[PML4][PDPT][PD][PT][offset]`
3. CPU reads **page tables** in memory → finds **physical frame**
4. Adds **offset** → final **physical address**
5. Access RAM at that physical address

* If entry not present → **page fault** occurs → OS handles it

---

# 🔹 Page Table Entry (PTE)

Each entry (64-bit) contains:

| Field                  | Purpose                      |
| ---------------------- | ---------------------------- |
| Present (P)            | 1 = mapped, 0 = not present  |
| Read/Write (R/W)       | Access permissions           |
| User/Supervisor (U/S)  | Kernel vs user access        |
| Physical frame address | Points to 4 KB page in RAM   |
| NX (No Execute)        | Marks page as non-executable |

---

# 🔹 Mental Picture

```
Virtual Address
     │
     ▼
+------+-------+------+-------+--------+
| PML4 | PDPT  | PD   | PT    | offset |
+------+-------+------+-------+--------+
     │ Each 9 bits indexes 512 entries
     ▼
Physical frame in RAM
     │
     ▼
CPU accesses RAM safely
```

---

# ⚡ Key Points

* Paging allows **virtual memory isolation**
* Enables **protected mode + long mode**
* Handles **memory > 4GB**
* OS can swap pages to disk when RAM is full
* Page faults → handled by kernel

---

Perfect 🔥 now let’s break down **triple fault** in x86 CPUs.

---

# 🧱 What Is a Triple Fault?

* A **fault** = CPU exception triggered by invalid instruction, memory access, or CPU state.
* A **double fault** = CPU cannot handle a first fault (e.g., page fault inside page fault handler).
* A **triple fault** = CPU cannot handle the **double fault** → CPU shuts down / resets automatically.

**Result:** Immediate **system reset** or halt.

---

# 🔹 Fault Hierarchy

```
Normal Fault → handled by CPU exception handler
       │
       ▼
Double Fault → triggered if first fault handler fails
       │
       ▼
Triple Fault → no handler left → CPU reset
```

---

# 🔹 Common Causes

1. **Invalid IDT (Interrupt Descriptor Table)**

   * CPU cannot find exception handler → double fault → triple fault

2. **Corrupt stack / GDT**

   * CPU cannot switch context to handle exception

3. **Critical boot errors**

   * Example: BIOS/UEFI tries to run invalid code in real mode

---

# 🔹 Triple Fault in Boot Process

* Happens **early in boot** if:

  * GRUB/UEFI code corrupt
  * GDT / IDT not initialized properly
  * Paging not set up correctly

* CPU **resets immediately** → no OS loaded

---

# 🔹 Mental Picture

```
CPU Exception Handling
────────────────────
Fault occurs
   │
   ▼
CPU calls handler in IDT
   │
   └─ If handler invalid → Double Fault
           │
           └─ If double fault handler fails → Triple Fault
                   │
                   └─ CPU reset (halts execution)
```

---

# ⚡ Key Points

* **Triple fault = fatal CPU error**
* Usually occurs in **boot or low-level OS code**
* Prevented by:

  * Correct IDT & GDT setup
  * Valid stack for CPU
  * Correct paging & CPU mode transitions

---

Perfect 🔥 let’s go deeper into **what specifically causes a triple fault**.

---

# 🧱 Causes of Triple Fault in x86 CPUs

A triple fault happens when **the CPU cannot handle a fault or double fault**. Typical causes:

---

## 1️⃣ Invalid or Missing IDT (Interrupt Descriptor Table)

* CPU uses **IDT** to find exception handlers.
* If **IDT is null, corrupt, or points to invalid memory**:

  * First fault → CPU tries handler → invalid → **double fault**
  * Double fault → no valid handler → **triple fault**

---

## 2️⃣ Stack Issues

* Each CPU exception uses a **stack** from GDT/TSS.
* If stack pointer is invalid (points outside usable memory):

  * CPU cannot push exception info → **double fault** → triple fault

---

## 3️⃣ Invalid GDT / Segment Setup

* Protected mode requires a **GDT**.
* If segment selectors point to invalid entries or GDT missing:

  * Exception cannot resolve → double fault → triple fault

---

## 4️⃣ Paging / Memory Errors

* Page fault occurs → CPU tries to handle → stack or page table invalid:

  * Double fault occurs → triple fault

---

## 5️⃣ Bootloader / Early Boot Bugs

* GRUB, BIOS, or UEFI code error in **real → protected mode transition**
* Examples:

  * Jumping to non-existent 32-bit segment
  * Bad stack setup before enabling paging

---

## 6️⃣ CPU Hardware Faults (Rare)

* Faulty CPU, memory corruption, or unstable power can trigger triple fault

---

# 🔹 Summary Table

| Cause          | How it triggers triple fault    |
| -------------- | ------------------------------- |
| Invalid IDT    | CPU cannot locate handler       |
| Bad stack      | Cannot push exception frame     |
| Corrupt GDT    | Segment cannot be loaded        |
| Paging errors  | Fault during page fault handler |
| Bootloader bug | Invalid mode transition         |
| Hardware fault | Memory / CPU corruption         |

---

# 🔹 Mental Picture

```
Fault → CPU looks up IDT
       │
       ├─ IDT valid → handled → OK
       │
       └─ IDT invalid → Double Fault
                │
                └─ Double Fault cannot handle → Triple Fault
                          │
                          └─ CPU reset / halt
```

---

💡 **Key Idea:** Triple fault is **a safety mechanism**.

* Prevents CPU from continuing in corrupted state.
* Usually occurs **very early in boot**, before OS takes control.

---


Perfect 🔥 let’s go over **how UEFI boot works** from power-on to OS start.

---

# 🖥 UEFI Boot Process

UEFI replaces legacy BIOS + MBR boot. It directly understands **GPT disks** and can boot 32-bit or 64-bit OSes.

---

## 1️⃣ Power-On & Firmware Initialization

* CPU starts in **real mode (16-bit)**
* UEFI firmware initializes:

  * CPU
  * RAM
  * Peripherals (keyboard, storage, network)
* Performs **POST** (Power-On Self Test)
* Checks for **UEFI boot entries** in NVRAM

---

## 2️⃣ Locate EFI System Partition (ESP)

* UEFI reads **GPT** → finds ESP partition (FAT32)
* ESP contains `.efi` bootloaders:

  * Windows: `\EFI\Microsoft\Boot\bootmgfw.efi`
  * Linux: `\EFI\ubuntu\grubx64.efi`
* UEFI picks bootloader according to **BootOrder** in NVRAM

---

## 3️⃣ Load EFI Bootloader

* UEFI loads `.efi` file into RAM
* Passes **firmware info, memory map, CPU features** to bootloader
* CPU may switch to **protected mode / long mode** if `.efi` is 64-bit

---

## 4️⃣ Bootloader Stage (e.g., GRUB)

* Reads **boot configuration** (`grub.cfg`) from ESP
* Shows boot menu for multiple OSes
* Loads **OS kernel + initramfs** from GPT partitions
* Sets up temporary **page tables, stack, and CPU state**

---

## 5️⃣ OS Kernel Takeover

* Kernel decompresses itself into high memory
* Initializes:

  * CPU features & interrupts
  * Paging → full virtual memory
  * Drivers and devices
* Mounts root filesystem from GPT partition
* Starts `init` / `systemd` → full OS operational

---

## 6️⃣ Optional UEFI Features

* **Secure Boot:** verifies `.efi` signature before execution
* **Network boot:** UEFI can boot from PXE or HTTP
* **Boot from multiple ESPs:** firmware can try alternates if primary fails

---

# 🔹 Key Points

| Feature             | Description                                 |
| ------------------- | ------------------------------------------- |
| Bootloader location | EFI System Partition (FAT32)                |
| Partition scheme    | GPT                                         |
| CPU mode            | 32-bit or 64-bit long mode                  |
| Recovery            | Backup GPT + multiple boot entries in NVRAM |
| Secure boot         | Optional cryptographic verification         |

---

# 🔹 End-to-End Flow

```
Power ON → UEFI Firmware → Read GPT → Find ESP
      │
      ▼
Load .EFI bootloader (GRUB/Windows)
      │
      ▼
Bootloader sets CPU + loads kernel
      │
      ▼
Kernel initializes → Mount root → Start init
      │
      ▼
Linux/Windows OS running
```

---

💡 **Takeaway:** UEFI + GPT eliminates MBR limits, supports multi-boot, and can automatically recover from partition or bootloader issues.

---



Perfect 🔥 now let’s see **dual-boot with UEFI + GPT + GRUB**, step by step.

---

# 🖥 UEFI + GRUB + GPT Dual-Boot Flow (Linux + Windows)

---

## 1️⃣ Disk Layout (GPT)

Typical GPT dual-boot disk:

```
Sector 0      → Protective MBR
Sector 1      → GPT Header (primary)
Sector 2+     → Partition entries
Partition 1   → EFI System Partition (ESP, FAT32)
Partition 2   → Windows C: (NTFS)
Partition 3   → Linux root (ext4)
Partition 4   → Linux swap (optional)
Partition N   → Backup GPT header + entries
```

* **ESP** stores all bootloaders:

  * `/EFI/Microsoft/Boot/bootmgfw.efi` → Windows
  * `/EFI/ubuntu/grubx64.efi` → Linux GRUB

---

## 2️⃣ UEFI Boot Firmware

* Reads **GPT header → partition table**
* Finds **ESP**
* Checks **NVRAM BootOrder**: which EFI file to load first
* Loads **GRUB EFI binary** into memory (if Linux first)

---

## 3️⃣ GRUB Stage (Linux)

* GRUB reads **`grub.cfg`** from ESP
* Detects **other OSes** automatically via `os-prober` (Windows bootloader)
* Presents **menu**:

```
1) Ubuntu Linux
2) Windows Boot Manager
```

* CPU already in **protected/long mode**, paging enabled

---

## 4️⃣ Booting Linux from GRUB

1. GRUB loads Linux kernel + initramfs from GPT Linux partition
2. Sets up **page tables, GDT, stack**
3. Kernel initializes devices, mounts root filesystem
4. Starts **`init` / `systemd` → OS ready**

---

## 5️⃣ Booting Windows from GRUB

1. GRUB chainloads Windows bootloader (`bootmgfw.efi`) from ESP
2. Windows EFI bootloader takes over → initializes kernel
3. Windows sets up **virtual memory, GDT, drivers**
4. Windows OS starts normally

> Chainloading = GRUB jumps to another bootloader without modifying it

---

## 6️⃣ Recovery & Safety

* If Linux ESP or GRUB is corrupted → UEFI can boot Windows directly from ESP
* Backup GPT ensures partitions are still visible even if primary GPT damaged
* Multiple `.efi` files in ESP → redundancy

---

## 🔹 Mental Picture

```
Power ON
   │
   ▼
UEFI → Reads GPT → Locate ESP
   │
   ▼
Load GRUB EFI
   │
   ▼
GRUB menu → choose Linux or Windows
   │
   ├─ Linux: Load kernel + initramfs → Kernel → OS
   │
   └─ Windows: Chainload bootmgfw.efi → Kernel → OS
```

---

## ⚡ Key Points

* **ESP centralizes bootloaders** → no MBR hack needed
* **GRUB detects Windows automatically**
* **Chainloading** ensures each OS maintains its own loader
* **GPT + UEFI + NVRAM** provides recovery options if one OS fails

---

Perfect 🔥 let’s break down **how GPT uses CRC32 checksums** for protection.

---

# 🧱 CRC32 in GPT (GUID Partition Table)

GPT has **two main structures that use CRC32**:

1. **GPT Header**
2. **Partition Entry Array**

CRC32 ensures **data integrity**, detecting accidental corruption.

---

## 1️⃣ GPT Header CRC32

* GPT Header contains metadata like:

  * Disk GUID
  * Location of partition entries
  * Number of entries
  * Size of each entry
* Field: `Header CRC32` → checksum of the **header itself** (excluding this field)
* During boot:

  1. UEFI reads GPT header
  2. Computes CRC32 of header
  3. Compares with stored CRC32
  4. Mismatch → header corrupted → uses **backup GPT header**

---

## 2️⃣ Partition Entry Array CRC32

* Partition entries describe each partition: type, start/end sectors, GUID, attributes
* GPT header stores **`Partition Entry Array CRC32`**
* Steps:

  1. Compute CRC32 of entire partition table array
  2. Compare with value in GPT header
  3. Detects **entry corruption** → UEFI can restore from backup

---

## 3️⃣ Backup GPT

* GPT keeps **primary header at LBA1**, **backup header at last LBA**
* If **primary header CRC fails**, UEFI reads backup → restores primary header

---

## 4️⃣ How CRC32 Works (Quick)

* **CRC32 = cyclic redundancy check, 32-bit**
* Detects **bit flips / small errors**
* CPU computes CRC32 by treating data as polynomial → fast hardware/software routines
* Example: if one bit changes → CRC32 mismatch

---

## 🔹 Mental Picture

```
[GPT Header] ── CRC32 check ──> OK?
    │ Yes → continue
    │ No  → use backup GPT
[Partition Table] ── CRC32 check ──> OK?
    │ Yes → partitions valid
    │ No  → restore from backup
```

---

## ⚡ Key Points

* CRC32 in GPT **prevents boot errors from disk corruption**
* UEFI can **auto-recover using backup GPT**
* Protects **header + partition entries separately**
* Essential for **dual-boot safety** and modern disks >2TB

---

Perfect 🔥 now let’s break down **how UEFI + GPT + CRC32 + backup header ensures safe boot**, even when part of the disk is corrupted.

---

# 🖥 Safe Boot with GPT & UEFI

GPT includes **redundancy and checksums** so UEFI can recover from partial disk corruption.

---

## 1️⃣ GPT Redundancy

* GPT keeps **two copies**:

  1. **Primary GPT header** → LBA 1 (immediately after MBR)
  2. **Backup GPT header** → last LBA of disk

* Both have a copy of the **partition entry array** and a **CRC32 checksum**

* If primary is corrupted, backup can restore it.

---

## 2️⃣ CRC32 Checksums

* **Header CRC32** → validates GPT header itself
* **Partition Array CRC32** → validates all partition entries
* UEFI computes CRC32 on read:

  * If checksum matches → header/table is valid
  * If mismatch → marks primary header corrupted → uses backup

---

## 3️⃣ Recovery Flow

1. UEFI reads **primary GPT header**
2. Computes **header CRC32** → fails?

   * Yes → reads **backup GPT header** from last sector
3. Computes **backup CRC32**

   * Backup valid → UEFI restores **primary GPT header + partition table**
   * Backup invalid → disk considered unbootable

---

## 4️⃣ Bootloader Safety

* Bootloader (e.g., GRUB) reads partitions using **validated GPT table**
* If partition entries are corrupted → GRUB can still attempt boot using backup table
* Ensures OS kernel can be loaded safely

---

## 5️⃣ Mental Picture

```
Read Primary GPT Header
      │
      ├─ CRC32 OK → use partitions → boot OS
      │
      └─ CRC32 FAIL → read Backup GPT Header
                │
                ├─ CRC32 OK → restore primary → boot OS
                │
                └─ CRC32 FAIL → disk unbootable
```

---

## ⚡ Key Points

* **Dual headers + CRC32 = auto-recovery mechanism**
* UEFI ensures **OS can boot even if part of disk is corrupted**
* Protects **partition table integrity**
* Critical for **dual-boot, large disks, and modern systems**

---

Perfect 🔥 now let’s break down **how GRUB interacts with GPT and UEFI during dual-boot recovery**, so Linux and Windows can still boot even if part of the GPT is corrupted.

---

# 🖥 GRUB + GPT + UEFI Recovery Flow

---

## 1️⃣ GRUB Location & GPT Awareness

* GRUB EFI binary lives in **ESP** (`/EFI/ubuntu/grubx64.efi`)
* When loaded, GRUB reads the **GPT partition table** to locate:

  * Linux root partition (ext4/ext3)
  * Windows bootloader (`bootmgfw.efi`)
* GRUB uses **UEFI firmware services** to read disk blocks safely.

---

## 2️⃣ Primary GPT Read

* GRUB first reads **primary GPT header** and **partition array**

* Performs **CRC32 checks** to validate integrity:

  * Header CRC32
  * Partition array CRC32

* ✅ If valid → GRUB knows exact location of OS partitions

---

## 3️⃣ Detecting Corruption

* If **primary GPT CRC32 fails**, GRUB requests **UEFI services** to read **backup GPT header** (last sector)
* Backup GPT header also has CRC32 for validation
* If backup valid → GRUB **restores primary GPT table in memory** (doesn’t overwrite disk yet)

---

## 4️⃣ Dual-Boot Recovery Logic

* GRUB detects available OSes from recovered GPT:

  * Linux kernel partitions
  * Windows bootloader partitions
* Even if **some partitions are corrupted**, GRUB can still show menu for intact OSes
* GRUB uses **chainloading** for Windows: jumps to Windows `.efi` file without modifying it

---

## 5️⃣ Safe Boot Example

```
Primary GPT read → CRC fail
      │
      ▼
Backup GPT read → CRC OK
      │
      ▼
Partition table restored in memory
      │
      ▼
GRUB detects OSes
      ├─ Linux → load kernel + initramfs
      └─ Windows → chainload bootmgfw.efi
```

* OS can boot safely even if **primary GPT header or some partitions** are corrupted.

---

## 6️⃣ Key Points

| Feature            | Description                                                     |
| ------------------ | --------------------------------------------------------------- |
| GPT redundancy     | Primary + backup header protects partition info                 |
| CRC32 checks       | Detect corruption reliably                                      |
| UEFI services      | GRUB relies on firmware for safe disk access                    |
| Chainloading       | Ensures Windows bootloader runs intact                          |
| Memory restoration | GRUB restores GPT table in memory even if disk header corrupted |

---

💡 **Takeaway:**

* GRUB + UEFI + GPT create **robust dual-boot recovery**
* Even partial corruption won’t prevent boot if **backup GPT + ESP bootloaders are intact**
* Linux and Windows can co-exist safely without overwriting each other

---
Perfect 🔥 here’s a **full end-to-end dual-boot CPU + boot flow diagram** combining real mode → protected mode → long mode → paging → GRUB → Linux/Windows kernel.

---

# 🖥 Dual-Boot CPU + Boot Flow (UEFI + GPT + GRUB + Linux/Windows)

```
Power ON / Reset
      │
      ▼
CPU starts in 16-bit Real Mode
      │
      ├─ Executes reset vector (0xFFFFFFF0)
      ├─ Initializes minimal CPU state
      ├─ Firmware (UEFI) begins POST
      │
      ▼
UEFI Firmware Initialization
      │
      ├─ Detects CPU features
      ├─ Initializes RAM & peripherals
      ├─ Reads GPT headers (primary + backup)
      │    └─ Validates CRC32 checksums
      ├─ Finds EFI System Partition (ESP)
      ├─ Loads selected .EFI bootloader (GRUB or Windows)
      │
      ▼
GRUB EFI Bootloader (64-bit)
      │
      ├─ CPU now in Protected Mode / Long Mode
      ├─ Paging enabled → virtual memory active
      ├─ Reads GPT partition table from ESP
      ├─ Validates CRC32 → restores from backup if needed
      ├─ Detects available OSes (Linux & Windows)
      ├─ Presents boot menu
      │
      ▼
Boot Path 1: Linux
      │
      ├─ GRUB loads Linux kernel + initramfs
      ├─ Sets up page tables, GDT, stack
      ├─ Kernel initializes devices, drivers
      ├─ Mounts root filesystem from ext4/ext3 GPT partition
      └─ Starts init/systemd → Linux OS ready

Boot Path 2: Windows
      │
      ├─ GRUB chainloads Windows EFI bootloader (bootmgfw.efi)
      ├─ Windows EFI bootloader sets up CPU & paging
      ├─ Loads Windows kernel + drivers
      └─ Windows OS ready
```

---

## 🔹 Key Highlights

* **CPU Modes**:

  * Real Mode → BIOS/UEFI early initialization
  * Protected Mode → 32-bit safe memory access
  * Long Mode → 64-bit, full virtual memory support
* **Paging**:

  * Enabled before kernel takeover
  * Provides memory isolation for each OS
* **GRUB + GPT**:

  * Handles dual-boot safely
  * Validates partition table CRC32
  * Can restore from backup GPT header
* **Chainloading**:

  * Windows bootloader runs intact, independent of Linux

---

💡 **Takeaway:**

* Even with partial GPT corruption or multi-boot disks, **UEFI + GRUB + GPT + CRC32 + backup** ensures safe boot.
* CPU transitions from **real → protected → long mode** seamlessly before kernel takes control.

---

Perfect 🔥 now let’s go **deep inside the CPU** during dual-boot, showing **memory and register changes** from power-on → Linux/Windows kernel start.

---

# 🖥 CPU Registers & Memory During Dual-Boot (UEFI + GRUB + GPT)

---

## 1️⃣ Power-On / Reset

**Mode:** Real Mode (16-bit)
**Registers / Memory:**

| Register | Value / Role                     |
| -------- | -------------------------------- |
| CS:IP    | 0xFFFF:0xFFF0 → reset vector     |
| SP       | small stack in low memory        |
| DS/ES/SS | default 16-bit segments          |
| CR0      | 0 (paging disabled, real mode)   |
| GDT/IDT  | not initialized                  |
| Memory   | BIOS area mapped (0x0000–0xFFFF) |

* CPU fetches instruction from **reset vector**
* Begins UEFI firmware execution

---

## 2️⃣ UEFI Initialization

**Mode:** Real → Protected Mode transition

| Step           | Changes                                     |
| -------------- | ------------------------------------------- |
| Setup stack    | SP points to safe RAM region                |
| Initialize GDT | Load segment descriptors for code/data      |
| IDT            | Prepare interrupt vectors                   |
| CR0            | Set PE bit = 1 → Protected Mode enabled     |
| CR4            | Set PAE (optional) if 64-bit support needed |
| Paging         | Not yet enabled (still identity-mapped)     |

* Firmware reads **GPT headers** and checks **CRC32**
* Finds **EFI System Partition** (ESP)

---

## 3️⃣ GRUB EFI Bootloader (64-bit)

**Mode:** Long Mode (x86_64)

| Register / Structure | Setup                                     |
| -------------------- | ----------------------------------------- |
| CR0                  | PE = 1, PG = 1 (paging enabled)           |
| CR3                  | Page table base address                   |
| CR4                  | PAE = 1, OSFXSR, PGE flags                |
| RSP                  | Stack pointer for 64-bit mode             |
| GDT                  | Flat 64-bit code/data segments            |
| IDT                  | Interrupt descriptor table for exceptions |

* GRUB loads **kernel + initramfs** from GPT Linux partition
* Restores **partition table from backup GPT** if needed
* Prepares CPU to jump to OS kernel

---

## 4️⃣ Linux Kernel Initialization

**Mode:** Long Mode, Paging Enabled

| Step          | Memory / Registers                                                     |
| ------------- | ---------------------------------------------------------------------- |
| CR0, CR3, CR4 | Already set, paging active                                             |
| Page tables   | Kernel sets up full 4-level x86_64 page tables (PML4 → PDPT → PD → PT) |
| Stack         | Kernel stack mapped in high memory                                     |
| GDT           | Kernel defines proper code/data/stack segments                         |
| Interrupts    | IDT updated with kernel exception handlers                             |
| Devices       | Kernel maps MMIO / I/O regions                                         |

* Root filesystem mounted → `/`
* `init` / `systemd` starts → OS fully operational

---

## 5️⃣ Windows Kernel Initialization (via GRUB chainload)

**Mode:** Long Mode, Paging Enabled

| Step                         | Memory / Registers                                |
| ---------------------------- | ------------------------------------------------- |
| GRUB jumps to `bootmgfw.efi` | CPU state: 64-bit, paging active                  |
| CR3                          | Windows page table base set                       |
| GDT                          | Windows loads own GDT for code/data               |
| Stack                        | Windows kernel stack initialized                  |
| Interrupts                   | IDT set to Windows exception handlers             |
| Kernel                       | Loads HAL, device drivers, virtual memory manager |

* OS fully boots independent of Linux

---

## 6️⃣ Memory / Stack Summary

```
Low Memory (<1MB) → real mode stack & BIOS data
High Memory (above 1MB) → protected/long mode stacks, kernel pages
Paging maps virtual addresses → linear 64-bit address space
GDT → defines segments for code, data, stack
IDT → defines interrupt/exception handlers
CR registers → control CPU mode & paging
```

---

## 🔹 Key Points

* **CR0/CR3/CR4** → control Protected Mode + Paging
* **GDT** → segment descriptors (flat for 64-bit OS)
* **IDT** → CPU exceptions / interrupts handled
* **Page tables** → full virtual memory mapping
* **Stack** → CPU uses different stacks for firmware, bootloader, and kernel

---

💡 **Takeaway:**

* CPU transitions smoothly: **real → protected → long mode → paging**
* GRUB + UEFI + GPT + CRC32 ensures **disk & bootloader safety**
* Linux and Windows kernels take over independent **registers and memory mapping**

---



Perfect 🔥 here’s a **complete visual diagram** showing **CPU registers, GDT, IDT, stacks, and paging** at each boot stage for a dual-boot system (UEFI + GRUB + Linux/Windows).

---

# 🖥 CPU & Memory Diagram for Dual-Boot

```
+---------------------------+
| Power ON / Reset          |
| Mode: Real (16-bit)       |
+---------------------------+
CS:IP → 0xFFFF:0xFFF0        <- reset vector
SP    → low memory stack
DS/ES/SS → default 16-bit segments
CR0   → 0 (paging disabled)
GDT   → none
IDT   → none
Memory → BIOS + ROM
```

↓

```
+---------------------------+
| UEFI Firmware Init        |
| Mode: Real → Protected    |
+---------------------------+
CS/DS/ES → updated for GDT
SP        → stack in RAM
GDT       → loaded for protected mode
IDT       → basic interrupts
CR0       → PE = 1 (Protected Mode)
CR4       → optional flags (PAE, OSFXSR)
Paging    → not yet enabled
Memory    → RAM initialized, GPT headers read
CRC32    → validate primary GPT, backup GPT ready
ESP      → .efi bootloader loaded
```

↓

```
+---------------------------+
| GRUB EFI Bootloader       |
| Mode: 64-bit Long Mode    |
+---------------------------+
CR0       → PE=1, PG=1 (paging enabled)
CR3       → page table base
CR4       → PAE=1, other long mode flags
GDT       → flat code/data/stack segments
IDT       → exception handlers set
RSP       → bootloader stack
Paging    → 4-level x86_64 tables (PML4→PDPT→PD→PT)
Memory    → virtual memory mapped
GPT       → validated via CRC32, backup used if needed
Boot menu → Linux / Windows
```

↓

```
+---------------------------+
| Linux Kernel Init         |
| Mode: 64-bit Long Mode    |
+---------------------------+
CR3       → kernel page table base
GDT       → kernel segments for code/data/stack
IDT       → kernel exception handlers
RSP       → kernel stack (high memory)
Paging    → full kernel virtual memory
Devices   → MMIO/I/O mapped
Root FS  → mounted from ext4 GPT partition
OS       → init/systemd starts
```

↓

```
+---------------------------+
| Windows Kernel Init       |
| (via GRUB chainload)      |
| Mode: 64-bit Long Mode    |
+---------------------------+
CR3       → Windows page table base
GDT       → Windows code/data segments
IDT       → Windows exception handlers
RSP       → Windows kernel stack
Paging    → full virtual memory for OS
Devices   → drivers initialized
OS       → Windows booted
```

---

## 🔹 Key Legend

* **CR0 / CR3 / CR4** → control CPU mode and paging
* **GDT** → segments (code/data/stack) for each stage
* **IDT** → interrupt/exception handlers
* **RSP / SP** → stage-specific stack
* **Paging** → virtual memory mapping
* **GPT + CRC32 + Backup** → protects boot and partitions

---

💡 **Takeaways**

* CPU transitions: **Real → Protected → Long Mode → Paging**
* GRUB validates GPT CRC32 and can restore from backup
* Each OS kernel uses its **own GDT, IDT, paging, and stack**
* Dual-boot is safe even if **primary GPT header or partition table is partially corrupted**

---


Here is the clear step-by-step flow of **how UEFI reads GPT during boot**.

---

# 🖥 How UEFI Reads GPT During Boot

## 1️⃣ Power On

* CPU starts executing firmware (UEFI)
* UEFI initializes RAM and disk controller
* Disk becomes readable

---

## 2️⃣ Read LBA 0 (Protective MBR)

UEFI reads:

```
LBA 0  → Protective MBR
```

Purpose:

* Protect GPT disk from old MBR tools
* Contains one partition entry of type `0xEE`
* Points to entire disk

If 0xEE exists → disk is GPT

---

## 3️⃣ Read Primary GPT Header

UEFI reads:

```
LBA 1 → GPT Header
```

Inside GPT Header:

* Signature = "EFI PART"
* Revision
* Header size
* CRC32 checksum
* Current LBA
* Backup header LBA
* First usable LBA
* Last usable LBA
* Starting LBA of partition entries
* Number of partition entries
* Size of each entry
* CRC32 of partition array

UEFI verifies:

* Signature correct?
* Header CRC32 valid?

If invalid → try backup header.

---

## 4️⃣ Read Partition Entry Array

From header field:

```
PartitionEntryLBA → usually LBA 2
```

UEFI reads multiple LBAs containing:

Each entry (128 bytes typically):

* Partition Type GUID
* Unique Partition GUID
* First LBA
* Last LBA
* Attributes
* Partition Name (UTF-16)

Then:

* Calculate CRC32 of full partition array
* Compare with header value
* If mismatch → try backup table

---

## 5️⃣ Locate EFI System Partition (ESP)

UEFI scans entries for:

```
Partition Type GUID = EFI System Partition
```

When found:

* Reads starting LBA
* Mounts it as FAT32
* Looks for:

```
/EFI/BOOT/BOOTX64.EFI
or
Boot entries stored in NVRAM
```

---

## 6️⃣ Load Bootloader

UEFI:

* Loads .EFI file into memory
* Sets up stack
* CPU already in 64-bit mode
* Paging active
* Jumps to EFI executable entry point

Bootloader (like GRUB or Windows Boot Manager) takes over.

---

# 🔁 What If Primary GPT Is Corrupted?

UEFI:

1. Reads backup GPT header (last LBA of disk)
2. Verifies its CRC32
3. Uses backup partition array
4. Can rebuild primary header automatically

This is why GPT is resilient.

---

# 📦 Disk Layout Example

```
LBA 0      → Protective MBR
LBA 1      → Primary GPT Header
LBA 2–33   → Partition Entries
...
Last-33    → Backup Partition Entries
Last LBA   → Backup GPT Header
```

---

# 🧠 Important

UEFI does NOT use:

* Real mode
* BIOS interrupts
* MBR boot code

It directly reads disk sectors using firmware drivers and parses GPT structures.

---

Here’s what happens if the **GPT header is corrupted** during boot.

---

# 🧱 GPT Has Two Headers (Redundancy)

GPT stores:

```
LBA 1          → Primary GPT Header
Last LBA       → Backup GPT Header
```

Both contain:

* Disk GUID
* Partition entry location
* CRC32 checksums
* Pointer to each other

---

# 🔍 Step-by-Step: What UEFI Does

## 1️⃣ UEFI Reads Primary Header (LBA 1)

It checks:

* Signature = `"EFI PART"`
* Header CRC32
* Partition table CRC32

If valid → continue boot normally.

If corrupted → move to backup header.

---

## 2️⃣ UEFI Reads Backup Header (Last LBA)

It verifies:

* Signature
* CRC32 checksum
* Partition array checksum

If backup is valid:

* UEFI uses backup partition table
* Boot continues normally
* Some systems rebuild primary automatically

You usually don’t notice anything.

---

# ⚠️ If Both Headers Are Corrupted

Then:

* UEFI cannot trust partition layout
* Disk may not appear bootable
* OS may not see partitions
* Manual repair required

---

# 🔁 How Linux Repairs It

Using tools like:

* `gdisk`
* `parted`

Linux can:

* Detect mismatch between primary and backup
* Rebuild damaged header
* Rewrite correct CRC32
* Restore proper GPT structure

---

# 🧠 Why GPT Is Safe

GPT protects itself using:

1. **Primary + Backup headers**
2. **CRC32 checksums**
3. **Separate partition array CRC**

So even if:

* Power loss
* Bad sector
* Partial disk overwrite

System can often recover automatically.

---

# 💡 Quick Summary

| Situation         | Result                    |
| ----------------- | ------------------------- |
| Primary corrupted | Backup used automatically |
| Backup corrupted  | Primary used              |
| Both corrupted    | Manual recovery needed    |

---
Good — this is important. Let’s go deep and practical.

We’ll cover:

1️⃣ What happens if the GPT **partition entry array** is corrupted
2️⃣ How recovery actually works internally
3️⃣ Step-by-step safe manual repair (Linux)

---

# 🧱 1️⃣ What Is the Partition Entry Array?

GPT layout:

```
LBA 0      → Protective MBR
LBA 1      → Primary GPT Header
LBA 2–33   → Partition Entry Array (Primary)
...
Last-33    → Partition Entry Array (Backup)
Last LBA   → Backup GPT Header
```

The **header** describes the disk.

The **partition entry array** contains actual partitions:

Each entry (usually 128 bytes):

* Partition Type GUID
* Unique GUID
* First LBA
* Last LBA
* Attributes
* Name

The header stores a **CRC32 of the entire partition array**.

---

# 🚨 2️⃣ What If Partition Entry Array Is Corrupted?

## Case A — Primary array corrupted

UEFI does:

1. Read primary header
2. CRC header OK
3. Read partition array
4. CRC mismatch ❌

Then:

* UEFI reads **backup partition array**
* Verifies backup CRC
* Uses backup copy
* Boot continues normally

You may not notice anything.

---

## Case B — Backup array corrupted

System uses primary.

Still boots normally.

---

## Case C — Both arrays corrupted

Now serious:

* Header CRC may still be valid
* But partition array CRC fails
* UEFI cannot trust partitions
* Disk may appear empty
* OS may show “unallocated”

Data may still exist on disk — just partition metadata damaged.

---

# 🔎 3️⃣ What Actually Gets Damaged?

Common causes:

* Power loss during partitioning
* Disk write interruption
* Bad sectors
* Accidental `dd` overwrite
* Malware
* Wrong disk write (e.g., writing MBR tools to GPT disk)

Usually:

* Partition data still exists
* Only metadata (GUID entries) damaged

That means recovery is possible.

---

# 🛠 4️⃣ Manual Repair – SAFE Procedure (Linux)

⚠️ First rule: **Do NOT write anything until you inspect.**

---

## Step 1 — Inspect Disk

```
sudo gdisk /dev/sdX
```

If damaged, you may see:

* “Primary table corrupt”
* “Backup table corrupt”
* CRC mismatch warning

`gdisk` is smart. It compares:

* Primary header
* Backup header
* Primary array
* Backup array

---

## Step 2 — Enter Recovery Mode

Inside gdisk:

```
r
```

Recovery options appear.

---

## Step 3 — Common Repairs

### 🔹 Rebuild primary from backup

If primary array damaged:

```
b
```

(Rebuild main header from backup)

Then:

```
w
```

Write changes.

---

### 🔹 Rebuild backup from primary

If backup damaged:

```
d
```

(Rebuild backup from primary)

Then:

```
w
```

---

### 🔹 Verify CRC

```
v
```

Verifies:

* Header CRC
* Partition array CRC
* Logical consistency

---

# 🧠 What gdisk Actually Does Internally

It:

1. Reads both headers
2. Compares disk GUID
3. Compares partition arrays
4. Selects most valid structure
5. Recalculates CRC32
6. Rewrites damaged copy

No partition data sectors are touched.

Only GPT metadata LBAs are rewritten.

---

# 🔬 Advanced Case — Both Arrays Corrupted

If both partition arrays are damaged:

Now you must reconstruct manually.

Options:

### Option 1 — Use `testdisk`

It scans disk for:

* NTFS signatures
* ext4 superblocks
* FAT32 headers

Then reconstructs partitions based on detected filesystem boundaries.

---

### Option 2 — Manual Reconstruction

If you know:

* Start LBA
* End LBA

You can recreate partitions in `gdisk`:

```
n
```

Add partition manually with same start/end.

As long as you use same sector range:

👉 Filesystem will mount normally.

Because filesystem data was never deleted.

---

# 💣 When Data Is Truly Lost

If BOTH:

* GPT array corrupted
* Filesystem superblock corrupted

Then recovery becomes forensic-level.

---

# 🧬 Why GPT Is Stronger Than MBR

| Feature             | MBR  | GPT             |
| ------------------- | ---- | --------------- |
| Backup copy         | ❌    | ✅               |
| CRC protection      | ❌    | ✅               |
| Partition limit     | 4    | 128+            |
| Corruption recovery | Hard | Often automatic |

---

# 📌 Real-World Example

Power loss during partition resize.

Result:

* Primary array half-written
* CRC mismatch

System boot:

* UEFI detects CRC error
* Uses backup array
* System boots
* You repair primary later

No data lost.

---

# 🛡 SAFETY RULES

Always:

1. Backup GPT before editing:

   ```
   sudo sgdisk --backup=gpt.bin /dev/sdX
   ```

2. Never use `dd` blindly

3. Never run old MBR tools on GPT disk

4. Always verify disk name (`lsblk` first)

---

# 🧠 Final Summary

If partition entry array is corrupted:

| Situation           | Result               |
| ------------------- | -------------------- |
| Primary damaged     | Backup used          |
| Backup damaged      | Primary used         |
| Both damaged        | Manual repair        |
| Data sectors intact | High recovery chance |

GPT is designed for resilience.

---

Good. Let’s go precise and low-level.

We’ll cover:

1️⃣ What CRC32 GPT uses
2️⃣ Exactly what bytes are included
3️⃣ How it is calculated
4️⃣ How UEFI validates it

---

# 1️⃣ Which CRC32 Algorithm GPT Uses

GPT uses:

**CRC32 (IEEE 802.3 standard)**

Polynomial (reversed form used in software):

```
0xEDB88320
```

Initial value:

```
0xFFFFFFFF
```

Final step:

```
XOR with 0xFFFFFFFF
```

Little-endian storage on disk.

---

# 2️⃣ What GPT Protects With CRC32

GPT calculates CRC32 for:

### A) GPT Header

Field: `HeaderCRC32`

Important rule:

When calculating header CRC:

👉 The HeaderCRC32 field itself must be set to 0 during calculation.

---

### B) Partition Entry Array

Field in header: `PartitionEntryArrayCRC32`

This CRC is over:

```
NumberOfEntries × SizeOfEntry
```

Example:

* 128 entries
* 128 bytes each

Total bytes hashed:

```
128 × 128 = 16384 bytes
```

---

# 3️⃣ Exact Byte-Level Process

Let’s say we compute CRC for partition array.

### Step 1 — Read Raw Bytes

From disk:

```
Start LBA = PartitionEntryLBA
Read N sectors
Total size = Entries × EntrySize
```

No interpretation.
No skipping.
Raw binary.

---

### Step 2 — Initialize CRC

```
crc = 0xFFFFFFFF
```

---

### Step 3 — For Each Byte

For each byte:

```
crc = crc ^ byte
repeat 8 times:
    if (crc & 1)
        crc = (crc >> 1) ^ 0xEDB88320
    else
        crc = crc >> 1
```

---

### Step 4 — Finalize

```
crc = crc ^ 0xFFFFFFFF
```

Store as 4-byte little-endian.

---

# 4️⃣ Header CRC Calculation Details

When computing header CRC:

1. Read header size from header field.
2. Copy only `HeaderSize` bytes.
3. Set HeaderCRC32 field = 0.
4. Compute CRC on that buffer.
5. Compare result with stored CRC.

Important:

GPT header may not occupy entire sector.
Only `HeaderSize` bytes are hashed.

---

# 5️⃣ How UEFI Validates GPT

UEFI process:

### Step A — Read Primary Header (LBA 1)

* Check signature = "EFI PART"
* Save stored CRC
* Zero header CRC field
* Compute new CRC
* Compare

If mismatch → header invalid.

---

### Step B — Validate Partition Array

* Read array LBAs
* Compute CRC
* Compare with header value

If mismatch → array invalid.

---

### Step C — If Invalid

UEFI:

* Reads backup header (last LBA)
* Validates its CRC
* Validates its partition array CRC
* Uses backup if valid

---

# 6️⃣ Why CRC32 Works Well Here

CRC32 detects:

* Single-bit errors
* Multi-bit errors
* Burst errors up to 32 bits
* Most accidental corruption

It is fast.
Firmware-friendly.
Low CPU cost.

---

# 7️⃣ Important Subtle Detail

CRC protects:

✅ Metadata (header + partition entries)
❌ It does NOT protect partition contents

If filesystem data is corrupted, GPT CRC will still be valid.

---

# 8️⃣ Example Corruption Scenario

Power loss during partition resize:

* Half of partition array written
* CRC stored updated
* Write interrupted

On next boot:

* Calculated CRC ≠ stored CRC
* Primary array rejected
* Backup array used
* Boot continues

That is GPT resilience design.

---

# 9️⃣ Why Header CRC Is Separate From Array CRC

Because:

* Header may be intact
* Partition array may be damaged
* Or vice versa

Separate CRC allows granular validation.

---

# 🔎 Final Mental Model

GPT uses CRC32 like this:

```
CRC(Header_without_crc_field)
CRC(FullPartitionArrayRawBytes)
```

If either fails → try backup copy.

Simple.
Deterministic.
Robust.

---

Perfect — let’s do a **real hex-level example** of a GPT header and see exactly how CRC32 is computed.

---

# 1️⃣ Example GPT Header (Hex Dump)

Assume sector size = 512 bytes
GPT header at **LBA 1**

Example (first 92 bytes = typical HeaderSize):

```
45 46 49 20 50 41 52 54    ← "EFI PART"
00 00 01 00                ← Revision (1.0)
5C 00 00 00                ← HeaderSize = 0x5C (92 bytes)
AA BB CC DD                ← HeaderCRC32 (placeholder)
00 00 00 00                ← Reserved (must be zero)
01 00 00 00 00 00 00 00    ← Current LBA
FF 3F 00 00 00 00 00 00    ← Backup LBA
22 00 00 00 00 00 00 00    ← First Usable LBA
DE 3F 00 00 00 00 00 00    ← Last Usable LBA
11 22 33 44 55 66 77 88
99 AA BB CC DD EE FF 00    ← Disk GUID (16 bytes)
02 00 00 00 00 00 00 00    ← PartitionEntryLBA
80 00 00 00                ← NumberOfEntries (128)
80 00 00 00                ← SizeOfEntry (128)
12 34 56 78                ← PartitionArrayCRC32
```

---

# 2️⃣ Rule Before Calculating Header CRC

👉 The `HeaderCRC32` field must be set to **00 00 00 00** before calculation.

So replace:

```
AA BB CC DD
```

with:

```
00 00 00 00
```

Now we compute CRC over:

```
First 92 bytes only (HeaderSize)
```

NOT full 512 bytes.

---

# 3️⃣ CRC32 Algorithm Used by GPT

Standard IEEE CRC32:

* Polynomial (reversed): `0xEDB88320`
* Initial value: `0xFFFFFFFF`
* Final XOR: `0xFFFFFFFF`
* Process byte-by-byte
* Little-endian result stored

---

# 4️⃣ Manual CRC Example (Small Demonstration)

To show how it works, let’s compute CRC over just:

```
45 46 49 20
```

(ASCII "EFI ")

### Step 1 — Initialize

```
crc = 0xFFFFFFFF
```

---

### Step 2 — Process First Byte (0x45)

```
crc = crc ^ 0x45
```

Then repeat 8 bit shifts:

If LSB = 1:

```
crc = (crc >> 1) ^ 0xEDB88320
```

Else:

```
crc = crc >> 1
```

Repeat for each of 8 bits.

Then move to next byte.

---

### Step 3 — After All Bytes

```
crc = crc ^ 0xFFFFFFFF
```

That final value is stored in header.

---

# 5️⃣ Realistic Result (Full 92 Bytes)

If we computed CRC over the full example header (with CRC field zeroed), we might get something like:

```
3F A2 1C 7B
```

Stored in little-endian:

```
7B 1C A2 3F
```

That replaces the zero field in header.

---

# 6️⃣ How UEFI Validates It

On boot:

1. Read header
2. Save stored CRC
3. Set CRC field to zero
4. Recompute CRC over HeaderSize bytes
5. Compare with stored value

If equal → header valid
If not → header rejected

---

# 7️⃣ Partition Array CRC Example

If:

```
128 entries × 128 bytes = 16384 bytes
```

UEFI reads all 16384 raw bytes and runs same CRC32 algorithm.

Compare result to `PartitionArrayCRC32`.

---

# 8️⃣ Why This Works

CRC32 detects:

* Bit flips
* Partial writes
* Sector corruption
* Truncated partition tables

Very fast for firmware.
Very reliable for metadata integrity.

---

# 9️⃣ Important Technical Detail

GPT stores CRC as **little-endian** because x86 systems are little-endian.

So if computed CRC is:

```
0x7B1CA23F
```

Disk stores:

```
3F A2 1C 7B
```

---

# 🧠 Final Mental Model

For GPT header:

```
1. Zero CRC field
2. Hash HeaderSize bytes
3. XOR final with 0xFFFFFFFF
4. Store little-endian
```

For partition array:

```
1. Hash raw partition entries
2. Store result in header
```

---



Good — we’ll do this **safely in a VM using a disk image**, not a real disk.

⚠️ Never test on your real `/dev/sda`.

---

# 🧪 Goal

We will:

1. Create a fake disk image
2. Make GPT on it
3. Corrupt GPT header manually
4. Observe CRC failure
5. Repair it

All inside a VM or normal Linux system.

---

# 1️⃣ Create Fake Disk Image

Create 100MB file:

```bash
dd if=/dev/zero of=gpt-test.img bs=1M count=100
```

Attach it as loop device:

```bash
sudo losetup -fP gpt-test.img
```

Find loop name:

```bash
losetup -a
```

Example result:

```
/dev/loop0
```

---

# 2️⃣ Create GPT Table

```bash
sudo parted /dev/loop0 mklabel gpt
```

Create a test partition:

```bash
sudo parted /dev/loop0 mkpart primary ext4 1MiB 50MiB
```

Now check:

```bash
sudo gdisk -l /dev/loop0
```

Everything should be clean.

---

# 3️⃣ Corrupt Primary GPT Header

Primary GPT header is at:

```
LBA 1
```

Sector size usually 512 bytes.

So offset =

```
1 × 512 = 512 bytes
```

Let’s overwrite 1 byte inside header:

```bash
sudo dd if=/dev/zero of=/dev/loop0 bs=1 seek=520 count=1 conv=notrunc
```

This modifies header slightly without destroying whole disk.

---

# 4️⃣ Now Check GPT

Run:

```bash
sudo gdisk -l /dev/loop0
```

You should see something like:

```
CRC mismatch
Primary header invalid
Using backup header
```

🎉 You successfully triggered GPT CRC failure.

---

# 5️⃣ What Just Happened Internally

UEFI / gdisk logic:

1. Read primary header
2. Compute CRC
3. Mismatch detected
4. Read backup header (last LBA)
5. Backup valid
6. Use backup instead

Exactly how GPT is designed to work.

---

# 6️⃣ Repair the GPT

Run:

```bash
sudo gdisk /dev/loop0
```

Inside gdisk:

```
v
```

(verify)

It will report mismatch.

Then:

```
w
```

Write corrected table.

Now check again:

```bash
sudo gdisk -l /dev/loop0
```

CRC should be clean again.

---

# 7️⃣ If You Want to Corrupt Partition Array Instead

Primary partition array usually starts at:

```
LBA 2
```

Corrupt it:

```bash
sudo dd if=/dev/zero of=/dev/loop0 bs=512 seek=2 count=1 conv=notrunc
```

Now run `gdisk` again.

You will see:

```
Partition table CRC mismatch
Using backup partition table
```

---

# 8️⃣ Restore Loop Device

When finished:

```bash
sudo losetup -d /dev/loop0
rm gpt-test.img
```

---

# 🧠 What You Learned

* GPT header CRC protects header
* Partition array CRC protects entries
* Backup copy allows automatic recovery
* Corruption does NOT destroy data immediately
* Metadata recovery is separate from filesystem recovery

---
Good question — this is about **design tradeoffs**, not security.

---

# 🔎 Why GPT Uses CRC32 Instead of SHA256

## 1️⃣ GPT Needs Error Detection, Not Security

GPT’s goal:

* Detect accidental corruption
* Detect partial writes
* Detect bad sectors
* Detect power-loss damage

It does **NOT** need:

* Cryptographic security
* Tamper resistance
* Collision resistance against attackers

CRC32 is perfect for accidental error detection.

SHA256 is designed for cryptographic security.

Different purpose.

---

# 2️⃣ Speed (Firmware Environment)

UEFI firmware runs:

* Very early
* Minimal memory
* Limited CPU state
* Sometimes no hardware acceleration

CRC32:

* Extremely fast
* Tiny implementation (~100 lines)
* Minimal RAM usage
* Easy to compute in firmware

SHA256:

* Much heavier
* More CPU cycles
* Larger code
* More memory

Firmware designers prefer simple + fast.

---

# 3️⃣ CRC32 Is Very Good at Detecting Disk Errors

CRC32 detects:

* All single-bit errors
* All double-bit errors
* Most burst errors under 32 bits
* Most accidental corruption patterns

For disk metadata protection, that’s enough.

The probability of random undetected error:

```
1 in 2^32 ≈ 1 in 4 billion
```

That’s already extremely low for metadata.

---

# 4️⃣ GPT Already Has Redundancy

GPT safety layers:

* Primary header
* Backup header
* Primary partition array
* Backup partition array
* CRC on header
* CRC on array

Because GPT has redundancy,
it does not require cryptographic hashing.

---

# 5️⃣ SHA256 Would Not Add Practical Benefit

If someone intentionally modifies GPT:

* They could recompute SHA256 anyway.
* GPT has no secure signature mechanism.

So SHA256 wouldn’t prevent malicious tampering.
It would only slow firmware.

Security belongs to:

* Secure Boot
* TPM
* Signed bootloaders

Not GPT.

---

# 6️⃣ Historical Context

GPT was standardized around early 2000s (UEFI spec).

At that time:

* CRC32 already widely used (Ethernet, ZIP, PNG)
* Hardware support common
* SHA256 was slower and heavier

Design choice favored efficiency.

---

# 7️⃣ Comparison

| Feature              | CRC32           | SHA256                  |
| -------------------- | --------------- | ----------------------- |
| Purpose              | Error detection | Cryptographic integrity |
| Speed                | Very fast       | Slower                  |
| Code size            | Small           | Large                   |
| Firmware-friendly    | Yes             | Less ideal              |
| Collision resistance | Low             | Extremely high          |
| Needed for GPT?      | Yes             | No                      |

---

# 🧠 Key Insight

GPT protects against:

👉 Accidental corruption

Not against:

👉 Malicious modification

For malicious protection, systems rely on:

* UEFI Secure Boot
* Signed EFI binaries
* Measured boot (TPM)

---

# 💡 Final Summary

CRC32 was chosen because:

* Fast
* Lightweight
* Perfect for detecting disk write errors
* Works well with backup header design
* No need for cryptographic strength

Using SHA256 would add complexity without meaningful benefit for GPT’s purpose.

---


Good — now we go into the limits of CRC32.

CRC32 is very good, but **not perfect**.

---

# 1️⃣ Mathematical Limitation

CRC32 produces a **32-bit result**.

That means:

```
2^32 possible CRC values
```

≈ 4,294,967,296 combinations.

If corrupted data accidentally produces the same CRC:

👉 corruption is not detected.

Probability for random error:

```
1 / 2^32  ≈ 1 in 4 billion
```

Very small — but not zero.

---

# 2️⃣ Collision Possibility

CRC is linear (not cryptographic).

That means:

If someone knows the algorithm, they can:

* Modify data
* Adjust other bytes
* Recalculate changes
* Produce same CRC

So CRC32 does NOT prevent intentional tampering.

It only detects accidental corruption.

---

# 3️⃣ Multi-Bit Structured Errors

CRC32 guarantees detection of:

* All 1-bit errors
* All 2-bit errors
* All burst errors ≤ 32 bits

But it does NOT guarantee detection of:

* Some rare long structured multi-bit patterns

Very unlikely, but mathematically possible.

---

# 4️⃣ Double Corruption Scenario

Imagine:

* Primary GPT corrupted
* Backup GPT corrupted
* Both corrupted in a way that still produce valid CRC

Extremely rare, but theoretically possible.

Then system would trust damaged metadata.

---

# 5️⃣ Partial Write With CRC Field Updated

Rare scenario:

1. Partition array partially overwritten
2. CRC field also overwritten with matching value
3. Power loss happens
4. Resulting corrupted array accidentally matches CRC

Extremely improbable — but possible.

---

# 6️⃣ Hardware Fault Edge Case

If:

* Disk controller returns wrong data
* RAM flips bit
* CPU computes CRC on corrupted memory
* Same corruption happens during validation

CRC check could pass incorrectly.

This is why:

* ECC RAM exists
* Enterprise disks use additional protection

---

# 7️⃣ Why This Is Acceptable

Because GPT also has:

* Primary copy
* Backup copy
* Separate CRC for header
* Separate CRC for partition array

To get undetected failure, multiple layers must fail in a specific pattern.

Probability becomes astronomically low.

---

# 8️⃣ Important: CRC vs Cryptographic Hash

CRC32 protects against:

✔ Random corruption
✔ Disk errors
✔ Power-loss damage

It does NOT protect against:

✖ Malicious manipulation
✖ Crafted collisions
✖ Advanced attacks

That’s Secure Boot’s job.

---

# 🧠 Realistic Risk Level

For accidental disk corruption:

CRC32 failure undetected rate ≈ practically negligible.

For malicious attack:

CRC32 offers no security guarantee.

---

# 💡 Final Understanding

CRC32 can fail in rare edge cases because:

* It is only 32 bits
* It is linear
* Collisions are possible
* It is not cryptographic

But combined with GPT redundancy, it is more than sufficient for disk metadata integrity.

---

Good — now we move from disk to firmware memory.

This is how **UEFI stores boot entries in NVRAM**.

---

# 1️⃣ What Is UEFI NVRAM?

NVRAM = **Non-Volatile RAM**

It is:

* Small persistent memory inside motherboard firmware
* Survives reboot and power off
* Stores firmware variables

It is NOT your SSD.
It is NOT your GPT disk.

It is inside firmware flash.

---

# 2️⃣ Where Boot Entries Are Stored

UEFI stores boot entries as **EFI variables**.

Main variables:

```
BootOrder
Boot####   (example: Boot0000, Boot0001)
BootNext
```

These are stored in NVRAM.

---

# 3️⃣ Structure of a Boot Entry (Boot####)

Example:

```
Boot0000
Boot0001
Boot0002
```

Each entry contains:

* Attributes (active/hidden)
* Description (UTF-16 string)
* Device Path
* EFI file path
* Optional data

---

# 4️⃣ What Is Inside a Boot Entry

Example conceptually:

```
Boot0001:
  Description: "Ubuntu"
  Device: GPT disk
  Partition GUID: XXXXX
  File: \EFI\ubuntu\grubx64.efi
```

Or Windows:

```
Boot0000:
  Description: "Windows Boot Manager"
  File: \EFI\Microsoft\Boot\bootmgfw.efi
```

Important:

UEFI stores the **device path**, not just filename.

It includes:

* Disk GUID
* Partition GUID
* Filesystem path

So it can locate the correct ESP.

---

# 5️⃣ BootOrder Variable

Example:

```
BootOrder = 0001,0000
```

This means:

1. Try Boot0001 first
2. If fails, try Boot0000

---

# 6️⃣ Boot Flow Using NVRAM

During boot:

1. UEFI reads BootOrder
2. Loads first Boot####
3. Locates device via stored device path
4. Mounts EFI System Partition
5. Loads .efi file
6. Transfers control

If fails → tries next entry.

---

# 7️⃣ BootNext Variable

Temporary override:

```
BootNext = 0002
```

Used for:

* One-time boot
* Reboot into installer
* Firmware update

After one boot → BootNext is deleted automatically.

---

# 8️⃣ How Linux Manages These Entries

Linux tool:

```
efibootmgr
```

View entries:

```
sudo efibootmgr -v
```

Create new entry:

```
sudo efibootmgr -c -d /dev/sda -p 1 \
-l '\EFI\linux\grubx64.efi' \
-L "Linux"
```

Delete entry:

```
sudo efibootmgr -b 0002 -B
```

This modifies NVRAM, not disk.

---

# 9️⃣ What If NVRAM Is Corrupted?

If boot entries are lost:

UEFI fallback mechanism:

It searches default path:

```
\EFI\BOOT\BOOTX64.EFI
```

On ESP.

This is why removable drives boot even without NVRAM entry.

---

# 🔟 Why This Design Is Powerful

Because:

* Boot configuration is independent of disk partition table
* Multiple OS entries can coexist
* Dual boot works cleanly
* No overwriting MBR like legacy BIOS

---

# 🧠 Key Distinction

GPT stores:

👉 Partition layout

NVRAM stores:

👉 Which EFI file to execute

ESP stores:

👉 Actual bootloader binaries

Three separate layers.

---

# 💡 Summary

UEFI boot entries:

* Stored in motherboard NVRAM
* Named Boot####
* Ordered by BootOrder
* Point to .efi files on ESP
* Managed by efibootmgr
* Fallback path exists if NVRAM fails

---

Good — now we go inside firmware logic.

This is how **UEFI parses the ESP (FAT32) filesystem** during boot.

---

# 1️⃣ First: UEFI Already Found ESP

Before parsing FAT32:

UEFI has already:

* Read GPT
* Found partition with type = EFI System Partition (ESP)
* Read its starting LBA

Now firmware knows:

```
Disk → Partition start → FAT32 filesystem
```

---

# 2️⃣ Read FAT32 Boot Sector

UEFI reads:

```
First sector of ESP
```

This contains FAT32 Boot Sector (BPB — BIOS Parameter Block).

Important fields:

* Bytes per sector (usually 512)
* Sectors per cluster
* Reserved sector count
* Number of FAT tables
* FAT size
* Root directory cluster

UEFI extracts:

```
Cluster size
FAT location
Root directory start cluster
```

---

# 3️⃣ FAT32 Layout (Simplified)

```
[ Boot Sector ]
[ Reserved Sectors ]
[ FAT Table 1 ]
[ FAT Table 2 ]
[ Data Region (Clusters) ]
```

UEFI needs:

* FAT table
* Root directory cluster

---

# 4️⃣ Understanding FAT32 Structure

FAT32 works with:

Clusters (not LBAs directly).

Each file:

* Stored in one or more clusters
* FAT table tells next cluster in chain

Example:

```
Cluster 5 → 8 → 12 → END
```

This is how file content is linked.

---

# 5️⃣ How UEFI Locates Bootloader File

UEFI must load:

Example:

```
\EFI\ubuntu\grubx64.efi
```

Step-by-step:

### 1️⃣ Start at Root Directory cluster

### 2️⃣ Scan directory entries

Each directory entry is 32 bytes:

Contains:

* Filename (8.3 format or long filename entries)
* Attributes
* First cluster number
* File size

### 3️⃣ Find folder "EFI"

Follow its cluster chain.

### 4️⃣ Inside EFI → find "ubuntu"

Follow cluster chain.

### 5️⃣ Inside ubuntu → find "grubx64.efi"

---

# 6️⃣ Reading File Data

Once file entry found:

Directory entry provides:

```
Starting Cluster
File Size
```

UEFI:

1. Looks up cluster in FAT table
2. Reads cluster data
3. If FAT says next cluster exists → follow
4. Continue until END marker

Data is loaded into RAM.

---

# 7️⃣ FAT32 Markers

FAT entry values:

```
0x00000000 → free cluster
0x0FFFFFFF → end of chain
Other value → next cluster number
```

UEFI follows this chain exactly.

---

# 8️⃣ Long File Name Support

Modern UEFI supports:

* VFAT long filename entries
* UTF-16 filenames

So it reconstructs:

```
BOOTX64.EFI
grubx64.efi
bootmgfw.efi
```

Even if stored as multiple directory entries.

---

# 9️⃣ After File Is Loaded

UEFI:

* Allocates memory
* Copies file content
* Parses PE/COFF header (Windows executable format)
* Sets up execution environment
* Jumps to entry point

Bootloader now running.

---

# 🔟 Why FAT32 Was Chosen

Because:

* Simple
* Very small implementation
* No journaling complexity
* No permissions
* No compression
* Very predictable structure

Firmware-friendly.

---

# 🧠 Important Limitation

UEFI only understands:

* FAT12
* FAT16
* FAT32

It does NOT understand:

* ext4
* NTFS (unless vendor adds driver)
* btrfs
* XFS

That’s why ESP must be FAT.

---

# 💡 Complete Boot Picture Now

1. GPT → find ESP
2. FAT32 → parse directories
3. Locate .efi file
4. Load file via cluster chain
5. Jump to executable entry

No BIOS interrupts.
No MBR boot code.
Pure filesystem parsing.

---

Good — now we move from **integrity (CRC)** to **cryptographic trust**.

GPT + CRC protects against accidental corruption.
**Secure Boot protects against malicious bootloader replacement.**

Very different layers.

---

# 🔐 What Secure Boot Actually Protects

Secure Boot ensures:

> Only cryptographically trusted EFI binaries can execute.

It protects:

* `grubx64.efi`
* `bootmgfw.efi`
* Linux kernel (if signed)
* Option ROM drivers

It does NOT protect:

* GPT layout
* Partition contents
* Filesystem data

---

# 🧱 Trust Chain (High Level)

```
UEFI Firmware (root of trust)
        ↓
Trusted Public Keys in NVRAM
        ↓
Verify EFI Bootloader Signature
        ↓
Bootloader verifies Kernel
        ↓
Kernel runs
```

Each stage verifies the next.

---

# 🔑 Keys Stored in Firmware (NVRAM)

Secure Boot uses several key databases:

### PK (Platform Key)

* Top-level authority
* Controls firmware ownership

### KEK (Key Exchange Keys)

* Allowed to update signature databases

### db (Allowed Signatures)

* List of trusted public keys or hashes

### dbx (Forbidden Signatures)

* Revoked binaries (blacklist)

All stored in firmware NVRAM.

---

# 🧾 How Verification Works

When UEFI loads:

```
\EFI\ubuntu\grubx64.efi
```

It:

1️⃣ Reads EFI file
2️⃣ Parses PE/COFF structure
3️⃣ Finds embedded digital signature
4️⃣ Extracts signing certificate
5️⃣ Checks if certificate matches a key in `db`
6️⃣ Checks not listed in `dbx`

If valid → execution allowed
If invalid → boot blocked

---

# 🧮 What Cryptography Is Used?

Typically:

* RSA 2048 or 4096
* SHA256 hashing
* X.509 certificates
* PKCS#7 signature format

This is real cryptographic verification.

Not CRC.
Not checksum.
Not hash comparison.

---

# 🔗 Example: Windows Boot

Firmware contains Microsoft key in `db`.

Flow:

1. UEFI loads `bootmgfw.efi`
2. Signature verified against Microsoft certificate
3. Execution allowed

If attacker replaces bootloader with modified file:

* Signature invalid
* Boot blocked

---

# 🐧 Example: Linux Boot

Linux uses:

* Microsoft-signed shim
* Shim verifies GRUB
* GRUB verifies kernel (if configured)

Chain:

```
Firmware → shim → GRUB → Linux kernel
```

Each stage signed.

---

# 🚫 What Happens If Signature Fails?

UEFI shows:

* "Secure Boot Violation"
* Or boot simply stops

No unsigned code runs.

---

# 🛡 Why This Is Stronger Than GPT CRC

| GPT CRC            | Secure Boot                      |
| ------------------ | -------------------------------- |
| Detects corruption | Detects tampering                |
| 32-bit checksum    | Cryptographic signature          |
| No identity        | Authenticated publisher          |
| Easy to recompute  | Cannot forge without private key |

---

# 🧠 Important Insight

Even if attacker:

* Modifies GPT
* Replaces ESP files
* Changes bootloader

They still cannot boot malicious code unless:

* They disable Secure Boot
* Or have signing key

---

# 🔄 How Secure Boot Interacts With GPT

GPT ensures:

👉 Correct partition layout

Secure Boot ensures:

👉 Correct bootloader authenticity

ESP (FAT32) ensures:

👉 File storage

Three independent protection layers.

---

# 💣 Limitations

Secure Boot does NOT protect:

* Kernel after boot (unless kernel lockdown enabled)
* Rootkits inside OS
* Disk encryption
* Runtime memory attacks

It only protects early boot stage.

---

# 🧠 Final Mental Model

Without Secure Boot:

```
UEFI → Load any EFI file → Execute
```

With Secure Boot:

```
UEFI → Verify signature → Execute only if trusted
```

That is cryptographic integrity beyond GPT.

---

Good — this is the key piece that makes Linux work with Secure Boot.

Because most firmware trusts **Microsoft’s key**, not random Linux keys.

So Linux uses **shim** as a bridge.

---

# 🔐 What Is shim?

`shimx64.efi` is a small, Microsoft-signed EFI program.

Purpose:

> Allow Linux to boot under Secure Boot without Microsoft signing the full distro bootloader directly.

---

# 🧱 Why shim Exists

Firmware Secure Boot trusts:

* Microsoft keys (in `db`)
* OEM keys

But GRUB from Linux distro is NOT signed by Microsoft directly.

So:

```
UEFI → trusts Microsoft
Microsoft signs shim
shim verifies GRUB
GRUB verifies kernel
```

Shim creates a second trust layer.

---

# 🔗 Full Boot Chain (Linux Secure Boot)

```
Firmware (Secure Boot ON)
        ↓
Loads shimx64.efi (signed by Microsoft)
        ↓
shim verifies grubx64.efi
        ↓
GRUB verifies Linux kernel
        ↓
Kernel runs
```

Each stage checks signature of next.

---

# 🧠 What shim Contains

Shim includes:

1️⃣ Embedded Linux distribution public key
2️⃣ Code to verify EFI binaries
3️⃣ Optional MOK system (Machine Owner Key support)

---

# 🔎 Step-by-Step How shim Works

### 1️⃣ Firmware loads shim

* Firmware checks shim signature
* Signature matches Microsoft key in `db`
* shim allowed to execute

---

### 2️⃣ shim loads GRUB

shim:

* Reads `grubx64.efi`
* Extracts its signature
* Verifies signature against:

  * Embedded distro key
  * MOK database (optional)

If valid → execute GRUB
If invalid → boot blocked

---

### 3️⃣ GRUB loads Linux kernel

GRUB (when Secure Boot aware):

* Verifies kernel signature
* Verifies kernel modules (if configured)
* Refuses unsigned kernel if enforcement enabled

---

# 🔑 What Is MOK (Machine Owner Key)?

MOK allows user to:

* Add custom signing keys
* Sign custom kernels
* Sign custom modules

Managed by:

```
mokutil
```

MOK keys stored in firmware NVRAM.

During boot, shim can show:

```
Enroll key?
```

This allows custom development while keeping Secure Boot enabled.

---

# 🧾 Signature Format

EFI files use:

* PE/COFF format
* Embedded PKCS#7 signature
* SHA256 hash
* RSA public key verification

Shim verifies this signature using embedded public key.

---

# 🚫 If GRUB Is Modified

If attacker modifies `grubx64.efi`:

* Signature becomes invalid
* shim refuses execution
* Secure Boot violation occurs

System stops before GRUB runs.

---

# 🛡 Why shim Is Necessary

Without shim:

* Linux distros would need Microsoft to sign GRUB directly every time
* Hard to manage updates
* No user custom keys

shim allows:

* Microsoft signs shim once
* Linux distro controls rest of trust chain

---

# 🔥 Security Insight

Secure Boot protects:

👉 Bootloader integrity
👉 Kernel integrity (if enforced)

But does NOT protect:

👉 Root user inside OS
👉 Runtime memory attacks
👉 Exploits after kernel boot

---

# 🧠 Complete Trust Hierarchy

```
Firmware PK
   ↓
KEK
   ↓
db (trusted certs)
   ↓
Microsoft key
   ↓
shim (signed)
   ↓
Distro key
   ↓
GRUB
   ↓
Kernel
```

Layered trust.

---

# 💡 Final Summary

shim:

* Is Microsoft-signed
* Contains distro public key
* Verifies GRUB
* Supports MOK for user keys
* Bridges firmware trust to Linux trust

Without shim, Linux Secure Boot would be impractical.

---

Good — now we go one level deeper: **kernel module signing under Secure Boot**.

Secure Boot protects bootloader.
Kernel module signing protects the **running kernel**.

---

# 🔐 Why Module Signing Exists

Linux supports loadable modules:

```
.ko files
```

Example:

* GPU drivers
* Filesystem drivers
* Network drivers

If attacker loads a malicious module:

👉 They get full kernel-level control.

So when Secure Boot is enabled, Linux enforces:

> Only signed kernel modules may load.

---

# 🧱 How Enforcement Is Triggered

When:

* Secure Boot = ON
* Kernel built with `CONFIG_MODULE_SIG`
* Kernel lockdown mode active

Then:

```
Unsigned module → rejected
```

---

# 🔗 Boot Chain With Module Signing

```
Firmware
   ↓
shim
   ↓
GRUB
   ↓
Signed Kernel
   ↓
Signed Kernel Modules
```

Trust continues beyond boot.

---

# 🧾 How Modules Are Signed

A module (`driver.ko`) contains:

* Normal ELF module content
* Appended digital signature block at end

Signature format:

* PKCS#7
* RSA (usually 2048+)
* SHA256 hash

The signature signs:

```
Hash of entire module file
```

---

# 🔎 What Happens When Module Loads

When you run:

```
modprobe driver
```

Kernel does:

1️⃣ Read module file
2️⃣ Extract appended signature
3️⃣ Compute SHA256 of module
4️⃣ Verify signature against trusted keys
5️⃣ If valid → load
6️⃣ If invalid → reject

---

# 🔑 Where Trusted Keys Come From

Kernel trusts keys from:

1️⃣ Built-in kernel keyring (compiled into kernel)
2️⃣ MOK (Machine Owner Key) database
3️⃣ Platform key database

Shim passes MOK keys into kernel at boot.

---

# 🧠 Kernel Keyrings

Linux maintains internal keyrings:

* `.builtin_trusted_keys`
* `.platform`
* `.secondary_trusted_keys`

You can inspect:

```
cat /proc/keys
```

These hold public keys used to verify modules.

---

# 🛠 Signing a Custom Module

Generate key:

```
openssl req -new -x509 -newkey rsa:2048 \
-keyout MOK.key -out MOK.crt -nodes -days 365
```

Enroll key:

```
sudo mokutil --import MOK.crt
```

Reboot → enroll in shim menu.

Sign module:

```
scripts/sign-file sha256 MOK.key MOK.crt module.ko
```

Now module loads under Secure Boot.

---

# 🚫 If Module Is Unsigned

You’ll see:

```
module verification failed: signature and/or required key missing
```

Kernel refuses to load it.

---

# 🔒 What Lockdown Mode Does

When Secure Boot active:

Kernel enters **lockdown mode**.

It disables:

* Direct /dev/mem access
* Kernel memory modification
* kexec unsigned kernel
* Some debug features

Prevents bypassing signature enforcement.

---

# 🧨 Attack Attempt Example

Attacker tries:

```
insmod rootkit.ko
```

If unsigned:

→ Blocked.

If signed with untrusted key:

→ Blocked.

If Secure Boot disabled:

→ Loads successfully.

---

# 🧠 Important Limitation

Module signing protects:

✔ Kernel integrity
✔ Runtime extension control

But does NOT protect:

✖ Exploits inside signed module
✖ Root user if Secure Boot off
✖ Userland malware

---

# 📊 Comparison

| Layer          | Protects                           |
| -------------- | ---------------------------------- |
| GPT CRC        | Disk metadata integrity            |
| Secure Boot    | Bootloader authenticity            |
| Kernel signing | Kernel binary integrity            |
| Module signing | Runtime kernel extension integrity |

Each layer protects deeper level.

---

# 💡 Final Mental Model

Without module signing:

```
Signed kernel
   ↓
Any unsigned module can run
   ↓
Security broken
```

With module signing:

```
Signed kernel
   ↓
Only trusted modules allowed
   ↓
Kernel integrity maintained
```

---
Secure Boot is strong — but attackers don’t “break” it directly.
They bypass it through weak links around it.

Here are the real-world methods.

---

# 🔓 1️⃣ Bootloader Vulnerabilities (Most Common)

If a **signed** bootloader has a bug, attacker can exploit it.

Example: **GRUB** “BootHole” vulnerability (2020)

* GRUB was properly signed
* But config parsing bug allowed arbitrary code execution
* Secure Boot allowed GRUB to run
* Exploit ran inside trusted GRUB

Result: Secure Boot bypass without breaking signatures.

Fix: revoke vulnerable versions via `dbx` updates.

---

# 🔑 2️⃣ Stolen / Leaked Signing Keys

If a vendor’s private key leaks:

* Attacker signs malicious bootloader
* Firmware trusts signature
* Malicious code runs

This has happened in embedded devices.

Secure Boot only as strong as private key secrecy.

---

# 🧾 3️⃣ Using Older Signed Binaries (Rollback Attack)

If firmware does not check version:

* Attacker installs older vulnerable signed bootloader
* Exploits known vulnerability

Mitigation: revocation database (`dbx`) + version enforcement.

---

# 🧨 4️⃣ Exploiting shim

Since **Shim** is Microsoft-signed, it’s a prime target.

If shim has:

* Buffer overflow
* Signature verification bug
* Logic flaw

Attacker can bypass GRUB verification.

Several shim CVEs have been patched over years.

---

# 🔄 5️⃣ Disabling Secure Boot (Physical Access)

If attacker has physical access:

* Enter firmware settings
* Disable Secure Boot
* Or reset firmware keys

On consumer devices this is often allowed.

Enterprise systems may lock this down.

---

# 🧠 6️⃣ Evil Maid Attack

Attacker with brief physical access:

* Replaces disk
* Installs malicious signed OS
* Or manipulates boot chain

Secure Boot protects integrity, not ownership.

Without disk encryption, data still accessible.

---

# 💾 7️⃣ DMA Attacks

If system supports external DMA (Thunderbolt etc.):

* Attacker injects code into memory
* Before OS locks down interfaces

Secure Boot doesn’t protect runtime memory.

Mitigation: IOMMU + DMA protection.

---

# 🧬 8️⃣ Compromised Kernel After Boot

Secure Boot ends once kernel runs.

If attacker gains root via exploit:

* They control system
* They don’t need to bypass Secure Boot anymore

Secure Boot ≠ runtime exploit protection.

---

# 📦 9️⃣ Signed but Malicious Drivers

On Windows systems:

Attackers have abused legitimately signed drivers.

Example target ecosystem: **Microsoft Windows**

Driver is signed → loads → exploited to disable protections.

Signature ≠ safe logic.

---

# 🧯 10️⃣ Failing to Update Revocation List (dbx)

If firmware does not update `dbx`:

* Known-bad signed binaries remain trusted
* Old exploits still usable

This is common on rarely updated systems.

---

# 🔥 Important Insight

Secure Boot protects:

✔ Integrity of boot chain
✔ Authenticity of signed components

It does NOT protect:

✖ Vulnerabilities inside trusted code
✖ Runtime memory corruption
✖ Physical attackers with firmware access
✖ Social engineering

---

# 🧠 Real Attack Strategy

Attackers usually target:

```
Signed but vulnerable component
```

Instead of trying to forge signature.

Cryptography is rarely broken.
Implementation bugs are exploited.

---

# 🛡 How to Strengthen Beyond Secure Boot

Combine with:

* TPM Measured Boot
* Full disk encryption
* Firmware password
* Disable external boot
* Lockdown mode
* Regular dbx updates

Secure Boot is a foundation — not full security.

---

Now we move beyond prevention → into **detection**.

Secure Boot = blocks unsigned code.
Measured Boot = records what actually ran.

---

# 🔐 What Is TPM Measured Boot?

Measured Boot uses a **Trusted Platform Module (TPM)** to:

> Cryptographically record hashes of each boot stage.

It does NOT block execution.
It creates tamper-evident proof.

---

# 🧠 Core Idea

Each component calculates a hash of the next component before executing it.

That hash is stored inside TPM PCR registers.

If anything changes → hash changes → measurement changes.

---

# 🔗 Boot Measurement Chain

Example Linux chain:

```
Firmware
   ↓ measures
shim
   ↓ measures
GRUB
   ↓ measures
Kernel
   ↓ measures
Initramfs
```

Each step extends TPM PCR.

---

# 📦 What Are PCRs?

PCR = Platform Configuration Register.

Inside TPM:

* Special registers (PCR0–PCR23)
* Cannot be overwritten
* Only "extended"

Extend operation:

```
PCR = SHA256( old_PCR || new_hash )
```

So history is chained.

You cannot erase a bad measurement.

---

# 🔎 What Gets Measured?

Typical PCR mapping:

* PCR0 → Firmware
* PCR2 → Option ROMs
* PCR4 → Bootloader
* PCR7 → Secure Boot state
* PCR8/9 → Kernel & initramfs (Linux)

Exact mapping depends on platform.

---

# 📊 Example Tampering Scenario

Normal boot:

```
GRUB hash = A1B2C3
PCR4 = SHA256(previous || A1B2C3)
```

Attacker modifies GRUB:

```
GRUB hash = DEAD99
PCR4 becomes different value
```

Remote server sees mismatch → flags tampering.

---

# 🌍 Remote Attestation

This is where it becomes powerful.

TPM can sign PCR values using Attestation Identity Key (AIK).

Server verifies:

* PCR values
* Expected measurements
* Signature validity

If values differ → system considered compromised.

Used in enterprise & cloud.

---

# 🔒 Secure Boot vs Measured Boot

| Secure Boot          | Measured Boot               |
| -------------------- | --------------------------- |
| Blocks unsigned code | Records what ran            |
| Preventive           | Detective                   |
| Local enforcement    | Remote verifiable           |
| Stops boot           | Allows boot but logs change |

They complement each other.

---

# 🧬 How Linux Uses It

Linux exposes TPM via:

```
/sys/class/tpm
```

Tools:

* `tpm2_pcrread`
* `tpm2_quote`

Kernel IMA (Integrity Measurement Architecture) can extend PCRs for:

* Kernel modules
* Executables
* Files

Now runtime tampering is also measured.

---

# 🧨 Example Attack Detection

Attacker:

* Replaces bootloader
* Uses vulnerable signed binary
* Or disables Secure Boot

Measured Boot:

* PCR7 changes (Secure Boot state)
* PCR4 changes (bootloader)
* Remote attestation fails

Even if boot succeeds, trust is broken.

---

# 💡 Why PCR Cannot Be Forged

Because:

* PCR extend is one-way
* Private AIK key never leaves TPM
* TPM hardware isolated from CPU memory

Attacker cannot rewrite PCR values without rebooting.

---

# 🔥 Real-World Use

Cloud providers rely heavily on this:

Example ecosystem: **Microsoft Azure confidential computing**

They verify VM boot integrity remotely.

---

# 🧠 Key Insight

Secure Boot answers:

> “Is this signed?”

Measured Boot answers:

> “What exactly ran?”

One enforces trust.
One proves trust.

---

# 🛡 Full Modern Secure Stack

```
Secure Boot  → prevents tampering
Measured Boot → detects tampering
TPM sealing  → protects secrets
Disk encryption → protects data
```

Layered defense.

---

Secure Boot = “Only trusted code may start.”
TPM + Measured Boot = “Prove exactly what started — and keep secrets only if it’s trusted.”

Here’s how it goes further.

---

# 🔐 1️⃣ It Protects Secrets (Not Just Boot Code)

With **Trusted Platform Module**, secrets can be *sealed* to PCR values.

Example:

* Disk encryption key is sealed to PCR7 (Secure Boot state)
* If bootloader changes → PCR changes
* TPM refuses to release the key

System boots → but disk won’t decrypt.

Secure Boot alone cannot do that.

---

# 🧠 2️⃣ It Detects Signed-But-Malicious Code

Secure Boot checks signature only.

If attacker uses:

* Old vulnerable signed bootloader
* Legitimately signed malicious driver

Secure Boot allows it.

Measured Boot records the hash.

Remote attestation server sees unexpected measurement → rejects machine.

Detection beyond signature.

---

# 🌍 3️⃣ Remote Attestation (Trust From Distance)

TPM can cryptographically sign PCR values.

Enterprise server verifies:

* Firmware state
* Bootloader hash
* Kernel hash
* Secure Boot status

Used heavily in cloud platforms like **Microsoft** Azure and enterprise device management.

Secure Boot works locally.
Measured Boot proves trust remotely.

---

# 🔄 4️⃣ Runtime Integrity (Not Just Boot)

With Linux IMA (Integrity Measurement Architecture):

* Every executable
* Every kernel module
* Important files

Are measured and extended into PCRs.

Now tampering after boot is also detectable.

Secure Boot stops at kernel load.
Measured Boot continues.

---

# 🔑 5️⃣ Anti-Rollback Protection

If attacker installs older signed firmware:

* Secure Boot might allow it
* PCR measurement changes
* Secrets sealed to new firmware won’t unseal

Rollback blocked automatically.

---

# 🧨 6️⃣ Detects Secure Boot Being Disabled

If someone enters firmware and disables Secure Boot:

* PCR7 changes
* TPM measurement reflects it
* Sealed keys remain locked

Even though firmware allowed the change.

---

# 🛡 7️⃣ Enables Zero-Trust Architecture

In modern enterprise:

Device must prove:

* It booted trusted firmware
* Secure Boot enabled
* No tampering
* Approved OS version

Before:

* Accessing VPN
* Accessing cloud
* Receiving credentials

This is zero-trust enforcement.

---

# 📊 Secure Boot vs TPM + Measured Boot

| Feature                  | Secure Boot | TPM + Measured Boot |
| ------------------------ | ----------- | ------------------- |
| Blocks unsigned code     | ✔           | ✖                   |
| Records what ran         | ✖           | ✔                   |
| Protects encryption keys | ✖           | ✔                   |
| Detects Secure Boot off  | ✖           | ✔                   |
| Remote verification      | ✖           | ✔                   |
| Runtime file measurement | ✖           | ✔                   |

---

# 🔥 Core Difference

Secure Boot enforces trust at startup.

TPM + Measured Boot:

* Makes trust measurable
* Makes secrets conditional
* Makes compromise visible
* Makes remote verification possible

It transforms trust into cryptographic evidence.

---

### GPT CRC (Partition Table)

* Used in **GPT header + partition entries**
* Uses **CRC32**
* Purpose: detect corruption in partition metadata
* Very small scope (only disk layout info)
* Cannot detect file-level corruption
* No self-healing

---

### ext4 Checksums

* Uses checksums mainly for **metadata (journal, inodes, superblock)**
* Detects corruption inside filesystem structures
* Does NOT checksum user data by default
* No automatic repair of corrupted data blocks

---

### Btrfs Checksums

* Checksums **everything** (metadata + file data)
* Stored separately from data blocks
* Uses copy-on-write
* Can **auto-repair** if redundant copy exists (RAID/mirror)

---

### Simple Difference

| Feature         | GPT CRC         | ext4     | Btrfs               |
| --------------- | --------------- | -------- | ------------------- |
| Scope           | Partition table | Metadata | Metadata + Data     |
| Protects files? | ❌               | Partial  | ✅                   |
| Self-healing?   | ❌               | ❌        | ✅ (with redundancy) |
| Strength        | Basic integrity | Moderate | Advanced            |

---

Short version:

GPT CRC = protects disk layout
ext4 = protects filesystem structure
Btrfs = protects everything (and can fix it)



## GPT Corruption

GPT = disk layout damage.

* Partition table header corrupted
* Partition entries damaged
* OS may not detect partitions
* Disk appears “unallocated”
* Filesystem may still be intact inside

Problem is at **disk structure level**.

---

## Filesystem Corruption

Filesystem = data structure inside a partition.

* Inode damage
* Journal corruption
* Directory structure broken
* Files missing or unreadable
* Partition is detected, but data fails

Problem is at **data organization level**.

---

## Example

GPT broken → system can’t see `/dev/sda1`
Filesystem broken → `/dev/sda1` exists, but files error

---

## Repair Tools

GPT → `gdisk`, `sgdisk`
Filesystem → `fsck` (for ext4), `btrfs check` (for Btrfs)

---

### Core Difference

GPT corruption = disk map lost
Filesystem corruption = data structure lost

Very different layers.





## If GPT corruption happens

GPT = partition map.

What happens:

* System may not detect partitions
* Disk shows as “unallocated”
* OS may refuse to boot
* `/dev/sda1` may disappear
* Data is still physically on disk

Important:
Files are usually **not erased** — only the map is damaged.

If backup GPT header exists → can restore.
If fully damaged → need partition recovery tools.

---

## If Filesystem corruption happens

Filesystem = structure inside partition.

What happens:

* Partition is visible
* Mount may fail
* Files may disappear
* “Input/output error”
* Some files become unreadable
* System may boot but crash later

Here, the data structure that organizes files is broken.

Sometimes repairable with `fsck` (for ext4)
Sometimes auto-repair if using Btrfs with redundancy

---

### Simple understanding

GPT corruption → house address lost
Filesystem corruption → rooms inside house broken

Different layers. Different damage.



Yes — possible in both cases.
But method is different.

---

## If GPT is corrupted

Good news:
Data is usually still there.

You can:

* Rebuild GPT using backup header
* Use `gdisk` recovery
* Use TestDisk to rebuild partition table

If partition boundaries are recovered correctly →
all files return normally.

Success rate: **very high** (if disk not overwritten)

---

## If Filesystem is corrupted

Harder.

You can:

* Run `fsck` (for ext4)
* Use `btrfs restore` (for Btrfs)
* Use file carving tools (PhotoRec)

Possible results:

* Some files fully recover
* Some partially damaged
* Some lost

Success rate: **depends on damage level**

---

### Important rule

If corruption happens:

1. **Stop using the disk immediately**
2. Do NOT format
3. Do NOT install OS
4. Make a full disk image first

Recovery is very possible —
if you don’t overwrite data.





## How `dd` can destroy GPT

`dd` writes raw bytes directly to disk.

If you run something like:

```
dd if=image.iso of=/dev/sda
```

It will:

* Overwrite GPT header (at beginning of disk)
* Overwrite partition entries
* Overwrite backup GPT (at end of disk)
* Destroy partition map instantly

Disk becomes “unallocated”.

One wrong device name = full disk loss.

---

## Why this happens

GPT stores:

* Primary header → start of disk
* Backup header → end of disk

`dd` writes from sector 0 → so GPT dies first.

No warning. No undo.

---

## How to avoid it

### 1️⃣ Double-check device name

Use:

```
lsblk
```

Make sure you target USB (example `/dev/sdb`)
NOT main disk (`/dev/sda`).

---

### 2️⃣ Never write to a mounted disk

Unmount first:

```
umount /dev/sdb1
```

---

### 3️⃣ Use `oflag=sync` and `status=progress`

Safer visibility:

```
dd if=image.iso of=/dev/sdb bs=4M status=progress oflag=sync
```

---

### 4️⃣ Consider safer tools

Instead of raw `dd`, use:

* `cp --sparse=always` (for images to files)
* `ddrescue` (for recovery)

---

### 5️⃣ Backup GPT before risky work

```
sgdisk --backup=gpt-backup.bin /dev/sda
```

If destroyed, you can restore.

---

## Core danger

`dd` = disk destroyer
It does exactly what you tell it.
Even if it is wrong.

One wrong letter → full disk gone.




## If first 1MB of disk is overwritten

That area contains:

* GPT primary header
* Partition entries
* Possibly bootloader (GRUB stage 1)

But usually:

* Backup GPT (at end of disk) still exists
* Filesystem data still exists

---

## Step 1 — STOP using disk

Do not mount.
Do not format.
Do not write anything.

---

## Step 2 — Try GPT rebuild

If using GPT:

```
gdisk /dev/sdX
```

It will detect broken primary header
and offer to use backup GPT.

Then:

* Use recovery menu
* Write restored GPT back

Very high success rate if only first 1MB damaged.

---

## Step 3 — If both GPT copies damaged

Use TestDisk:

* Scan disk
* Detect partitions by filesystem signature
* Recreate partition table

Often works because filesystem starts after first MB.

---

## Step 4 — If partition recovered but won’t mount

Run filesystem repair:

For ext4:

```
fsck.ext4 /dev/sdX1
```

For Btrfs:

```
btrfs check --repair /dev/sdX1
```

---

## Worst Case

If too much was overwritten:

* Use PhotoRec (file carving)
* Recover files without filenames

---

### Reality

Overwriting first 1MB is bad —
but usually recoverable
because real data starts after that area.

Unless more sectors were written.




Below is a **minimal C example** to compute GPT CRC32
(same polynomial GPT uses — standard IEEE CRC32).

GPT uses:

* Polynomial: `0xEDB88320`
* Initial value: `0xFFFFFFFF`
* Final XOR: `^ 0xFFFFFFFF`

---

## Short C Program

```c
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

uint32_t crc32(const uint8_t *data, size_t length) {
    uint32_t crc = 0xFFFFFFFF;

    for (size_t i = 0; i < length; i++) {
        crc ^= data[i];
        for (int j = 0; j < 8; j++) {
            if (crc & 1)
                crc = (crc >> 1) ^ 0xEDB88320;
            else
                crc >>= 1;
        }
    }

    return crc ^ 0xFFFFFFFF;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <file>\n", argv[0]);
        return 1;
    }

    FILE *f = fopen(argv[1], "rb");
    if (!f) {
        perror("fopen");
        return 1;
    }

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    rewind(f);

    uint8_t *buffer = malloc(size);
    fread(buffer, 1, size, f);
    fclose(f);

    uint32_t result = crc32(buffer, size);
    printf("CRC32: %08X\n", result);

    free(buffer);
    return 0;
}
```

---

## How GPT Uses This

Before computing CRC:

* Set `HeaderCRC32` field to **0**
* Compute CRC over header size only (usually 92 bytes)
* Store result back into header

For partition array:

* Compute CRC over entire partition entry array
* Store value in GPT header field

---

## Compile

```
gcc gpt_crc.c -o gpt_crc
```

---

This is the exact CRC logic GPT relies on.



## Verify GPT CRC on a real disk (Linux)

### 1️⃣ Automatic check (easiest)

Use `gdisk`:

```
sudo gdisk -l /dev/sdX
```

If CRC is wrong, it will show warnings like:

* “CRC mismatch”
* “Main GPT header is corrupt”
* “Backup GPT header is corrupt”

It automatically compares:

* Primary header CRC
* Backup header CRC
* Partition array CRC

---

### 2️⃣ Using `sgdisk` (direct verify)

```
sudo sgdisk -v /dev/sdX
```

This performs full GPT verification.

If healthy, you see:

```
No problems found.
```

If damaged, it reports exact CRC failure.

---

### 3️⃣ Manual check (advanced)

Dump GPT header:

```
sudo dd if=/dev/sdX bs=512 count=1 | hexdump -C
```

GPT header starts at LBA 1 (not 0), so:

```
sudo dd if=/dev/sdX bs=512 skip=1 count=1 > gpt_header.bin
```

Then:

* Zero out CRC field (offset 16–19)
* Compute CRC32 over header size (usually 92 bytes)
* Compare with stored CRC

This matches the calculation used earlier.

---

## Tools involved

* `gdisk`
* `sgdisk`
* `dd`
* `hexdump`

All work with standard GPT format.

---

### Quick summary

Fast method → `sgdisk -v /dev/sdX`
Deep manual method → dump header + compute CRC yourself





⚠ Do this **only inside a VM**, never on real disk.

Example using a virtual disk file.

---

## 1️⃣ Create a test disk

```
dd if=/dev/zero of=test.img bs=1M count=100
```

Create GPT:

```
sgdisk -o test.img
sgdisk -n 1:2048:40959 test.img
```

Verify:

```
sgdisk -v test.img
```

You should see:

```
No problems found.
```

---

## 2️⃣ Corrupt the GPT header (first 1 sector of GPT)

GPT primary header is at **LBA 1**.

Overwrite it:

```
dd if=/dev/zero of=test.img bs=512 seek=1 count=1 conv=notrunc
```

---

## 3️⃣ Verify again

```
sgdisk -v test.img
```

Now you’ll see:

* Main GPT header CRC mismatch
* Primary header corrupt
* Backup header still valid

You just caused a real GPT CRC failure.

---

## 4️⃣ Corrupt backup GPT too (optional)

Backup header is at last sector.

Find last sector:

```
sgdisk -E test.img
```

Overwrite last sector:

```
dd if=/dev/zero of=test.img bs=512 seek=<last_sector> count=1 conv=notrunc
```

Now verification shows:

* Both headers corrupt
* CRC errors everywhere

---

## What you just observed

GPT protects itself using:

* Primary header CRC
* Backup header CRC
* Partition array CRC

When one copy breaks → other saves you.
When both break → manual recovery needed.

---

### This is exactly how CRC detection works in real disks.





⚠ Only inside VM / test image.

---

# 1️⃣ Create Test Disk

```
dd if=/dev/zero of=test.img bs=1M count=100
sgdisk -o test.img
sgdisk -n 1:2048:40959 test.img
```

Verify:

```
sgdisk -v test.img
```

---

# 2️⃣ Destroy BOTH GPT headers

Primary header → LBA 1
Backup header → last sector

Destroy primary:

```
dd if=/dev/zero of=test.img bs=512 seek=1 count=1 conv=notrunc
```

Find last LBA:

```
sgdisk -E test.img
```

Destroy backup:

```
dd if=/dev/zero of=test.img bs=512 seek=<last_LBA> count=1 conv=notrunc
```

Now:

```
sgdisk -v test.img
```

Result:

* Main header corrupt
* Backup header corrupt
* No valid GPT found

You now have total GPT failure.

---

# 3️⃣ Manual Reconstruction Method

Even though GPT is gone:

✔ Filesystem data still exists
✔ Partition content still exists
✔ Only partition map is missing

---

## Option A — Use TestDisk (semi-manual)

```
testdisk test.img
```

* Analyse
* Quick Search
* It finds partition by filesystem signature
* Write new partition table

Very high success rate.

---

## Option B — Fully Manual (Advanced)

If you know original partition start:

Example: partition started at LBA 2048

Recreate GPT:

```
sgdisk -o test.img
```

Recreate partition manually:

```
sgdisk -n 1:2048:40959 test.img
```

If start/end match original →
filesystem mounts normally.

---

## How to find original start?

Use filesystem superblock scan.

For ext4:

```
mke2fs -n test.img
```

or

```
grep -oba "EXT4" test.img
```

Ext4 superblock usually at:

start_LBA + 1024 bytes

You reverse-calculate partition start.

---

# 4️⃣ Worst Case

If partition boundaries unknown:

* Use file carving (PhotoRec)
* Recover files without names

---

# What You Learned

Even if:

Primary GPT destroyed
Backup GPT destroyed

Data is still there.

GPT = map
Filesystem = house

Rebuild map correctly → house returns.





⚠ Stop using the disk immediately.

If first **1MB** is fully overwritten:

* Protective MBR → gone
* Primary GPT header (LBA 1) → gone
* Partition entries (usually LBAs 2–33) → gone
* Bootloader (GRUB stage1) → gone

But:

✔ Backup GPT header (last sector) still exists
✔ Backup partition array (just before last sector) still exists
✔ Filesystem data still exists

This is usually recoverable.

---

# Method 1 — Automatic Recovery (Best Case)

Run:

```
sudo gdisk /dev/sdX
```

You will see warning:

```
Main GPT header is corrupt
Backup header is OK
```

Then:

* Press `r` (recovery menu)
* Press `b` (use backup GPT)
* Press `w` (write table)

This recreates primary GPT from backup.

Very high success rate.

---

# Method 2 — Using sgdisk

Sometimes this works directly:

```
sudo sgdisk -e /dev/sdX
```

This relocates backup GPT and rebuilds primary.

Then verify:

```
sudo sgdisk -v /dev/sdX
```

---

# If Backup Also Damaged

Then GPT cannot self-heal.

You must:

* Use TestDisk to scan
* Or manually recreate partitions using known start/end

Filesystem signatures help.

For ext4:
superblock is 1024 bytes after partition start.

---

# Why 1MB overwrite is usually survivable

GPT backup is at **end of disk**.
First 1MB only destroys primary structures.

So GPT redundancy saves you.

---

### Reality Summary

Overwrite first 1MB → scary but fixable
Overwrite last sector too → harder
Overwrite middle of disk → data loss

Always image disk before repair.



⚠ Read-only analysis only.

---

# 1️⃣ Dump first sectors

GPT layout:

* LBA 0 → Protective MBR
* LBA 1 → Primary GPT header
* LBA 2–33 → Partition entries

Dump first 34 sectors:

```
sudo dd if=/dev/sdX bs=512 count=34 | hexdump -C
```

Or inspect header only:

```
sudo dd if=/dev/sdX bs=512 skip=1 count=1 | hexdump -C
```

---

# 2️⃣ Identify GPT Header

At offset 0 you should see:

```
45 46 49 20 50 41 52 54
```

That is ASCII:

```
"EFI PART"
```

If missing → header corrupt.

---

# 3️⃣ Important Header Fields (Offsets)

All little-endian.

| Offset | Size | Meaning                   |
| ------ | ---- | ------------------------- |
| 0x00   | 8    | Signature ("EFI PART")    |
| 0x08   | 4    | Revision                  |
| 0x0C   | 4    | Header size               |
| 0x10   | 4    | Header CRC32              |
| 0x18   | 8    | Current LBA               |
| 0x20   | 8    | Backup LBA                |
| 0x28   | 8    | First usable LBA          |
| 0x30   | 8    | Last usable LBA           |
| 0x48   | 8    | Partition entry start LBA |
| 0x50   | 4    | Number of entries         |
| 0x54   | 4    | Entry size                |
| 0x58   | 4    | Partition array CRC32     |

Example:

```
00000010  5a 3c 91 27
```

Reverse byte order → CRC value.

---

# 4️⃣ Check Partition Entries

Dump entries:

```
sudo dd if=/dev/sdX bs=512 skip=2 count=32 | hexdump -C
```

Each entry usually 128 bytes.

Inside each entry:

* Partition type GUID (16 bytes)
* Unique GUID (16 bytes)
* First LBA (8 bytes)
* Last LBA (8 bytes)
* Attributes (8 bytes)
* Name (UTF-16)

---

# 5️⃣ Compare with Backup GPT

Backup header is at last sector:

```
sudo blockdev --getsz /dev/sdX
```

Then:

```
sudo dd if=/dev/sdX bs=512 skip=<last_sector> count=1 | hexdump -C
```

Should also contain:

```
EFI PART
```

But “Current LBA” and “Backup LBA” are swapped.

---

# What You Learn

With `hexdump` you can:

✔ Detect corruption
✔ Compare CRC fields
✔ Find partition start/end manually
✔ Confirm backup GPT health

GPT is fully transparent —
just structured binary data.



## ext4 Checksum Strategy

ext4 uses **CRC32C** (stronger than old CRC32).

It protects:

* Superblock
* Group descriptors
* Journal blocks
* Inodes
* Directory entries

Important:

* Checksums are seeded with filesystem UUID
* Metadata corruption is detected reliably
* User file data is **not checksummed by default**

So ext4 mainly protects **structure**, not file content.

No automatic self-healing (unless journal replay fixes it).

---

## Btrfs Checksum Strategy

Btrfs is much stronger.

It:

* Checksums **every data block**
* Checksums **all metadata**
* Stores checksum in a separate tree
* Uses copy-on-write (never overwrites in place)

Checksum types:

* CRC32C (default)
* xxHash
* SHA256
* BLAKE2 (optional)

When reading a block:

1. Read data
2. Recalculate checksum
3. Compare with stored checksum

If mismatch and RAID/mirror exists →
it auto-repairs using good copy.

---

## Core Difference from GPT

GPT → simple CRC32, only small header
ext4 → strong metadata protection
Btrfs → full data integrity + self-healing

---

### Simple View

GPT = detect broken map
ext4 = detect broken structure
Btrfs = detect + fix broken data


## What Secure Boot Does

Secure Boot uses **digital signatures**, not CRC.

Goal:
Only trusted bootloaders can run.

---

# How It Works (Step by Step)

### 1️⃣ Firmware contains trusted keys

Stored in UEFI:

* Platform Key (PK)
* Key Exchange Keys (KEK)
* Allowed signatures database (db)
* Revoked database (dbx)

---

### 2️⃣ Bootloader is digitally signed

Example:

* GRUB
* shim

They are signed using:

* RSA
* SHA-256 hash

---

### 3️⃣ During boot

UEFI firmware:

1. Hashes bootloader file
2. Verifies digital signature
3. Checks signature against trusted keys

If valid → boot continues
If invalid → boot blocked

---

# Why This Is Stronger Than CRC

CRC:

* Detects random corruption
* Cannot stop malicious modification

Digital signature:

* Uses private key cryptography
* Attacker cannot fake signature
* Protects against malware bootkits

---

# Linux Secure Boot Chain

Typical flow:

UEFI → shim → GRUB → Linux kernel

Kernel modules must also be signed
or they won’t load under Secure Boot.

---

## Core Difference

GPT CRC → detects disk damage
Secure Boot → prevents unauthorized code execution

One protects data integrity.
One protects trust chain.


## What ECC RAM Does

ECC = Error-Correcting Code memory.

It protects against **silent bit flips** in RAM.

---

## Why Bit Flips Happen

Causes:

* Cosmic radiation
* Electrical noise
* Aging memory cells
* Voltage instability

Without ECC → data changes silently.

---

## How ECC Works

Normal RAM:
Stores 64 bits per word.

ECC RAM:
Stores **64 data bits + extra parity bits**
(usually 8 extra bits → 72-bit total)

These extra bits store a **Hamming code**.

---

## What It Can Do

### ✔ Detect single-bit errors

### ✔ Correct single-bit errors automatically

### ✔ Detect (but not correct) double-bit errors

When CPU reads memory:

1. ECC logic recalculates code
2. Compares with stored ECC bits
3. If 1 bit wrong → fixes it instantly
4. If 2 bits wrong → system logs error

No crash. No silent corruption.

---

## Why This Matters

Without ECC:

* File in RAM gets 1 flipped bit
* Written to disk
* Filesystem checksum now fails
* Data corrupted permanently

With ECC:

* Bit corrected before write
* Disk stays safe

---

## Relation to Filesystems

Even strong systems like Btrfs
cannot detect corruption if RAM flips bit *before* checksum is computed.

ECC protects data **before it reaches disk**.

---

## Simple View

GPT → protects disk map
Filesystem → protects disk data
Secure Boot → protects boot code
ECC RAM → protects live memory

ECC stops corruption at the hardware level.



In UEFI, each `Boot####` variable
(e.g. `Boot0001`) is stored in NVRAM as raw binary.

Structure is defined by the `EFI_LOAD_OPTION` format.

---

# Binary Layout (Exact Order)

```
UINT32  Attributes
UINT16  FilePathListLength
CHAR16  Description[]        (UTF-16, null terminated)
EFI_DEVICE_PATH FilePathList (FilePathListLength bytes)
UINT8   OptionalData[]       (remaining bytes)
```

All values are **little-endian**.

---

# Field Details

### 1️⃣ Attributes (4 bytes)

Common flags:

| Bit | Meaning            |
| --- | ------------------ |
| 0   | LOAD_OPTION_ACTIVE |
| 1   | FORCE_RECONNECT    |
| 3   | HIDDEN             |

Example:

```
01 00 00 00
```

= Active boot entry.

---

### 2️⃣ FilePathListLength (2 bytes)

Length of device path section only.

Example:

```
2A 00
```

= 0x002A = 42 bytes.

---

### 3️⃣ Description (UTF-16 string)

Example:

```
55 00 62 00 75 00 6E 00 74 00 75 00 00 00
```

This spells:

```
Ubuntu
```

Each character = 2 bytes.

Ends with `00 00`.

---

### 4️⃣ EFI_DEVICE_PATH

Binary structure describing where bootloader is.

Usually:

* HD() → partition info
* File() → path like `\EFI\ubuntu\grubx64.efi`

Each device path node:

```
Type (1 byte)
SubType (1 byte)
Length (2 bytes)
Data (...)
```

Ends with:

```
7F FF 04 00
```

This is END device path node.

---

### 5️⃣ OptionalData

Optional extra parameters.

Often empty.

Can contain kernel command line if used by shim.

Example:

```
72 6F 6F 74 3D 2F 64 65 76 ...
```

(ASCII text)

---

# Real World Example

For Linux using:

* GRUB
* shim

`Boot0001` contains:

* Active flag
* Description: "ubuntu"
* Device path → partition GUID + `\EFI\ubuntu\shimx64.efi`

---

# Where It Is Stored

Linux path:

```
/sys/firmware/efi/efivars/Boot0001-XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
```

First 4 bytes of file = variable attributes (not part of EFI_LOAD_OPTION).

After that → raw structure above.

---

## Summary

`Boot####` = structured binary:

Attributes
Length
UTF-16 name
Device path
Optional data

It is not text.
It is packed firmware-level binary data.



In UEFI, a **device path** is a packed binary structure.

It tells firmware exactly *where* a boot file lives.

---

# General Binary Format

Each node:

```
UINT8   Type
UINT8   SubType
UINT16  Length
UINT8   Data[]
```

All little-endian.

Multiple nodes are chained together.

End of path is always:

```
Type = 0x7F
SubType = 0xFF
Length = 0x0004
```

Hex:

```
7F FF 04 00
```

---

# Node Types (Common Ones)

### 1️⃣ Hardware Device Path (Type 0x01)

Example: PCI device

---

### 2️⃣ ACPI Device Path (Type 0x02)

---

### 3️⃣ Messaging Device Path (Type 0x03)

Example: SATA, USB

---

### 4️⃣ Media Device Path (Type 0x04)

Most important for boot entries.

Common subtypes:

* 0x01 → Hard Drive (HD)
* 0x04 → File Path

---

# Example: Hard Drive Node (HD)

Structure:

```
Type        = 0x04
SubType     = 0x01
Length      = 0x002A (42 bytes)
PartitionNumber (4 bytes)
PartitionStartLBA (8 bytes)
PartitionSize (8 bytes)
PartitionGUID (16 bytes)
SignatureType (1 byte)
Signature (variable)
```

This encodes GPT partition GUID.

---

# Example: File Path Node

Type 0x04
SubType 0x04

Data = UTF-16 string like:

```
\EFI\ubuntu\shimx64.efi
```

Stored as UTF-16 (2 bytes per char).

---

# Real Boot Flow Example

Boot entry for:

* shim
* GRUB

Device path chain looks like:

PCI → SATA → HD(GPT partition GUID) → File(\EFI\ubuntu\shimx64.efi) → END

Each segment is one structured node.

---

# How It Looks in Hex (Simplified)

```
04 01 2A 00   ← HD node
...GUID...
04 04 XX 00   ← File node
5C 00 45 00 46 00 49 00 ...
7F FF 04 00   ← End
```

---

# Important Properties

✔ Binary, not text
✔ Self-describing (length field inside each node)
✔ Can represent any hardware chain
✔ Fully architecture independent

---

## Simple View

Device path = chain of binary location blocks
Each block says:
“Go here → then here → then this file”




When UEFI **NVRAM fills up**, firmware cannot store new variables.

This affects boot entries and Secure Boot keys.

---

## What starts failing

In UEFI systems:

* `efibootmgr` fails with *No space left on device*
* Cannot create new `Boot####` entries
* Cannot update BootOrder
* Secure Boot key updates fail
* Kernel may log EFI variable write errors

System may still boot —
but you cannot modify boot settings.

---

## Why it happens

NVRAM is very small:

* Often only 64KB–256KB total
* Shared by:

  * Boot variables
  * Secure Boot keys (PK, KEK, db, dbx)
  * Crash logs
  * Vendor variables

Some firmware also leaks space over time.

---

## Worst case

If firmware bug occurs:

* Boot entries become corrupted
* System may refuse to boot
* Cannot save new variables

Rare, but possible.

---

## How to fix

### 1️⃣ Remove unused boot entries

```
sudo efibootmgr
sudo efibootmgr -b 0007 -B
```

(Delete unnecessary entries.)

---

### 2️⃣ Delete duplicate variables

Check:

```
ls /sys/firmware/efi/efivars/
```

Remove unused custom vars carefully.

---

### 3️⃣ Reset firmware to defaults

From BIOS setup → "Restore Defaults"

This often clears NVRAM.

---

### 4️⃣ Clear Secure Boot keys (if safe)

Deletes large key databases.

---

## Important

NVRAM full ≠ disk full.

It is firmware storage only.

---

### Simple view

Disk full → OS problem
NVRAM full → firmware configuration problem

Usually recoverable by cleaning boot entries.


EFI executables (like bootloaders) use the **PE/COFF** format
— same base format as Windows `.exe`.

Used by UEFI firmware.

---

# High-Level Layout

```
[ DOS Header ]
[ PE Signature ]
[ COFF Header ]
[ Optional Header ]
[ Section Table ]
[ Sections (.text, .data, etc) ]
```

All little-endian.

---

# 1️⃣ DOS Header (Legacy Stub)

Starts with:

```
4D 5A
```

ASCII: `"MZ"`

Contains pointer to PE header (`e_lfanew` offset).

---

# 2️⃣ PE Signature

At offset from DOS header:

```
50 45 00 00
```

ASCII: `"PE\0\0"`

---

# 3️⃣ COFF Header

Contains:

* Machine type (x86_64 = 0x8664)
* Number of sections
* Timestamp
* Characteristics flags

Example machine values:

* 0x014C → x86
* 0x8664 → x86_64
* 0xAA64 → ARM64

---

# 4️⃣ Optional Header (Important)

Not really optional.

Contains:

* Entry point address
* Image base
* Section alignment
* Size of image
* Subsystem type

For EFI apps:

```
Subsystem = 10 (EFI_APPLICATION)
```

Other values:

* 11 → EFI_BOOT_SERVICE_DRIVER
* 12 → EFI_RUNTIME_DRIVER

---

# 5️⃣ Section Table

Lists sections like:

* `.text` (code)
* `.data`
* `.rdata`
* `.reloc`

Each entry:

```
Name (8 bytes)
VirtualSize
VirtualAddress
SizeOfRawData
PointerToRawData
Characteristics
```

---

# 6️⃣ Relocation Section (.reloc)

Very important for EFI.

UEFI loads image at arbitrary address.
Relocation entries allow fixing absolute addresses.

Without `.reloc`, firmware may refuse to load.

---

# 7️⃣ Digital Signature (Secure Boot)

If Secure Boot enabled:

Signature is stored in:

```
WIN_CERTIFICATE
```

Located after image sections.

Firmware:

1. Hashes image (excluding signature block)
2. Verifies RSA signature
3. Compares against trusted keys

Used by:

* shim
* GRUB

---

# How Firmware Loads It

UEFI:

1. Parses PE headers
2. Allocates memory
3. Applies relocations
4. Jumps to EntryPoint

No DOS, no Windows loader involved.

---

## Simple View

PE/COFF = structured executable container

Headers → describe image
Sections → contain code/data
Reloc → fix addresses
Signature → prove trust

It’s a portable binary format adapted for firmware.



Secure Boot verifies EFI binaries using **public-key cryptography**.

Defined by Secure Boot in UEFI.

---

# Step-by-Step Verification

## 1️⃣ Firmware loads EFI file

Example:

* `\EFI\BOOT\BOOTX64.EFI`
* shim
* GRUB

Firmware reads the PE/COFF structure.

---

## 2️⃣ Locate Signature Block

Inside the PE file is a:

```
WIN_CERTIFICATE
```

Contains:

* Hash algorithm (usually SHA-256)
* RSA signature
* Signer certificate

Signature is stored at end of file.

---

## 3️⃣ Compute Hash

Firmware:

* Hashes entire image
* Excludes signature region
* Uses SHA-256 (most common)

Result = calculated digest.

---

## 4️⃣ Verify RSA Signature

Using signer’s public key:

* Decrypt signature
* Compare decrypted hash with calculated hash

If they match → file not modified.

---

## 5️⃣ Check Trust Database

Firmware compares signer certificate against:

* **db** → allowed keys
* **dbx** → revoked keys

If key is:

✔ In db → allowed
❌ In dbx → blocked

---

# Trust Chain Example (Linux)

UEFI → shim → GRUB → kernel

* shim signed by Microsoft key (in db)
* shim verifies GRUB
* GRUB verifies kernel
* Kernel verifies modules

This creates a full chain of trust.

---

# If Verification Fails

Firmware will:

* Refuse to execute
* Show “Security Violation”
* Stop boot

---

# Why This Is Strong

CRC = detects random corruption
Secure Boot = prevents malicious modification

Attacker cannot forge signature
without private key.

---

## Simple View

1. Hash file
2. Verify signature
3. Check trusted key
4. Execute only if trusted

That is how EFI binary integrity is enforced.


UEFI boots from the **EFI System Partition (ESP)**
which is formatted as FAT32.

If FAT is corrupted → firmware cannot read boot files.

---

## What UEFI Needs

On ESP:

```
\EFI\BOOT\BOOTX64.EFI
```

or distro loader like:

* GRUB
* shim

UEFI has a built-in FAT driver.
It must read directory + file clusters correctly.

---

# Types of FAT Corruption & Effects

## 1️⃣ Directory Entry Corruption

* File not found
* “No bootable device”
* Firmware falls back to next boot entry

---

## 2️⃣ FAT Table Corruption

* Wrong cluster chain
* Bootloader partially read
* Secure Boot hash mismatch
* Boot fails with security error

---

## 3️⃣ Boot Sector Corruption

* Filesystem unreadable
* ESP appears invalid
* Firmware cannot parse partition

---

## 4️⃣ Cluster Data Damage

* Bootloader file corrupted
* Signature verification fails
* Secure Boot blocks execution

---

# Why It’s Critical

UEFI does NOT understand ext4, btrfs, etc.

It only understands FAT on ESP.

If FAT breaks →
UEFI cannot even load first-stage bootloader.

---

# Symptoms

* “No bootable device”
* Boot loops into firmware
* Secure Boot violation error
* OS still intact but unreachable

---

# Recovery

1. Boot from live USB
2. Run:

```
fsck.vfat /dev/sdX1
```

3. If ESP badly damaged:

   * Reformat ESP as FAT32
   * Reinstall bootloader

---

## Important

FAT corruption does NOT damage:

* Your root filesystem
* Your home files

It only blocks boot path.

---

### Simple View

FAT on ESP = front door
If door breaks → house still exists
but you cannot enter.



Kernel module signing protects the kernel from loading unauthorized code (especially when Secure Boot is enabled).

Attackers try to bypass it in several ways:

---

## 1️⃣ Disable Secure Boot

If attacker gains firmware access:

* Turn off Secure Boot
* Kernel stops enforcing signature checks
* Unsigned modules can load

Requires physical or admin access.

---

## 2️⃣ Use a Signed but Vulnerable Bootloader

Exploit a trusted, signed loader (example old GRUB bug):

* Load malicious kernel
* Bypass signature enforcement

This is called **bootloader downgrade attack**.

---

## 3️⃣ Exploit Kernel Vulnerabilities

If attacker gains root via exploit:

* Patch kernel memory
* Disable module signature enforcement flag
* Load unsigned module

Common target:
`module_sig_enforced` variable in memory.

---

## 4️⃣ Use Signed Malicious Module

If attacker steals a private signing key:

* Sign malicious module legitimately
* Kernel accepts it

Rare but very dangerous.

---

## 5️⃣ Abuse DKMS / Local Signing

On Linux systems:

* Local Machine Owner Key (MOK) used by shim
* Attacker enrolls their own key
* Signs malicious module

Requires admin privileges.

---

## 6️⃣ Direct Kernel Memory Attack

If attacker has:

* DMA access
* Physical access
* Hardware attack

They may inject code without loading a module.

---

# Why It’s Hard

When Secure Boot + lockdown mode enabled:

* Kernel refuses unsigned modules
* Even root cannot bypass easily
* Signature verified cryptographically

---

## Core Idea

Module signing stops:

✔ Persistent rootkits
✔ Boot-time kernel malware

Attackers must either:

* Break firmware trust
* Break kernel security
* Steal signing keys

Otherwise, bypass is very difficult.



TPM + Measured Boot does **not block** code.
It **records hashes** so tampering can be detected later.

Used with Trusted Platform Module and Secure Boot.

---

# Core Idea

Every important boot component is:

1. Hashed (SHA-256 usually)
2. Hash extended into TPM PCR register
3. Stored permanently until reboot

This creates a **tamper-evident chain**.

---

# During Boot (Step by Step)

## 1️⃣ Firmware stage

UEFI hashes:

* Firmware code
* Bootloader (e.g. shim)
* GRUB

Extends into PCR[0–7].

---

## 2️⃣ Kernel stage

Linux IMA (Integrity Measurement Architecture):

* Hashes kernel image
* Hashes each loaded kernel module
* Hashes important files (optional)

Each hash is:

```
PCR_new = SHA256(PCR_old || new_hash)
```

This is called a **PCR extend** operation.

PCR cannot be rewritten — only extended.

---

# Where Module Hashes Go

* IMA measures module file before loading
* Hash recorded in:

  * TPM PCR (usually PCR[10])
  * IMA measurement log (`/sys/kernel/security/ima/ascii_runtime_measurements`)

TPM stores only cumulative value.
Log stores individual hashes.

---

# Why This Matters

If attacker:

* Loads malicious module
* Modifies kernel

PCR value changes.

Remote attestation server can:

* Request TPM quote
* Compare PCR values to known-good baseline
* Detect compromise

---

# Important Difference

Secure Boot → prevents unsigned modules
Measured Boot → records what was actually loaded

One blocks.
One audits.

---

# Simple View

Module loads →
Kernel hashes it →
TPM extends PCR →
Tampering becomes cryptographically visible.


Integrity Measurement Architecture (IMA) extends Measured Boot from **boot components** to the **entire runtime system**.

TPM alone records early boot.
IMA records what happens *after* the kernel starts.

---

# 1️⃣ Measures Files at Runtime

IMA can hash:

* Kernel modules
* Executables (`/bin`, `/usr/bin`)
* Shared libraries
* Config files
* Scripts

Every time a file is opened for execution or read.

Each hash is:

* Logged
* Extended into TPM PCR (often PCR 10)

---

# 2️⃣ Creates a Measurement Log

Stored in:

```
/sys/kernel/security/ima/ascii_runtime_measurements
```

This contains:

* File path
* Hash
* PCR index

TPM keeps only final cumulative PCR value.
IMA log keeps full history.

---

# 3️⃣ Adds Appraisal (Not Just Measurement)

IMA can enforce signature verification.

If enabled:

* File must be signed
* Hash must match stored value
* Unsigned file → execution blocked

This goes beyond passive measurement.

---

# 4️⃣ Protects Against Runtime Tampering

Without IMA:

* Attacker modifies `/bin/ls`
* System runs it silently

With IMA appraisal:

* Hash mismatch detected
* Execution denied

---

# 5️⃣ Enables Remote Attestation

Server can:

1. Request TPM quote
2. Get PCR values
3. Compare against approved baseline
4. Decide if system is trusted

This works even after boot.

---

# Full Protection Chain

Firmware → Secure Boot → Kernel → IMA → TPM

Secure Boot = enforce trust at boot
Measured Boot = record boot hashes
IMA = record and optionally enforce runtime integrity

---

## Simple View

TPM = secure notebook
Measured Boot = writes boot hashes
IMA = keeps writing everything important during system life

It turns the whole OS into a measurable, auditable system.




## BootHole (CVE-2020-10713)

BootHole was a flaw in GRUB that allowed bypassing Secure Boot — even though everything was properly signed.

---

# Core Problem

GRUB parsed its configuration file:

```
grub.cfg
```

But:

* `grub.cfg` is **not signed**
* GRUB trusted it
* Parser had a **buffer overflow bug**

Attacker could modify `grub.cfg` and trigger memory corruption.

---

# How It Worked (Technically)

### 1️⃣ Secure Boot loads signed GRUB

UEFI verifies signature → GRUB allowed.

---

### 2️⃣ Attacker modifies grub.cfg

ESP is usually writable from OS.

Attacker places:

* Maliciously long command
* Special crafted syntax

Example concept:

```
menuentry 'AAAAA...(very long)...'
```

This overflowed an internal buffer.

---

### 3️⃣ Buffer Overflow Occurs

GRUB’s config parser:

* Copied input into fixed-size buffer
* No proper bounds checking
* Overflow overwrote memory

This allowed:

* Code execution inside GRUB context

---

### 4️⃣ Load Unsigned Kernel

After gaining control:

* Disable verification logic
* Load unsigned kernel
* Secure Boot bypassed

Because attack happened *inside* trusted GRUB.

---

# Why It Was Serious

* GRUB is signed by Microsoft
* Used by many Linux distributions
* Exploit worked even with Secure Boot ON
* Persisted below OS level

---

# Fix

Vendors:

* Patched GRUB parser
* Revoked vulnerable GRUB versions in UEFI dbx (revocation list)
* Updated shim + GRUB packages

---

# Key Lesson

Secure Boot verifies binaries.
It does NOT verify configuration files.

If signed code has parsing bugs →
trust chain collapses.

---

## Simple View

Secure Boot → “Is GRUB signed?” ✔
BootHole → “GRUB signed, but exploitable.”

Signed ≠ safe if code has vulnerability.




Firmware rootkits live **below the OS and bootloader**.
They modify firmware itself, not just disk files.

Secure Boot verifies bootloaders —
but does **not** verify firmware integrity at runtime.

---

# How They Persist

## 1️⃣ Modify SPI Flash Firmware

UEFI firmware is stored in SPI flash chip.

Attacker:

* Gains kernel-level access
* Uses firmware update interface
* Rewrites part of firmware image
* Inserts malicious DXE driver

Now malware runs **before Secure Boot**.

Secure Boot trusts firmware completely.

---

## 2️⃣ Insert Malicious DXE Driver

During boot:

UEFI loads DXE drivers from firmware volume.

Malicious DXE can:

* Hook disk reads
* Modify bootloader in memory
* Patch kernel before execution

Secure Boot never sees this modification.

---

## 3️⃣ Modify NVRAM Variables

Attackers can:

* Add hidden `Boot####` entry
* Change BootOrder
* Enroll malicious keys

If firmware protection is weak → persists across reinstalls.

---

## 4️⃣ Exploit Firmware Update Mechanism

Some vendors:

* Don’t verify capsule updates properly
* Allow unsigned firmware flashing

Attacker installs backdoored firmware image.

---

## 5️⃣ SMM (System Management Mode) Abuse

SMM runs at higher privilege than OS.

Malicious firmware can:

* Inject code into kernel memory
* Hide itself from OS detection

This is extremely stealthy.

---

# Why Secure Boot Doesn't Stop It

Secure Boot assumes:

Firmware = trusted root.

If firmware is compromised →
entire trust chain collapses.

---

# Real Examples

* LoJax (UEFI rootkit)
* MoonBounce (SPI firmware implant)

These survived:

* Disk formatting
* OS reinstall
* Bootloader replacement

---

# Defense Mechanisms

* Firmware write protection
* Boot Guard (CPU-level firmware verification)
* TPM Measured Boot
* Firmware integrity checks

---

## Simple View

Secure Boot protects **above firmware**.
Firmware rootkits live **below Secure Boot**.

If root of trust is infected →
everything above can be silently controlled.


TPM sealing ties a secret (like a disk key) to specific boot measurements.

Uses Trusted Platform Module with Measured Boot.

---

# Core Idea

Secret is stored in TPM in **sealed form**.

It can only be released if:

PCR values match expected measurements.

If anything changes → TPM refuses.

---

# How It Works (Step by Step)

## 1️⃣ During Setup

Disk encryption key (for LUKS, BitLocker, etc.) is:

* Generated
* Sealed inside TPM
* Bound to selected PCRs (e.g. PCR 0, 7, 10)

TPM stores:

```
Encrypted key + PCR policy
```

---

## 2️⃣ During Boot

Measured Boot records hashes of:

* Firmware
* Bootloader
* Kernel
* (Optional) IMA runtime data

PCR registers are extended.

---

## 3️⃣ Key Unseal Attempt

System asks TPM:

“Release disk key.”

TPM checks:

* Do current PCR values match sealed policy?

If yes → returns key
If no → refuses

---

# What Changes PCR?

* Modified firmware
* Different bootloader
* Tampered kernel
* Secure Boot state change

Even one hash difference → different PCR value.

---

# Example Scenario

Attacker:

* Copies encrypted disk
* Boots with modified GRUB
* Tries to decrypt

PCR values differ →
TPM will not release key.

Disk remains locked.

---

# Why This Is Strong

PCR values cannot be rewritten manually.

They are:

```
PCR_new = SHA256(PCR_old || measurement)
```

This makes rollback impossible without reset.

---

# Real Usage

* Linux with LUKS2 + TPM2
* Windows BitLocker
* Enterprise remote attestation

---

## Simple View

TPM sealing =

“Only unlock disk if system booted exactly as expected.”

Change boot chain →
no key → no decryption.


Measured Boot (with Trusted Platform Module) does not block execution — it records hashes.
Attackers try to avoid, fake, or neutralize those measurements.

---

## 1️⃣ Disable TPM / Clear PCR Use

If attacker has admin or firmware access:

* Disable TPM in BIOS
* Clear TPM
* Remove sealing requirement
* Boot without PCR binding

Works only if system policy is weak.

---

## 2️⃣ Boot with Same Measurements (Evil but Identical)

If attacker can:

* Use same signed bootloader
* Use same kernel version
* Avoid changing measured files

PCR values remain identical.

Measured Boot cannot detect attacks that reuse trusted components.

---

## 3️⃣ Attack After Measurement

Measured Boot records what was loaded.

Attacker may:

* Exploit kernel vulnerability *after* boot
* Inject code into memory
* Avoid modifying measured files

PCR remains valid.

---

## 4️⃣ Compromise Firmware (Below Measurement)

If firmware itself is malicious:

* It can fake measurements
* Extend fake hashes into PCR
* Hide modifications

Since firmware measures first — root compromise breaks trust.

---

## 5️⃣ Replay / Fake TPM Quote (Advanced)

In remote attestation scenarios:

* Malware intercepts TPM quote
* Replays old valid PCR quote

Mitigation: nonce-based challenge.

---

## 6️⃣ Exploit Weak PCR Selection

If disk key sealed only to PCR7 (Secure Boot state):

Attacker might:

* Keep Secure Boot enabled
* Modify kernel modules (not included in selected PCRs)

Improper PCR policy weakens protection.

---

# Important Limitation

Measured Boot:

✔ Detects boot-time tampering
❌ Does not prevent runtime exploits
❌ Does not stop in-memory attacks

It is an auditing system, not a firewall.

---

## Real Defense Requires

* Secure Boot (enforcement)
* TPM sealing
* IMA appraisal
* Firmware protections
* Regular attestation validation

---

## Simple View

Measured Boot records reality.
Attackers try to:

* Avoid being measured
* Match expected measurements
* Attack after measurement
* Break root of trust

If firmware or policy is weak → bypass becomes possible.




Integrity Measurement Architecture (IMA) measures executables using **kernel hooks** in the file access path.

It does this automatically inside the kernel — not user space.

---

# 1️⃣ Kernel Hook on File Open

When a process tries to:

* `execve()` (run a program)
* `insmod` (load module)
* Access protected file

Kernel calls:

```
security_file_open()
```

IMA is hooked into Linux Security Module (LSM) framework.

---

# 2️⃣ Policy Decides What to Measure

IMA policy file (example):

```
/etc/ima/ima-policy
```

Common rule:

```
measure func=BPRM_CHECK
```

Meaning:

Measure every binary executed.

Other rules can measure:

* Modules
* Firmware files
* Libraries
* Config files

---

# 3️⃣ Hash Calculation

Before execution:

1. Kernel reads file
2. Computes hash (SHA-256 default)
3. Creates measurement entry

Hash includes file contents only.

---

# 4️⃣ Extend to TPM

If TPM enabled:

```
PCR_new = SHA256(PCR_old || file_hash)
```

Usually extended into PCR 10.

This makes measurements tamper-evident.

---

# 5️⃣ Store in Measurement Log

Runtime log:

```
/sys/kernel/security/ima/ascii_runtime_measurements
```

Each line contains:

* PCR index
* Hash algorithm
* File hash
* File path

Example entry:

```
10 sha256:abcd1234... /usr/bin/bash
```

---

# 6️⃣ Optional: Appraisal Mode

IMA can also enforce:

* File must be signed
* Hash must match xattr value
* Otherwise execution blocked

This is stronger than just measuring.

---

# Important Behavior

IMA measures at:

* Execution time
* Module load time
* File access time (if configured)

It does NOT constantly scan disk.
It measures when files are used.

---

# Limitations

* In-memory tampering after load not re-measured
* Kernel memory attacks bypass measurement
* Requires correct policy configuration

---

## Simple View

Process runs binary →
Kernel intercepts →
File hashed →
Hash logged →
PCR extended

Every executed file leaves a cryptographic trace.



BitLocker uses Trusted Platform Module to protect the disk encryption key by **sealing it to PCR values**.

---

# Core Idea

Disk is encrypted with a **Volume Master Key (VMK)**.

The VMK is:

* Encrypted
* Sealed inside TPM
* Bound to specific PCR measurements

If boot state changes → TPM refuses to release VMK.

---

# Step-by-Step Flow

## 1️⃣ During Setup

BitLocker:

1. Generates VMK
2. Encrypts disk sectors with Full Volume Encryption Key (FVEK)
3. Seals VMK to TPM with selected PCRs

Common PCR bindings:

* PCR 0 → Firmware
* PCR 2 → Option ROMs
* PCR 4 → Bootloader
* PCR 7 → Secure Boot state

---

## 2️⃣ Normal Boot

Measured Boot records:

* Firmware
* Boot manager
* Boot configuration
* Secure Boot state

PCR values match what was sealed.

TPM releases VMK automatically.

User sees no password prompt.

---

## 3️⃣ If Something Changes

Examples:

* Secure Boot disabled
* Bootloader modified
* Firmware updated
* Disk moved to another machine

PCR values differ.

TPM refuses to unseal VMK.

System asks for **Recovery Key**.

---

# Why This Is Strong

Attacker cannot:

* Copy disk to another PC
* Modify bootloader silently
* Disable Secure Boot unnoticed

Without correct PCR state → no key.

---

# Recovery Mode

If legitimate change happens:

* Firmware update
* BIOS reset

User enters 48-digit recovery key
System reseals VMK to new PCR values.

---

# Important Limitation

If attacker has:

* Full admin access while system running
* DMA attack while unlocked

They can extract keys from memory.

TPM sealing protects **at boot**, not after unlock.

---

## Simple View

BitLocker =

“Unlock disk only if system booted exactly as expected.”

Change boot chain → TPM blocks → recovery required.


Attackers try to fake Trusted Platform Module PCR values to trick systems like BitLocker into releasing sealed keys.

They **cannot directly modify PCRs** — TPM hardware prevents that.
So they attack the measurement process instead.

---

## 1️⃣ Boot Before Measurement (Pre-measurement attacks)

If malicious code runs **before** PCR extension happens:

* It can measure clean code
* Then execute malicious payload afterward

Example: modify bootloader but keep measured part untouched.

---

## 2️⃣ Evil Maid Attack

Attacker with physical access:

* Replaces bootloader
* Tricks user to enter recovery key
* Captures it

No PCR faking — just bypass via social engineering.

---

## 3️⃣ Firmware-Level Implants

Malicious UEFI firmware:

* Controls what gets measured
* Can extend fake hashes into PCRs

If firmware itself is compromised, trust chain breaks.

---

## 4️⃣ TPM Emulation / Virtual TPM Abuse

In VMs:

* If attacker controls hypervisor
* They can fake virtual TPM PCR values

Real hardware TPMs resist this.

---

## 5️⃣ Replay Attacks (Old PCR State)

If system does not use proper anti-replay protections:

* Previously valid PCR state may be replayed
* TPM releases sealed secret

Modern TPM 2.0 prevents most replay scenarios.

---

## 6️⃣ DMA or Memory Attacks After Unlock

Attacker waits until:

* System boots normally
* TPM releases key

Then extracts encryption keys from RAM.

PCRs weren’t faked — protection bypassed after boot.

---

# Why Direct PCR Forging Is Nearly Impossible

PCR extension formula:

```
PCR_new = HASH(PCR_old || new_measurement)
```

Because of chaining:

* You cannot set arbitrary value
* You must replay entire correct measurement chain

And TPM does not allow manual PCR writes.

---

# Strongest Protection

To resist PCR faking:

* Secure Boot enabled
* Firmware protected
* TPM 2.0 hardware (not emulated)
* Measured Boot enabled
* Physical security enforced

---

## Simple View

Attackers don’t “change PCR numbers.”
They try to:

* Control what gets measured
* Run code before measurement
* Steal keys after TPM unlock

Real hardware TPM + clean firmware makes PCR faking extremely difficult.


To check PCR values in Linux, you query the Trusted Platform Module directly.

---

## 1️⃣ Check if TPM exists

```
ls /dev/tpm*
```

If you see `/dev/tpm0`, TPM is present.

---

## 2️⃣ Install TPM2 tools

Package:

```
tpm2-tools
```

---

## 3️⃣ Read All PCRs

For TPM 2.0:

```
tpm2_pcrread
```

Example output:

```
sha256:
  0 : 3A5F...
  1 : 9C12...
  7 : B81D...
  10: 7F4A...
```

Common PCR meanings:

* PCR 0 → Firmware
* PCR 2 → Option ROM
* PCR 4 → Bootloader
* PCR 7 → Secure Boot
* PCR 10 → IMA measurements

---

## 4️⃣ Read Specific PCR

Example:

```
tpm2_pcrread sha256:7
```

---

## 5️⃣ Check IMA Measurement Log

If using Integrity Measurement Architecture:

```
cat /sys/kernel/security/ima/ascii_runtime_measurements
```

These hashes are extended into PCR 10.

---

## 6️⃣ Verify Secure Boot State

```
mokutil --sb-state
```

PCR 7 changes if Secure Boot changes.

---

## Simple Summary

```
tpm2_pcrread
```

= shows your machine’s boot integrity fingerprints.

If PCR values change unexpectedly → something in boot chain changed.


Here’s the simple full picture:

Linux boot with **UEFI + GPT + GRUB** is a chain of components working together.

---

# 1️⃣ Disk Layout (GPT)

Disk uses **GPT (GUID Partition Table)**.

Typical layout:

* EFI System Partition (ESP) → FAT32
* Linux root partition (ext4, btrfs, etc.)

ESP contains bootloaders.

---

# 2️⃣ UEFI Firmware

When PC powers on:

UEFI firmware:

1. Reads GPT
2. Finds the EFI System Partition
3. Looks for a boot entry in NVRAM (Boot####)
4. Loads an `.efi` file from ESP

Example path:

```
\EFI\ubuntu\grubx64.efi
```

---

# 3️⃣ GRUB EFI Binary

That file is:

GNU GRUB compiled as a UEFI application (PE/COFF format).

UEFI executes it like a program.

No MBR stage.
No BIOS real mode.
It runs in 64-bit UEFI environment.

---

# 4️⃣ What GRUB Does

GRUB:

1. Loads its modules
2. Reads `/boot/grub/grub.cfg`
3. Displays boot menu
4. Loads Linux kernel (`vmlinuz`)
5. Loads initramfs
6. Calls `ExitBootServices()`
7. Jumps to kernel

---

# 5️⃣ Kernel Takes Over

Linux kernel:

* Initializes memory
* Mounts root filesystem
* Starts init system

Boot complete.

---

# How GPT, UEFI, and GRUB Connect

| Component | Role                     |
| --------- | ------------------------ |
| GPT       | Defines partitions       |
| ESP       | Stores `.efi` bootloader |
| UEFI      | Loads EFI executable     |
| GRUB      | Loads Linux kernel       |

GPT does NOT load GRUB.
UEFI does.

---

# Secure Boot Case

If Secure Boot enabled:

UEFI verifies signature of:

* `grubx64.efi`
* Kernel (if shim used)

Common chain:

Firmware → shim → GRUB → kernel

Shim example:

Shim (bootloader)

---

# Important Distinction

Old BIOS boot:
MBR → GRUB stage1 → stage2

Modern UEFI boot:
UEFI → EFI file → GRUB → kernel

No embedding in first sectors needed.

---

# Minimal Summary

GPT = disk map
ESP = bootloader storage
UEFI = loader
GRUB = kernel launcher
Linux = operating system

All independent but chained together cleanly.



Here’s what happens when **GPT or ESP is corrupted** and how UEFI tries to handle it:

---

# 1️⃣ GPT Header Corruption

* GPT stores **primary header at LBA 1** and **backup header at the last LBA**.
* If **primary header** is corrupted:

  * Firmware may still read **backup header**.
  * UEFI checks CRC32 of header and partition entries.
  * If backup is valid → firmware uses it to reconstruct primary.
  * If both are corrupted → firmware cannot locate partitions → boot fails.

**Symptoms:**

* “No bootable device”
* GRUB `.efi` not found
* Recovery shell may appear

---

# 2️⃣ EFI System Partition (ESP) Corruption

ESP is FAT32 and stores bootloaders (`.efi`):

* **Directory entry corrupted:** bootloader file not found
* **FAT table corrupted:** file partially readable → Secure Boot may fail (signature check)
* **Boot sector damaged:** ESP unreadable → UEFI cannot access any `.efi` file

**Symptoms:**

* Boot entry fails
* “No bootable device”
* System drops to firmware setup or recovery

---

# 3️⃣ UEFI Automatic Recovery

UEFI can attempt recovery:

1. **Check backup GPT** if primary corrupted
2. **Scan ESP partitions** for default bootloader path:

```
\EFI\BOOT\BOOTX64.EFI
```

3. **Fallback to other Boot#### entries** stored in NVRAM
4. **Prompt user** for recovery media if nothing valid

Some firmware vendors also:

* Repair GPT header using backup automatically
* Rebuild BootOrder entries if missing

---

# 4️⃣ Limitations

* Only works if **backup GPT or ESP files are intact**
* Does **not recover Linux root partition** or user files
* If ESP FAT corrupted beyond repair → manual recovery needed (live USB + `fsck.vfat` or restore `.efi` files)

---

# 5️⃣ Summary

| Component      | Corruption Effect                  | Automatic Recovery               |
| -------------- | ---------------------------------- | -------------------------------- |
| GPT header     | Disk map lost                      | Use backup header                |
| ESP (FAT32)    | Bootloader not found or unreadable | Scan default path, NVRAM entries |
| Both corrupted | System unbootable                  | Requires manual intervention     |

**Simple analogy:**

* GPT = house address → lost → firmware checks backup address
* ESP = front door → damaged → firmware tries default door
* If both gone → you need a new key (recovery disk)

---

This shows why **UEFI + GPT + backup headers + standard ESP paths** are resilient to minor corruption.



Here’s how x86/x86_64 CPUs use **GDT + paging** together to safely access memory beyond 4 GB:

---

# 1️⃣ GDT (Global Descriptor Table)

* GDT defines **segments** in memory.

* Each segment has:

  ```
  Base, Limit, Access Rights
  ```

* On modern 32/64‑bit OS:

  * **Flat memory model**: all segments start at 0, span full 4 GB (or 64 bit in x86_64)
  * Segment **selector** in CS/DS/ES/SS registers tells CPU which GDT entry to use.

**Purpose:** defines privilege and allowed access (kernel/user, code/data), not actual physical memory mapping.

---

# 2️⃣ Paging (Page Tables)

Paging provides **virtual-to-physical memory translation**.

* Virtual addresses = used by programs
* Physical addresses = actual RAM locations

CPU uses **page directory + page tables**:

* 32‑bit: 2‑level paging (page directory → page table → 4 KB page)
* 64‑bit: 4‑level paging (PML4 → PDPT → PD → PT → 4 KB page)

Paging allows:

* Access to >4 GB memory
* Memory isolation between processes
* Kernel/user separation

---

# 3️⃣ How They Work Together

1. CPU gets a **virtual address** from instruction.

2. Segment selector from GDT is applied:

   ```
   linear_address = base_of_segment + virtual_offset
   ```

   * In flat model, base = 0 → linear_address = virtual_address

3. CPU passes **linear_address** to **paging unit**

4. Paging unit translates linear_address → physical_address using page tables

5. Memory access happens

---

# 4️⃣ Safety and Protection

* **GDT**:

  * Enforces **privilege levels** (ring 0 = kernel, ring 3 = user)
  * Protects code/data access across segments

* **Paging**:

  * Enforces **virtual memory isolation**
  * Prevents access to unallocated physical memory
  * Supports copy-on-write, memory-mapped files, and >4 GB addressing

Together:

* GDT controls **what types of memory are allowed per segment**
* Paging controls **which actual physical addresses are reachable**

---

# 5️⃣ 4 GB+ Memory Access

* Without paging: 32‑bit virtual addresses → max 4 GB directly
* With paging:

  * OS can map **linear addresses >4 GB** to physical memory above 4 GB
  * CPU never accesses physical addresses directly
  * Multiple virtual regions can point to same physical memory safely

---

# 6️⃣ Modern OS Use

* Linux / Windows:

  * Flat segments (GDT)
  * Full paging with PAE (32‑bit) or x86_64 4‑level paging
  * Kernel accesses high memory safely
  * User processes cannot touch kernel memory

---

## Simple View

```
Virtual Address
   │
   ▼
GDT Segment Base Added
   │
   ▼
Linear Address
   │
   ▼
Page Tables Translate
   │
   ▼
Physical Address → RAM
```

* GDT → **permissions & privilege**
* Paging → **memory mapping & isolation**
* Together → CPU safely uses >4 GB memory.


The **Global Descriptor Table (GDT)** is a special CPU data structure on x86/x86_64 systems that defines **memory segments** and access rights.

---

# 1️⃣ Purpose

* Specifies **base address**, **limit**, and **access permissions** for each memory segment.
* Controls **privilege levels** (kernel vs user).
* Works with **segment registers**: CS, DS, ES, SS, FS, GS.

On modern OSes, GDT usually implements a **flat memory model**:

* All segments start at base = 0
* Limit = full 4 GB (32-bit) or 64-bit addressable space
* Segment registers mainly enforce **privilege** rather than physical memory bounds.

---

# 2️⃣ Structure of a GDT Entry (Descriptor)

Each entry (8 bytes) contains:

| Field                              | Purpose                                               |
| ---------------------------------- | ----------------------------------------------------- |
| Base (24 bits / 32 bits in 64-bit) | Starting address of segment                           |
| Limit (20 bits)                    | Size of segment                                       |
| Access byte                        | Segment type (code/data), privilege ring, present bit |
| Flags                              | Granularity, size (16/32-bit), long mode              |

Example access byte:

* 0x9A → code segment, executable, readable, ring 0
* 0x92 → data segment, writable, ring 0

---

# 3️⃣ How CPU Uses GDT

1. CPU uses **segment selector** in registers (CS/DS/ES/SS).
2. Selector points to a GDT entry.
3. CPU applies:

```
linear_address = base_of_segment + offset
```

4. Linear address then goes through **paging** to map to physical memory.

---

# 4️⃣ Modern Usage

* Flat memory model: base=0, limit=max → segments are transparent
* Segments still enforce **ring protection** (kernel vs user)
* FS/GS used for thread-local storage in 64-bit Linux

---

# 5️⃣ Summary

* GDT = table of **segment descriptors**
* Defines **where segments start, how big, and who can access**
* Works together with **paging** for memory safety and protection

**Analogy:** Think of GDT as a **permission and address map** for different “zones” in memory.




Here’s how **GPT (GUID Partition Table)** stores partition entries:

---

# 1️⃣ Partition Entry Array

* GPT reserves **a table of partition entries** immediately after the GPT header.
* Each entry describes **one partition** on the disk.
* The size and number of entries are defined in the GPT header:

```
Number of entries (usually 128)
Size of each entry (usually 128 bytes)
```

* Total table size = 128 × 128 B = 16 KB by default.

---

# 2️⃣ Structure of a Partition Entry

Each entry (128 B typical) contains:

| Field                 | Size                   | Purpose                              |
| --------------------- | ---------------------- | ------------------------------------ |
| Partition Type GUID   | 16 B                   | Type of partition (e.g., EFI, Linux) |
| Unique Partition GUID | 16 B                   | Unique ID for this partition         |
| Starting LBA          | 8 B                    | First sector of the partition        |
| Ending LBA            | 8 B                    | Last sector of the partition         |
| Attributes            | 8 B                    | Flags (bootable, read-only, hidden)  |
| Partition Name        | 72 B (36 UTF-16 chars) | Human-readable name                  |

---

# 3️⃣ Primary vs Backup

* **Primary GPT**:

  * Header at LBA 1
  * Partition entries at LBA 2…

* **Backup GPT**:

  * Header at last LBA
  * Partition entries before that

* CRC32 checksums in headers validate the integrity of partition entries.

---

# 4️⃣ How Firmware Uses It

1. UEFI reads GPT header
2. Verifies CRC
3. Loads partition table into memory
4. Uses entries to find **ESP**, root partitions, or other boot targets

---

# 5️⃣ Simple View

```
Disk layout (GPT):

LBA 0: Protective MBR
LBA 1: GPT Header (primary)
LBA 2–33: Partition Entries (primary)
...
Last LBA-33–Last LBA-1: Partition Entries (backup)
Last LBA: GPT Header (backup)
```

Each entry = **128 B descriptor** pointing to a partition with GUID, start/end LBA, attributes, and name.

---

This structure makes GPT:

* **Self-describing**
* **Resilient** (backup header/table)
* **Extensible** (can store hundreds of partitions)



Here’s a clear breakdown of how **UEFI boot** works:

---

# 1️⃣ Power-On and Firmware Initialization

1. CPU powers on → **UEFI firmware** starts.
2. Firmware initializes hardware:

* Memory controller
* PCI devices
* CPU cores
* Optional peripherals

3. Firmware may run **POST** (Power-On Self Test) checks.

---

# 2️⃣ Read Boot Entries

UEFI stores boot entries in **NVRAM**:

* `Boot####` entries → point to `.efi` files on ESP (EFI System Partition)
* Example:

```
\EFI\ubuntu\grubx64.efi
```

* BootOrder list determines which entry to try first.

---

# 3️⃣ Find EFI System Partition (ESP)

* ESP is **FAT32 partition** with type GUID `EFI System Partition`
* Firmware scans ESP for default loader if Boot#### entries fail:

```
\EFI\BOOT\BOOTX64.EFI
```

* All `.efi` files are **PE/COFF binaries**.

---

# 4️⃣ Secure Boot Check (Optional)

If Secure Boot is enabled:

1. Firmware verifies the digital signature of `.efi` file.
2. Checks signature against **db (allowed)** and **dbx (revoked)** key databases.
3. Only trusted `.efi` files are executed.

---

# 5️⃣ Execute EFI Binary

* Firmware loads `.efi` binary into memory
* Performs relocations if needed
* Calls entry point

Example: GRUB (`grubx64.efi`) is loaded this way.

---

# 6️⃣ Bootloader Phase

GRUB or another EFI bootloader:

1. Loads configuration (`grub.cfg`)
2. Displays menu
3. Loads **kernel (`vmlinuz`)** and **initramfs**
4. Optionally verifies kernel signature (shim/IMA)
5. Calls `ExitBootServices()`

---

# 7️⃣ Kernel Takes Over

* Kernel initializes memory, devices, mounts root filesystem
* Starts user-space init process
* Boot complete

---

# 8️⃣ Automatic Recovery

If boot fails:

* UEFI tries backup `.efi` in ESP
* Checks other Boot#### entries
* Can prompt user for recovery media

---

# 9️⃣ Key Points

| Feature        | Role                      |
| -------------- | ------------------------- |
| NVRAM Boot#### | Stores boot paths         |
| ESP            | Stores `.efi` binaries    |
| PE/COFF        | Format of EFI executables |
| Secure Boot    | Verifies authenticity     |
| Bootloader     | Loads OS kernel           |

---

## Simple View

```
Power on → Firmware → Check NVRAM → Load EFI binary → Bootloader → Kernel → OS
```

UEFI replaces old BIOS + MBR chain with **partition-independent, secure, and flexible boot system**.


**Real mode** is the CPU’s initial operating mode on x86 systems, used at boot before protected mode or long mode.

---

# 1️⃣ Characteristics

* **16-bit registers** (AX, BX, CX, DX, SP, BP, SI, DI)
* **1 MB addressable memory** (20-bit address space)
* **Segment:Offset addressing**:

```
physical_address = segment * 16 + offset
```

* No memory protection
* No multitasking support
* No paging or privilege levels

---

# 2️⃣ How CPU Enters Real Mode

* After power-on or reset, x86 CPU starts in **real mode**
* Executes instructions at **0xFFFF0** (BIOS entry)
* Firmware and bootloader code initially run here

---

# 3️⃣ Segment:Offset Addressing

Memory accessed using **segment registers** (CS, DS, ES, SS):

* Example: `CS:IP = 0xF000:0xFFF0` → physical address = 0xFFFF0
* Overlapping segments allow addressing all 1 MB memory with 16-bit offsets

---

# 4️⃣ Limitations

* Only 1 MB memory accessible
* No hardware-enforced protection
* Only 16-bit instructions
* Cannot use modern CPU features directly (paging, 32/64-bit registers)

---

# 5️⃣ Transition Out of Real Mode

* Bootloader switches CPU to **protected mode** (32-bit)
* Later, OS may switch to **long mode** (64-bit) for full memory and features

---

## Simple View

```
Power-on → CPU in real mode → BIOS/bootloader executes → switch to protected/long mode → OS
```

* Real mode = **simple, flat 1 MB memory, no protection**
* Used only at **early boot**, legacy support, or DOS programs.



Here’s how an x86 CPU switches from **real mode** to **protected mode**:

---

# 1️⃣ Prepare a Global Descriptor Table (GDT)

* CPU needs **GDT** before entering protected mode.
* GDT defines **code/data segments**, their base, limit, and access rights.
* Typically, a **flat memory model** is used:

```
CS = 0x0000, base=0, limit=4GB
DS/SS/ES = same
```

* Load GDT using **LGDT instruction**:

```
lgdt [gdt_descriptor]
```

---

# 2️⃣ Set the PE (Protection Enable) Bit

* PE bit is bit 0 of **CR0 register**.
* To enable protected mode:

```asm
mov eax, cr0
or  eax, 1      ; set PE bit
mov cr0, eax
```

* CPU now enters **protected mode**.
* Still using **old segment registers** until reloaded.

---

# 3️⃣ Far Jump to Flush Pipeline

* Immediately after setting PE:

```asm
jmp CODE_SEG:flush_label
flush_label:
```

* Forces CPU to reload **CS register** with new GDT selector.
* Ensures proper segment descriptors are used.

---

# 4️⃣ Reload Segment Registers

* Load **DS, ES, FS, GS, SS** with appropriate segment selectors:

```asm
mov ax, DATA_SEG
mov ds, ax
mov es, ax
mov ss, ax
```

* Now all segments use **protected mode descriptors**.

---

# 5️⃣ Optional: Enable Paging

* In protected mode, you can optionally enable **paging** for virtual memory.
* Set CR3 with page directory base, then set **PG bit** in CR0.

---

# 6️⃣ Summary of Steps

1. Prepare GDT in memory
2. Load GDT (`LGDT`)
3. Set PE bit in CR0
4. Far jump to flush CS
5. Reload all segment registers

---

## Simple View

```
Real Mode → (Setup GDT) → Set PE bit → Far jump → Reload segments → Protected Mode
```

* CPU now supports:

  * 32-bit instructions
  * Segmentation with protection
  * Paging (optional)
  * Privilege levels (rings 0–3)

Protected mode is the foundation for modern 32-bit OSes like Linux and Windows.



A **Protective MBR** is a special **Master Boot Record** used in **GPT-partitioned disks** to protect them from old software.

---

# 1️⃣ Purpose

* Legacy BIOS systems only understand **MBR** (up to 2 TB, 4 partitions).
* GPT disks use **LBA 1+ for headers and partition entries**, but old tools might see it as empty.
* **Protective MBR** marks the disk as **“used”** to prevent accidental overwrite.

---

# 2️⃣ How It Works

* Located at **LBA 0** (first sector of disk)

* Contains **one partition entry**:

  | Field          | Value/Meaning                                   |
  | -------------- | ----------------------------------------------- |
  | Partition type | 0xEE (GPT Protective)                           |
  | Starting LBA   | 1                                               |
  | Size           | Covers the entire disk (max 2 TB for old tools) |

* BIOS or old OS sees a single large partition and avoids overwriting GPT.

---

# 3️⃣ Interaction with UEFI

* UEFI ignores MBR except for **compatibility**.
* Reads GPT header at **LBA 1**.
* GPT header + backup entries are authoritative.

---

# 4️⃣ Key Points

* **Not used for booting** on modern systems
* Only serves to **protect GPT** from legacy MBR tools
* Always present on GPT disks

---

## Simple Analogy

* GPT = house with numbered rooms
* Protective MBR = “Reserved: do not touch” sign on the door for old visitors
* Old OS sees the disk as “occupied” and avoids overwriting it.


