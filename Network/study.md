
**BASIC**


255.255.255.240 (/28) → 16 addresses (14 usable hosts)
255.255.255.248 (/29) → 8 addresses (6 usable hosts)
255.255.255.252 (/30) → 4 addresses (2 usable hosts)


theoretically, **/30 (255.255.255.252) gives 4 addresses**, but only **2 are usable** because:  

1. **Network Address** (First IP) → **Not usable**  
2. **First Usable Host**  
3. **Second Usable Host**  
4. **Broadcast Address** (Last IP) → **Not usable**  

### Example: **192.168.0.0/30**  
| IP Address       | Purpose            | Usable? |
|------------------|--------------------|---------|
| 192.168.0.0     | Network Address    | ❌ No   |
| 192.168.0.1     | Usable Host 1      | ✅ Yes  |
| 192.168.0.2     | Usable Host 2      | ✅ Yes  |
| 192.168.0.3     | Broadcast Address  | ❌ No   |

So, you **get 4 total IPs, but only 2 usable hosts**. This is how IPv4 subnetting works.




Here’s the breakdown for **/28 (255.255.255.240)** and **/29 (255.255.255.248):  

### **/28 (255.255.255.240) → 16 addresses (14 usable hosts)**  
| IP Address Range | Purpose            | Usable? |
|------------------|--------------------|---------|
| x.x.x.0         | Network Address    | ❌ No   |
| x.x.x.1         | Usable Host 1      | ✅ Yes  |
| x.x.x.2         | Usable Host 2      | ✅ Yes  |
| ...             | ...                | ✅ Yes  |
| x.x.x.14        | Usable Host 14     | ✅ Yes  |
| x.x.x.15        | Broadcast Address  | ❌ No   |

### **/29 (255.255.255.248) → 8 addresses (6 usable hosts)**  
| IP Address Range | Purpose            | Usable? |
|------------------|--------------------|---------|
| x.x.x.0         | Network Address    | ❌ No   |
| x.x.x.1         | Usable Host 1      | ✅ Yes  |
| x.x.x.2         | Usable Host 2      | ✅ Yes  |
| x.x.x.3         | Usable Host 3      | ✅ Yes  |
| x.x.x.4         | Usable Host 4      | ✅ Yes  |
| x.x.x.5         | Usable Host 5      | ✅ Yes  |
| x.x.x.6         | Usable Host 6      | ✅ Yes  |
| x.x.x.7         | Broadcast Address  | ❌ No   |




### **255.255.255.0 (/24) Subnet Breakdown**  

- **Total IPs**: **256**  
- **Usable Hosts**: **254**  
- **Network Address**: **x.x.x.0** (Not usable)  
- **Broadcast Address**: **x.x.x.255** (Not usable)  

### **Example: 192.168.1.0/24**  
| IP Address Range  | Purpose            | Usable? |
|-------------------|--------------------|---------|
| 192.168.1.0      | Network Address    | ❌ No   |
| 192.168.1.1      | Usable Host 1      | ✅ Yes  |
| 192.168.1.2      | Usable Host 2      | ✅ Yes  |
| ...              | ...                | ✅ Yes  |
| 192.168.1.254    | Usable Host 254    | ✅ Yes  |
| 192.168.1.255    | Broadcast Address  | ❌ No   |

So, **/24 provides 254 usable host addresses**.



Here is a **full subnet mask list** with the **total addresses, usable hosts, and network count**:  

| **Subnet Mask**         | **CIDR** | **Total Addresses** | **Usable Hosts** | **Network Count in /24** |
|------------------------|---------|------------------|---------------|------------------|
| 255.255.255.0         | **/24**  | 256              | 254           | 1                |
| 255.255.255.128       | **/25**  | 128              | 126           | 2                |
| 255.255.255.192       | **/26**  | 64               | 62            | 4                |
| 255.255.255.224       | **/27**  | 32               | 30            | 8                |
| 255.255.255.240       | **/28**  | 16               | 14            | 16               |
| 255.255.255.248       | **/29**  | 8                | 6             | 32               |
| 255.255.255.252       | **/30**  | 4                | 2             | 64               |
| 255.255.255.254       | **/31**  | 2                | **2 (Point-to-Point)** | 128 |
| 255.255.255.255       | **/32**  | 1                | **0 (Single Host)** | 256 |

#### Larger Subnets:
| **Subnet Mask**         | **CIDR** | **Total Addresses** | **Usable Hosts** | **Network Count in /16** |
|------------------------|---------|------------------|---------------|------------------|
| 255.255.254.0         | **/23**  | 512              | 510           | 2                |
| 255.255.252.0         | **/22**  | 1024             | 1022          | 4                |
| 255.255.248.0         | **/21**  | 2048             | 2046          | 8                |
| 255.255.240.0         | **/20**  | 4096             | 4094          | 16               |
| 255.255.224.0         | **/19**  | 8192             | 8190          | 32               |
| 255.255.192.0         | **/18**  | 16,384           | 16,382        | 64               |
| 255.255.128.0         | **/17**  | 32,768           | 32,766        | 128              |
| 255.255.0.0           | **/16**  | 65,536           | 65,534        | 256              |




**255.255.255.255 (/32)** means **a single IP address** with **no other hosts in the network**.  

### What does this mean?  
- **1 total address (itself)**
- **0 usable hosts** (since there's no room for other devices)
- Used for **loopback interfaces, specific host routes, or point-to-point tunnels**  
- A device with **/32 cannot communicate** with other devices directly unless routing or NAT is used.

### **Internet Connection with /32?**  
If a device gets a **public IP with /32**, it can still access the **internet**, but:  
- It must use a **gateway/router** to send traffic outside.  
- Other systems **can't reach it directly** unless port forwarding or routing is configured.  

This is common in **VPNs, cloud servers, and ISP setups** where a single public IP is assigned but must route through a gateway.


**list of subnet classes** with their default subnet masks and address ranges:  

### **Classful IP Addressing:**  

| **Class** | **Starting IP Range**   | **Default Subnet Mask** | **CIDR** | **Total Hosts** |
|----------|---------------------|-----------------|------|--------------|
| **Class A** | 1.0.0.0 - 126.255.255.255  | 255.0.0.0  | /8  | 16,777,214 |
| **Class B** | 128.0.0.0 - 191.255.255.255 | 255.255.0.0 | /16 | 65,534 |
| **Class C** | 192.0.0.0 - 223.255.255.255 | 255.255.255.0 | /24 | 254 |
| **Class D** | 224.0.0.0 - 239.255.255.255 | **Reserved for Multicast** | N/A | N/A |
| **Class E** | 240.0.0.0 - 255.255.255.255 | **Experimental & Research** | N/A | N/A |

### **Subnet Breakdown for Each Class**  

#### **Class A (Large networks, ISPs, data centers)**
- **Default Mask**: 255.0.0.0 (/8)  
- **Networks**: 128  
- **Usable Hosts per Network**: 16,777,214  

#### **Class B (Medium-sized networks, universities, enterprises)**
- **Default Mask**: 255.255.0.0 (/16)  
- **Networks**: 16,384  
- **Usable Hosts per Network**: 65,534  

#### **Class C (Small networks, offices, homes)**
- **Default Mask**: 255.255.255.0 (/24)  
- **Networks**: 2,097,152  
- **Usable Hosts per Network**: 254  

#### **Class D (Multicast)**
- **Used for multicast streaming** (not standard networking)  
- **No subnetting or host addresses**  

#### **Class E (Experimental, not used in public networking)**  

---

### **CIDR (Classless Inter-Domain Routing)**
Modern networks use **CIDR notation** (e.g., **/24, /16**) instead of strict classful subnetting.  
This allows **flexible subnetting** and **efficient IP address allocation**.  








### **Your Plan: 3 Departments in a Network**  
You're considering **255.255.255.192 (/26)**, which provides:  
- **Total IPs**: **64 per subnet**  
- **Usable Hosts**: **62 per subnet**  
- **Subnets (if starting from /24)**: **4 networks**  

---

### **Does it Fit for 3 Departments?**  
✅ **Yes, if each department has 62 or fewer devices**  
- You can divide a **/24 network** into **4 subnets** with **/26**  
- Example:  
  1. **192.168.1.0/26** → **Department 1** (IPs: 192.168.1.1 - 192.168.1.62)  
  2. **192.168.1.64/26** → **Department 2** (IPs: 192.168.1.65 - 192.168.1.126)  
  3. **192.168.1.128/26** → **Department 3** (IPs: 192.168.1.129 - 192.168.1.190)  
  4. **192.168.1.192/26** → **Reserved or Future Use**  

---

### **Considerations**  
❌ If any department has **more than 62 devices**, this won't be enough.  
✅ If **each department has ≤62 devices**, then **/26 is a good choice.**  




If you have **5 departments** and each needs **62 devices**, you need a subnetting plan that provides at least **5 subnets**, each with **at least 62 usable hosts**.

---

### **Solution 1: Use /25 Subnet Mask (Best Choice)**
- **Subnet Mask:** `255.255.255.128` (**/25**)  
- **Total IPs per subnet:** **128**  
- **Usable Hosts per subnet:** **126** (more than enough for 62 devices)  
- **Total subnets (from a /24 network):** **2**  

⚠️ **Problem:**  
- **Only 2 subnets available (not enough for 5 departments).**  

---

### **Solution 2: Use a /23 Subnet (Combine Two /24 Networks)**
- **Subnet Mask:** `255.255.254.0` (**/23**)  
- **Total IPs:** **512**  
- **Usable Hosts:** **510**  
- **You can split it into 5 departments with 102 hosts each**  

✅ **This works perfectly since 102 > 62 for each department!**  

- **Example subnets:**
  - **192.168.0.0/25** → Dept 1 (**126 hosts**)  
  - **192.168.0.128/25** → Dept 2 (**126 hosts**)  
  - **192.168.1.0/25** → Dept 3 (**126 hosts**)  
  - **192.168.1.128/25** → Dept 4 (**126 hosts**)  
  - **192.168.2.0/25** → Dept 5 (**126 hosts**)  

---

### **Alternative Solution 3: Use a /26 and Assign a Second Subnet to a Department**
If you **must** use `255.255.255.192 (/26)`, you only get **4 subnets**, which is **not enough for 5 departments**.  
- You would need to **assign one department to two subnets**, which **complicates routing**.

---

### **Best Choice: /23 (255.255.254.0)**
- **Easy to manage**
- **More than enough IPs for each department**
- **Less subnetting complexity**
- **Scalability for future devices**  





### **CIDR (Classless Inter-Domain Routing) – Full Binary Breakdown**  

CIDR notation allows flexible subnetting by specifying **how many bits** are used for the **network portion** of the IP address. The remaining bits are used for **host addresses**.

Each IPv4 address consists of **32 bits**, written in **dotted decimal format** (e.g., `192.168.1.0`). The CIDR notation (`/x`) defines how many bits belong to the **network**.  

---

## **Subnet Table with Binary Representation**
Below is a detailed **binary breakdown** for each CIDR range (`/24` to `/32`).

| **CIDR** | **Subnet Mask** | **Binary Representation** | **Total Addresses** | **Usable Hosts** |
|------|-------------------|--------------------------------------------|----------------|--------------|
| **/24** | 255.255.255.0   | `11111111.11111111.11111111.00000000` | **256** | **254** |
| **/25** | 255.255.255.128 | `11111111.11111111.11111111.10000000` | **128** | **126** |
| **/26** | 255.255.255.192 | `11111111.11111111.11111111.11000000` | **64** | **62** |
| **/27** | 255.255.255.224 | `11111111.11111111.11111111.11100000` | **32** | **30** |
| **/28** | 255.255.255.240 | `11111111.11111111.11111111.11110000` | **16** | **14** |
| **/29** | 255.255.255.248 | `11111111.11111111.11111111.11111000` | **8** | **6** |
| **/30** | 255.255.255.252 | `11111111.11111111.11111111.11111100` | **4** | **2** |
| **/31** | 255.255.255.254 | `11111111.11111111.11111111.11111110` | **2** | **0** (Point-to-Point Only) |
| **/32** | 255.255.255.255 | `11111111.11111111.11111111.11111111` | **1** | **0** (Single Host Only) |

---

### **CIDR Explanation**
- The **network portion** (1s) defines the **fixed** part of the IP.
- The **host portion** (0s) defines the **variable** part, which is used to assign IP addresses to devices.
- **Usable Hosts** = **Total IPs - 2** (Network + Broadcast)

---

### **Example: /26 Binary Breakdown**
#### **Subnet Mask:** `255.255.255.192`
#### **Binary:**
```
11111111.11111111.11111111.11000000
```
- **Network Bits:** `26`
- **Host Bits:** `6` → **2^6 = 64** IPs (62 usable)

**Subnet Ranges Example (`192.168.1.0/26`):**
| **Subnet** | **Network Address** | **First Usable IP** | **Last Usable IP** | **Broadcast Address** |
|-----------|-----------------|----------------|---------------|-----------------|
| Subnet 1  | 192.168.1.0     | 192.168.1.1    | 192.168.1.62  | 192.168.1.63   |
| Subnet 2  | 192.168.1.64    | 192.168.1.65   | 192.168.1.126 | 192.168.1.127  |
| Subnet 3  | 192.168.1.128   | 192.168.1.129  | 192.168.1.190 | 192.168.1.191  |
| Subnet 4  | 192.168.1.192   | 192.168.1.193  | 192.168.1.254 | 192.168.1.255  |

---

### **Why Use CIDR?**
- **Efficient IP Allocation** → Avoids wasting IPs (Class A, B, C wasted too many addresses).
- **Flexible Subnetting** → Networks can be divided into custom sizes.
- **Better Routing** → Reduces routing table size using aggregation (`Supernetting`).

---








### **Issue:** Computer 1 can share files but has no internet access, while Computer 2 has both file sharing and internet.  

---

### **Possible Reasons & Fixes:**

#### **1. Computer 1 Has No Internet Gateway Configured**  
- Run this on **Computer 1**:  
  ```bash
  ip route show
  ```
- If there is no **default gateway**, set it manually:  
  ```bash
  sudo route add default gw <gateway-ip> eth0
  ```
  - Replace `<gateway-ip>` with your router's IP (e.g., `192.168.1.1`).

---

#### **2. Computer 2 Is Not Sharing Internet (If Acting as a Bridge)**  
- If **Computer 2** is connected to both the LAN and the Internet, enable **IP forwarding**:  
  ```bash
  echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
  ```
- Set up **NAT (Masquerading)**:  
  ```bash
  sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  ```
  - Replace `eth0` with your **internet interface**.

---

#### **3. DNS Issue (Computer 1 Can't Resolve URLs)**
- Try **pinging an IP directly**:  
  ```bash
  ping 8.8.8.8
  ```
- If the ping works, but websites don’t load, update DNS settings:  
  ```bash
  sudo nano /etc/resolv.conf
  ```
  Add:
  ```
  nameserver 8.8.8.8
  nameserver 1.1.1.1
  ```

---

#### **4. Firewall Blocking Internet Access**  
- Check firewall rules on **Computer 1**:  
  ```bash
  sudo iptables -L -v -n
  ```
- If rules block forwarding, allow it:  
  ```bash
  sudo iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
  ```

---

### **Best Solution: Use a Router or Switch**
- If **Computer 1 and Computer 2** are connected via Ethernet:
  - **Use a router** instead of relying on Computer 2.
  - Connect both computers to a **switch** for easier sharing.


---
---

To check why **Computer 1** doesn’t have internet in Windows, follow these steps:  

---

### **1. Check Network Configuration**
Open **Command Prompt (cmd)** and run:  
```cmd
ipconfig /all
```
- Check if Computer 1 has:
  - **IP Address** (e.g., `192.168.1.x`)
  - **Default Gateway** (e.g., `192.168.1.1`)
  - **DNS Server** (e.g., `8.8.8.8` or `1.1.1.1`)

🔹 **Fix:** If the default gateway is missing, set it manually:  
- **Go to:** `Control Panel > Network and Sharing Center > Change adapter settings`
- **Right-click** your network adapter → `Properties`
- Select `Internet Protocol Version 4 (TCP/IPv4)` → `Properties`
- Set **Default Gateway** to the router's IP.

---

### **2. Check Internet Connectivity**
- **Try to ping an external site:**
  ```cmd
  ping 8.8.8.8
  ```
  - If this **works**, but websites don’t load, it's a **DNS issue** (see Step 3).
  - If this **fails**, try **pinging the gateway**:
    ```cmd
    ping 192.168.1.1
    ```
    - If this fails, there’s a **network issue**.

---

### **3. Fix DNS Issues**
- Run:
  ```cmd
  nslookup google.com
  ```
  - If it fails, change the DNS manually:
    - **Go to:** `Control Panel > Network and Sharing Center`
    - Right-click your network → `Properties`
    - Select `IPv4` → `Properties`
    - Set DNS to:
      ```
      Preferred: 8.8.8.8
      Alternate: 1.1.1.1
      ```

---

### **4. Reset Network Settings**
Run these commands in **Command Prompt (Admin)**:
```cmd
netsh int ip reset
netsh winsock reset
ipconfig /flushdns
ipconfig /renew
```
**Restart** the computer after running these.

---

### **5. Check Firewall or Proxy**
- Disable Windows Firewall temporarily:
  ```cmd
  netsh advfirewall set allprofiles state off
  ```
- Check for a proxy:
  - Open `Settings > Network & Internet > Proxy`
  - **Disable** if any proxy is set.

---

### **6. Check if Computer 2 is Sharing Internet (if applicable)**
If Computer 2 is sharing its internet, ensure **Internet Connection Sharing (ICS)** is enabled:  
1. **Go to:** `Control Panel > Network and Sharing Center`
2. **Right-click** the internet-connected adapter → `Properties`
3. **Go to the "Sharing" tab**  
4. **Enable** "Allow other network users to connect"

---

### **Final Solution: Use a Router**
If Computer 1 is supposed to get internet from Computer 2, it's better to connect both to a **router** instead of relying on ICS.











**HELP**


```
https://www.youtube.com/watch?v=s_Ntt6eTn94
```

