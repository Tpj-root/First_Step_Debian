import os

def latex_to_image(formula, output_file="formula.png"):
    latex_code = f"""
    \\documentclass{{standalone}}
    \\usepackage{{amsmath}}
    \\begin{{document}}
    \\[
    {formula}
    \\]
    \\end{{document}}
    """

    with open("formula.tex", "w") as f:
        f.write(latex_code)

    os.system("pdflatex formula.tex > /dev/null 2>&1")
    os.system("convert -density 300 formula.pdf -quality 100 " + output_file)

    print(f"Saved formula as {output_file}")

# Example Usage
formula = "E = mc^2"  # Change this to any formula
latex_to_image(formula, "output.png")
