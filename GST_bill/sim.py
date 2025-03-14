import sys
import tempfile
import subprocess
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QPushButton, QTextEdit, QLabel, QHBoxLayout, QSlider
from PyQt5.QtGui import QPixmap
from PyQt5.QtCore import Qt

class LaTeXPreviewer(QWidget):
    def __init__(self):
        super().__init__()

        # Layouts
        main_layout = QHBoxLayout()
        left_layout = QVBoxLayout()
        right_layout = QVBoxLayout()

        # LaTeX input box
        self.text_edit = QTextEdit()
        self.text_edit.setPlaceholderText("Enter LaTeX code here...")

        # Button to generate preview
        self.run_button = QPushButton("Simulate")
        self.run_button.clicked.connect(self.generate_preview)

        # Image display
        self.image_label = QLabel()
        self.image_label.setAlignment(Qt.AlignCenter)

        # Zoom controls
        self.zoom_slider = QSlider(Qt.Horizontal)
        self.zoom_slider.setMinimum(10)   # 10% zoom
        self.zoom_slider.setMaximum(300)  # 300% zoom
        self.zoom_slider.setValue(25)    # Default 100% zoom
        self.zoom_slider.valueChanged.connect(self.update_zoom)

        # Add widgets to layouts
        left_layout.addWidget(self.text_edit)
        left_layout.addWidget(self.run_button)
        
        right_layout.addWidget(self.image_label)
        right_layout.addWidget(self.zoom_slider)

        # Combine layouts
        main_layout.addLayout(left_layout, 1)
        main_layout.addLayout(right_layout, 1)
        self.setLayout(main_layout)

        # Window properties
        self.setWindowTitle("LaTeX Previewer")
        self.resize(900, 600)

        # Store last image path
        self.last_png_path = None
        self.current_pixmap = None

    def generate_preview(self):
        """Generate the LaTeX preview as an image and display it."""
        latex_code = self.text_edit.toPlainText()

        if not latex_code.strip():
            return

        # Create a temporary directory for virtual memory storage
        with tempfile.TemporaryDirectory() as temp_dir:
            tex_file = f"{temp_dir}/temp.tex"
            pdf_file = f"{temp_dir}/temp.pdf"
            png_file = f"{temp_dir}/temp.png"

            # Write LaTeX code to temp file
            with open(tex_file, "w") as f:
                f.write(latex_code)

            # Compile LaTeX to PDF using XeLaTeX (no disk storage)
            subprocess.run(["xelatex", "-output-directory", temp_dir, tex_file], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

            # Convert PDF to PNG
            subprocess.run(["convert", "-density", "300", pdf_file, "-quality", "100", png_file], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

            # Store last image path
            self.last_png_path = png_file
            self.update_zoom()

    def update_zoom(self):
        """Update image zoom based on slider value."""
        if self.last_png_path:
            self.current_pixmap = QPixmap(self.last_png_path)
            zoom_factor = self.zoom_slider.value() / 100.0
            new_size = self.current_pixmap.size() * zoom_factor
            scaled_pixmap = self.current_pixmap.scaled(new_size, Qt.KeepAspectRatio)
            self.image_label.setPixmap(scaled_pixmap)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = LaTeXPreviewer()
    window.show()
    sys.exit(app.exec_())
