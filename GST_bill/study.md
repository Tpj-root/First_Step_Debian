
**BASIC**



**Install software dependencies**


```

Install some basic software.

```
sudo apt-get install texlive-latex-base \
dvipng \
texlive-latex-extra \
texlive-xetex \
texlive-fonts-recommended
```


**run**

```bash
pdflatex gst_bill.tex

xelatex gst_bill.tex

```





**Bug**


```
    \multicolumn{5}{|r|}{\textbf{Grand Total}} & \textbf{₹2476} \\

```


```
Fix: Use fontspec and compile with XeLaTeX

\documentclass{article}
\usepackage{fontspec}
\setmainfont{DejaVu Sans} % Or another font supporting ₹

\begin{document}
Total Amount: ₹2476
\end{document}
```







**Modify ImageMagick's Policy**

```
sudo subl /etc/ImageMagick-6/policy.xml
```


Find this line:

<policy domain="coder" rights="none" pattern="PDF" />

Change none to read|write like this:

<policy domain="coder" rights="read|write" pattern="PDF" />




To set the margins for an A4-sized document in LaTeX, use the `geometry` package. You can define the margins individually for all four sides:

### Example:
```latex
\usepackage{geometry}
\geometry{a4paper, top=1in, bottom=1in, left=1in, right=1in}
```
### Adjusting Margins:
- **top** = Distance from the top edge to the start of the text.
- **bottom** = Distance from the bottom edge to the text.
- **left** = Left margin.
- **right** = Right margin.

You can change these values to your preference. For example:
```latex
\geometry{a4paper, top=0.5in, bottom=1.5in, left=1.2in, right=0.8in}
```



In LaTeX, comments start with `%`. Anything after `%` on a line is ignored by the compiler.  

### Example:
```latex
% This is a comment in LaTeX
\documentclass[a4paper,12pt]{article} % Setting document class

\usepackage{geometry} % Package for setting page margins
\geometry{a4paper, top=1in, bottom=1in, left=1in, right=1in} % Define margins

% Begin document
\begin{document}

\textbf{Hello, this is a sample document!} % Bold text example

\end{document}
```

So, use `%` instead of `//` for comments in LaTeX. 🚀

---


full list of standard paper roll sizes, categorized by industry use:

### **1. Receipt & POS Paper Rolls (Thermal & Bond)**
- **2 1/4" x 50' (57mm x 15m)**
- **2 1/4" x 85' (57mm x 26m)**
- **2 1/4" x 230' (57mm x 70m)**
- **3 1/8" x 230' (80mm x 70m)**
- **3 1/8" x 273' (80mm x 83m)**
- **4 3/8" x 328' (112mm x 100m)**

### **2. ATM, Kiosk, and Credit Card Paper Rolls**
- **2 3/8" x 100' (60mm x 30m)**
- **2 3/8" x 200' (60mm x 60m)**
- **3 1/8" x 200' (80mm x 60m)**
- **3 1/8" x 300' (80mm x 91m)**
- **4" x 600' (102mm x 183m)**

### **3. Plotter & Large Format Printer Paper Rolls**
- **11" x 150' (279mm x 46m)**
- **18" x 150' (457mm x 46m)**
- **24" x 150' (610mm x 46m)**
- **30" x 150' (762mm x 46m)**
- **36" x 150' (914mm x 46m)**
- **42" x 150' (1067mm x 46m)**
- **44" x 150' (1118mm x 46m)**
- **54" x 150' (1372mm x 46m)**
- **60" x 150' (1524mm x 46m)**

### **4. Cash Register & Adding Machine Paper Rolls**
- **2 1/4" x 150' (57mm x 46m)**
- **3" x 150' (76mm x 46m)**
- **3" x 165' (76mm x 50m)**

### **5. Label Printer & Barcode Printer Rolls**
- **4" x 6" (102mm x 152mm)**
- **4" x 3" (102mm x 76mm)**
- **2" x 1" (50mm x 25mm)**

### **6. Fax Paper Rolls**
- **8 1/2" x 98' (216mm x 30m)**
- **8 1/2" x 164' (216mm x 50m)**
- **8 1/2" x 328' (216mm x 100m)**

Let me know if you need a specific size! 📜





you can define custom paper sizes for your PDF using the `geometry` package. Here’s how you can set a specific paper roll size, for example, **80mm x 200mm** (common for receipt printers):  

### **Example LaTeX Code for a Custom Paper Roll Size (80mm x 200mm)**
```latex
\documentclass{article}
\usepackage{geometry}

% Define custom paper size (80mm width x 200mm height)
\geometry(paperwidth=80mm, paperheight=200mm, top=5mm, bottom=5mm, left=5mm, right=5mm)

\begin{document}

\textbf{Receipt Example} \\

Item 1: $10.00 \\
Item 2: $15.50 \\
------------------ \\
Total: $25.50 \\

\textbf{Thank You!}

\end{document}
```

### **How to Customize?**
- **Change `paperwidth` and `paperheight`** to match your desired roll size.
- **Adjust `top`, `bottom`, `left`, `right` margins** to ensure proper text alignment.
- **Use `landscape` option** if needed (`\geometry{landscape}`).


