import re
import os

def update_rpyx_paths(rpyx_file, lookup_table):
    """Updates unit/profile paths in the .rpyx file.

    Args:
        rpyx_file (str): Path to the .rpyx file.
        lookup_table (dict): Dictionary mapping unit filenames (without extension)
                              to the absolute paths of the folders containing them.
    """

    with open(rpyx_file, 'r', encoding='utf-8') as f:
        rpyx_content = f.read()

    updated_content = rpyx_content

    for unit_filename, new_base_path in lookup_table.items():
        # Correctly form the replacement string (folder path only)
        replacement_path = new_base_path  # No need to add filename here

        pattern = rf'<fileName type="a">{unit_filename}</fileName>\s*<[^>]+>\s*(.*?)\s*</_persistAs>'

        match = re.search(pattern, updated_content)

        if match:
            old_path = match.group(1)
            updated_content = updated_content.replace(
                f"<_persistAs type=\"a\">{old_path}</_persistAs>",
                f"<_persistAs type=\"a\">{replacement_path}</_persistAs>"  # Use replacement_path
            )
            print(f"Updated path for {unit_filename} from: {old_path} to: {replacement_path}")

    with open(rpyx_file, 'w', encoding='utf-8') as f:
        f.write(updated_content)



if __name__ == "__main__":
    rpyx_file_path = "O:\\Application\\SUV\\DGU\\SwDD\\DGU_CyberSecurity\\SwDD_RNA_DGU_CyberSecurity.rpyx"

    lookup_table = {
        "LastModificationTimeUpdaterPlugin": "D:\\Sandbox\\Nissan\\DAS\\060_Projects\\RNA_Renault_Nissan_Alliance\\L02_P02\\20_Camera\\30_Sw\\20_Architecture\\900_Profiles\\LastModificationTimeUpdaterPlugin",  # Folder path only
        "EEPM_UML_Profile": "D:\\Sandbox\\Nissan\\DAS\\060_Projects\\RNA_Renault_Nissan_Alliance\\L02_P02\\20_Camera\\30_Sw\\20_Architecture\\900_Profiles\\EEPM_UML_Profile_rpy",  # Folder path only
        "RequirementPlugin": "D:\\Sandbox\\Nissan\\DAS\\060_Projects\\RNA_Renault_Nissan_Alliance\\L02_P02\\20_Camera\\30_Sw\\20_Architecture\\900_Profiles\\RequirementPlugin", # Folder path only
        "10_Functions": "D:\\Sandbox\\Nissan\\DAS\\060_Projects\\RNA_Renault_Nissan_Alliance\\L02_P02\\20_Camera\\30_Sw\\20_Architecture\\020_UmlModel\\SwAD_rpy\\10_Functions",  # Folder path only
        "20_Requirements": "D:\\Sandbox\\Nissan\\DAS\\060_Projects\\RNA_Renault_Nissan_Alliance\\L02_P02\\20_Camera\\30_Sw\\20_Architecture\\020_UmlModel\\SwAD_rpy\\20_Requirements", # Folder path only
        "30_Analysis": "D:\\Sandbox\\Nissan\\DAS\\060_Projects\\RNA_Renault_Nissan_Alliance\\L02_P02\\20_Camera\\30_Sw\\20_Architecture\\020_UmlModel\\SwAD_rpy\\30_Analysis", # Folder path only
        "40_Logical": "D:\\Sandbox\\Nissan\\DAS\\060_Projects\\RNA_Renault_Nissan_Alliance\\L02_P02\\20_Camera\\30_Sw\\20_Architecture\\020_UmlModel\\SwAD_rpy\\40_Logical", # Folder path only
        "60_Dynamics": "D:\\Sandbox\\Nissan\\DAS\\060_Projects\\RNA_Renault_Nissan_Alliance\\L02_P02\\20_Camera\\30_Sw\\20_Architecture\\020_UmlModel\\SwAD_rpy\\60_Dynamics", # Folder path only
        "70_Integration": "D:\\Sandbox\\Nissan\\DAS\\060_Projects\\RNA_Renault_Nissan_Alliance\\L02_P02\\20_Camera\\30_Sw\\20_Architecture\\020_UmlModel\\SwAD_rpy\\70_Integration", # Folder path only
        "80_Test": "D:\\Sandbox\\Nissan\\DAS\\060_Projects\\RNA_Renault_Nissan_Alliance\\L02_P02\\20_Camera\\30_Sw\\20_Architecture\\020_UmlModel\\SwAD_rpy\\80_Test" # Folder path only
    }


    update_rpyx_paths(rpyx_file_path, lookup_table)
    print(f"Updated paths in {rpyx_file_path}")