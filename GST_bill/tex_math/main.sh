#!/bin/bash

# List of TeX files
#FileList=("gst_bill_v_0.1.tex" "gst_bill_v_0.2.tex" "formula.tex" "paper_roll.tex" "paper_roll_3.tex")
FileList=("math_2.tex")

# Loop through each file and compile it
for file in "${FileList[@]}"; do
    if [ -f "$file" ]; then
        echo "Compiling $file..."
#        xelatex "$file"
        pdflatex "$file"

        # Convert generated PDF to PNG
        pdf_file="${file%.tex}.pdf"
        png_file="${file%.tex}.png"

        if [ -f "$pdf_file" ]; then
            convert -density 300 "$pdf_file" -quality 100 "$png_file"
            echo "Converted $pdf_file to $png_file"
        else
            echo "PDF file $pdf_file not found!"
        fi
    else
        echo "File $file not found!"
    fi
done


rm -rf *.log
rm -rf *.aux
rm -rf *.pdf
#rm -rf *.png
# If you want to clean up all temporary LaTeX files, use:
#rm -rf *.aux *.log *.out *.toc *.synctex.gz *.nav *.snm *.lof *.lot
