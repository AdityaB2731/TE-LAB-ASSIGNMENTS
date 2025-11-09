import tkinter as tk
from tkinter import filedialog, messagebox, simpledialog
class SmartNotepad:
    def __init__(self, root):
        self.root = root
        self.root.title("Smart Notepad")
        self.root.geometry("900x600")
        # ---- Text Area ----
        self.text_area = tk.Text(self.root, wrap="word", font=("Arial", 12))
        self.text_area.pack(expand=True, fill="both")
        # ---- Status Bar ----
        self.status_bar = tk.Label(self.root, text="Ready", anchor="w")
        self.status_bar.pack(side="bottom", fill="x")
        # ---- Menu Bar ----
        self.menu_bar = tk.Menu(self.root)
        self.root.config(menu=self.menu_bar)
        # File Menu
        file_menu = tk.Menu(self.menu_bar, tearoff=0)
        file_menu.add_command(label="New", command=self.new_file)
        file_menu.add_command(label="Open", command=self.open_file)
        file_menu.add_command(label="Save As...", command=self.save_as_file)
        file_menu.add_separator()
        file_menu.add_command(label="Exit", command=self.exit_app)
        self.menu_bar.add_cascade(label="File", menu=file_menu)
        # Edit Menu
        edit_menu = tk.Menu(self.menu_bar, tearoff=0)
        edit_menu.add_command(label="Change Font Size", command=self.change_font_size)
        edit_menu.add_command(label="Clear All", command=self.clear_text)
        self.menu_bar.add_cascade(label="Edit", menu=edit_menu)
    # ----- Functionalities -----
    def new_file(self):
        self.text_area.delete("1.0", tk.END)
        self.root.title("Smart Notepad - New File")
        self.status_bar.config(text="New file created")
    def open_file(self):
        file_path = filedialog.askopenfilename(
            defaultextension=".txt",
            filetypes=[("Text Files", "*.txt"), ("All Files", "*.*")]
        )
        if not file_path:
            return
        try:
            self.text_area.delete("1.0", tk.END)
            with open(file_path, "r") as file:
                self.text_area.insert("1.0", file.read())
            self.root.title(f"Smart Notepad - {file_path}")
            self.status_bar.config(text=f"Opened: {file_path}")
        except Exception as e:
            messagebox.showerror("Error!", f"Could not open file: {e}")
    def save_as_file(self):
        file_path = filedialog.asksaveasfilename(
            defaultextension=".txt",
            filetypes=[("Text Files", "*.txt"), ("All Files", "*.*")]
        )
        if not file_path:
            return
        try:
            with open(file_path, "w") as file:
                text_content = self.text_area.get("1.0", tk.END)
                file.write(text_content)
            self.root.title(f"Smart Notepad - {file_path}")
            self.status_bar.config(text=f"Saved to: {file_path}")
        except Exception as e:
            messagebox.showerror("Error!", f"Could not save file: {e}")
    def change_font_size(self):
        try:
            size = simpledialog.askinteger("Font Size", "Enter new font size:")
            if size:
                self.text_area.config(font=("Arial", size))
                self.status_bar.config(text=f"Font size changed to {size}")
        except:
            messagebox.showerror("Error", "Invalid font size!")
    def clear_text(self):
        self.text_area.delete("1.0", tk.END)
        self.status_bar.config(text="Text cleared")
    def exit_app(self):
        self.root.destroy()
# Run the app
if __name__ == "__main__":
    root = tk.Tk()
    app = SmartNotepad(root)
    root.mainloop()