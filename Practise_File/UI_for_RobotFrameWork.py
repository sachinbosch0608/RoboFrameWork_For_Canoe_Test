# -*- coding: utf-8 -*-
"""
Created on Wed Feb  5 14:30:24 2025

@author: RZP2KOR
"""

import sys
import os
import subprocess
from PyQt6.QtCore import Qt
from PyQt6.QtWidgets import QApplication, QWidget, QVBoxLayout, QHBoxLayout, QLineEdit, QPushButton, QTextEdit, QCheckBox, QLabel, QFileDialog
from PyQt6.QtGui import QIcon  # Import QIcon to set the icon for the window


class MyApp(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Robot Framework Manager")

        # Set the window icon (ensure the icon file exists in the same directory)
        self.setWindowIcon(QIcon('RF.jpg'))  # Replace with the path to your icon file

        # Create the layout and widgets
        self.layout = QVBoxLayout()
        self.output_window = QTextEdit(self)
        self.output_window.setReadOnly(True)  # Make it read-only
        self.layout.addWidget(QLabel("Output Window:"))
        self.layout.addWidget(self.output_window)

        # Input field for .robot file name
        self.file_input_layout = QHBoxLayout()
        self.file_input = QLineEdit(self)
        self.browse_button = QPushButton("Browse", self)
        self.browse_button.clicked.connect(self.browse_file)
        self.file_input_layout.addWidget(QLabel("Enter the .robot file name:"))
        self.file_input_layout.addWidget(self.file_input)
        self.file_input_layout.addWidget(self.browse_button)
        self.layout.addLayout(self.file_input_layout)

        # Checkbox for .venv existence
        self.venv_checkbox = QCheckBox("Check if .venv exists in current directory", self)
        self.venv_checkbox.stateChanged.connect(self.on_checkbox_state_change)  # Connect the checkbox state change
        self.layout.addWidget(self.venv_checkbox)

        # Create Buttons
        self.create_venv_button = QPushButton("Create .venv", self)
        self.activate_venv_button = QPushButton("Activate .venv", self)
        self.pip_install_button = QPushButton("Pip Install from requirements.txt", self)
        self.run_robot_button = QPushButton("Run .robot File", self)
        self.exit_button = QPushButton("Exit", self)

        self.create_venv_button.clicked.connect(self.create_venv)
        self.activate_venv_button.clicked.connect(self.activate_venv)
        self.pip_install_button.clicked.connect(self.pip_install)
        self.run_robot_button.clicked.connect(self.run_robot)
        self.exit_button.clicked.connect(self.close)

        # Add buttons to the layout
        self.layout.addWidget(self.create_venv_button)
        self.layout.addWidget(self.activate_venv_button)
        self.layout.addWidget(self.pip_install_button)
        self.layout.addWidget(self.run_robot_button)
        self.layout.addWidget(self.exit_button)

        self.setLayout(self.layout)

    def output(self, message):
        """Method to output status in the output window"""
        self.output_window.append(message)

    def on_checkbox_state_change(self):
        """Called when the checkbox state changes"""
        is_checked = self.venv_checkbox.isChecked()

        # Disable buttons when checkbox is checked, enable when unchecked
        self.create_venv_button.setEnabled(not is_checked)
        self.pip_install_button.setEnabled(not is_checked)

    def browse_file(self):
        """Open file dialog to browse and select a .robot file"""
        file_name, _ = QFileDialog.getOpenFileName(self, "Select .robot file", "", "Robot Framework Files (*.robot)")
        if file_name:
            self.file_input.setText(file_name)  # Set the file path in the input field

    def create_venv(self):
        """Create .venv in the current directory"""
        if not os.path.exists('.venv'):
            self.output("Creating .venv in current directory...")
            subprocess.run(["python", "-m", "venv", ".venv"])
            self.output(".venv created successfully!")
        else:
            self.output(".venv already exists.")

    def activate_venv(self):
        """Activate the .venv in the current directory"""
        if os.path.exists('.venv'):
            self.output("Activating .venv...")
            activate_script = os.path.join(".venv", "Scripts", "activate.bat" if os.name == 'nt' else "activate")
            subprocess.run([activate_script], shell=True)
            self.output(".venv activated.")
        else:
            self.output(".venv does not exist in the current directory!")

    def pip_install(self):
        """Install packages using requirements.txt"""
        if os.path.exists("requirements.txt"):
            self.output("Installing packages from requirements.txt...")
            subprocess.run([os.path.join(".venv", "Scripts", "pip") if os.name != 'nt' else ".venv\\Scripts\\pip", "install", "-r", "requirements.txt"])
            self.output("Installation complete!")
        else:
            self.output("requirements.txt file not found!")

    def run_robot(self):
        """Run the .robot file"""
        robot_file = self.file_input.text()
        if robot_file.endswith('.robot') and os.path.exists(robot_file):
            self.output(f"Running the .robot file: {robot_file}")
            subprocess.run(["robot", robot_file])
            self.output(f"Test execution completed for: {robot_file}")
        else:
            self.output("Please provide a valid .robot file.")

    def close(self):
        """Exit the application"""
        self.output("Exiting the application...")
        QApplication.quit()  # Use QApplication.quit() to exit the event loop cleanly


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MyApp()
    window.resize(500, 600)  # Resize window as needed
    window.show()
    sys.exit(app.exec())
