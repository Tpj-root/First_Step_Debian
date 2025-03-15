
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

<img src="png/math_0.png"> <p></p>


```
\cos(2\theta) = 1 - 2\sin^2\theta

```

<img src="png/math_1.png"> <p></p>



```
\[
c = a_1 \times b_1
\]
\[
\sqrt{16} = 4
\]
\[
\sqrt[3]{64} = 4
\]
\[
A \in B \neq \phi
\]
\[
\Bigg\{ A+ \bigg( B - \Big[ \big( C
\times D \big) / E \Big] \bigg) \Bigg\}
\]

```


<img src="png/math_2.png"> <p></p>


```

```


