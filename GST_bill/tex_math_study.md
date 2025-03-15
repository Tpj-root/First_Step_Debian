
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



**\usepackage{mathtools}**


```
\documentclass[preview, border=1pt, varwidth]{standalone}
\usepackage{mathtools}
\begin{document}
\[
(a+b)^2 = a^2 + 2ab + b^2
\]
\end{document}
```

<img src="png/math_0.png" width="80" height="40"> <p>black</p>









