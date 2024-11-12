import win32com.client
import pythoncom
import os
import time
from IPython import embed

def main():
    # Path to Rhapsody executable
    rhapsody_exe_path = r"C:\Program Files\IBM\Rational\Rhapsody\8.3.1\rhapsody.exe"

    # Ensure Rhapsody is registered
    if not os.path.exists(rhapsody_exe_path):
        print(f"Rhapsody executable not found at {rhapsody_exe_path}")
        return

    try:
        pythoncom.CoInitialize()  # Initialize COM library
        print("COM library initialized.")

        # Initialize Rhapsody application
        try:
            rhapsody_app = win32com.client.Dispatch("Rhapsody2.Application")
            print("Rhapsody application dispatched.")
        except Exception as e:
            print(f"Failed to dispatch Rhapsody application: {e}")
            return

        # Wait for Rhapsody to fully launch
        time.sleep(5)

        # Check if Rhapsody is running
        if rhapsody_app is None:
            print("Failed to launch Rhapsody. Please check the installation and try again.")
        else:
            print("Rhapsody launched successfully.")

            # Load the given model (Rpyx file)
            model_path = r"D:\Sandbox\Nissan\L02_P02\20_Camera\30_Sw\60_Integration\BuildViews\20_Development\Application\SUV\DGU\SwDD\DGU_Coding\SwDD_RNA_DGU_Coding.rpyx"
            if not os.path.exists(model_path):
                print(f"Model file not found at {model_path}")
                return

            try:
                project = rhapsody_app.openProject(model_path)
                if project is None:
                    print("Failed to load the project. Please check the model path and ensure the file exists.")
                else:
                    print(f"Project loaded successfully from {model_path}.")
            except Exception as e:
                print(f"Error loading project: {e}")
                return

            # Folder containing SBSX files
            sbsx_folder = r"D:\Sandbox\Nissan\DAS\060_Projects\RNA_Renault_Nissan_Alliance\L02_P02\20_Camera\30_Sw\20_Architecture"

            # List of SBSX files to import (just the filenames)
            sbsx_files = [
                "LastModificationTimeUpdaterPlugin.sbsx",
                "EEPM_UML_Profile.sbsx",
                "RequirementPlugin.sbsx",
                "10_Functions.sbsx",
                "20_Requirements.sbsx",
                "30_Analysis.sbsx",
                "40_Logical.sbsx",
                "60_Dynamics.sbsx",
                "70_Integration.sbsx",
                "80_Test.sbsx",
                # Add all your SBSX filenames here
            ]

            # Track if any SBSX file is loaded successfully
            any_sbsx_loaded = False

            # Search for SBSX files in the folder and sub-folders
            for sbsx_file in sbsx_files:
                found = False
                for root, dirs, files in os.walk(sbsx_folder):
                    if sbsx_file in files:
                        sbsx_path = os.path.join(root, sbsx_file)
                        try:
                            print(f"Attempting to import {sbsx_path}")
                            project.importPackageFromRose(sbsx_path)
                            print(f"Imported {sbsx_path} successfully.")
                            any_sbsx_loaded = True
                        except Exception as e:
                            print(f"Failed to import {sbsx_path}: {e}")
                        found = True
                        break
                if not found:
                    print(f"SBSX file not found: {sbsx_file}")

            if any_sbsx_loaded:
                print("Model loaded and all SBSX files imported successfully.")
            else:
                print("No SBSX files were imported successfully.")

        # Start IPython interactive shell for debugging
        embed()

    except pythoncom.com_error as e:
        print(f"COM error: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        pythoncom.CoUninitialize()  # Uninitialize COM library
        print("COM library uninitialized.")

if __name__ == "__main__":
    main()
