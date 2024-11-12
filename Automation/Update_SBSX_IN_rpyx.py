import re
import os
import tkinter as tk
from tkinter import filedialog
import stat

def update_rpyx_paths(rpyx_file, architecture_folder):
    """Updates unit/profile paths in the .rpyx file.

    Args:
        rpyx_file (str): Path to the .rpyx file.
        architecture_folder (str): Path to the "20_Architecture" folder.
    """

    units_to_update = [
        "LastModificationTimeUpdaterPlugin", "EEPM_UML_Profile", "RequirementPlugin",
        "10_Functions", "20_Requirements", "30_Analysis", "40_Logical",
        "60_Dynamics", "70_Integration", "80_Test", "EEPM_Testing_Profile", "99_Local", "90_Outdated", "98_Guidance"
    ]

    lookup_table = {}
    for unit_filename in units_to_update:
        # Recursively search subfolders for .sbsx files
        for root, _, files in os.walk(architecture_folder):
            for file in files:
                if file == unit_filename + ".sbsx":
                    lookup_table[unit_filename] = root
                    print(f"Found {unit_filename}.sbsx at: {lookup_table[unit_filename]}")
                    break  # Stop searching once found
            else:
                continue
            break

    if not lookup_table:
        print("Could not locate all required SBSX files within the specified architecture folder.")
        return

    try:
        with open(rpyx_file, 'r', encoding='utf-8') as f:
            rpyx_content = f.read()
    except Exception as e:
        print(f"Error reading .rpyx file: {e}")
        return

    updated_content = rpyx_content

    for unit_filename, new_full_path in lookup_table.items(): # new_full_path now has filename.sbsx
        # Convert forward slashes to backslashes
        new_full_path = new_full_path.replace('/', '\\')
        pattern = rf'<fileName type="a">{unit_filename}</fileName>\s*<[^>]+>\s*(.*?)\s*</_persistAs>'

        print(f"Searching for pattern: {pattern}")
        match = re.search(pattern, updated_content)

        if match:
            old_path = match.group(1)
            print(f"Found old path: {old_path}")

            new_persist_as_tag = f"<_persistAs type=\"a\">{new_full_path}</_persistAs>"
            old_persist_as_tag = f"<_persistAs type=\"a\">{old_path}</_persistAs>"

            print(f"Replacing: {old_persist_as_tag}")
            print(f"With: {new_persist_as_tag}")
            updated_content = updated_content.replace(old_persist_as_tag, new_persist_as_tag)

        else:
            print(f"No match found for {unit_filename}")


    try:
        # Remove read-only if needed (be cautious!)
        file_permissions = stat.S_IMODE(os.lstat(rpyx_file).st_mode)
        if not (file_permissions & stat.S_IWRITE):
            os.chmod(rpyx_file, stat.S_IWRITE | file_permissions)

        with open(rpyx_file, 'w', encoding='utf-8') as f:
            f.write(updated_content)
    except Exception as e:
        print(f"Error writing to .rpyx file: {e}")
        return


def browse_file():
    root = tk.Tk()
    root.withdraw()  # Hide the main window
    file_path = filedialog.askopenfilename(
        title="Select Rhapsody Project File",
        filetypes=[("Rhapsody Project Files", "*.rpyx")]
    )
    return file_path

def browse_folder():
    root = tk.Tk()
    root.withdraw()
    folder_path = filedialog.askdirectory( title="Select 20_Architecture Folder" )
    return folder_path


if __name__ == "__main__":
    rpyx_file_path = browse_file()
    if not rpyx_file_path:
        print("No .rpyx file selected.")
        exit()

    architecture_folder = browse_folder()
    if not architecture_folder:
        print("No architecture folder selected.")
        exit()
    

    update_rpyx_paths(rpyx_file_path, architecture_folder)
    print(f"Updated paths in {rpyx_file_path}")