For py script:

generate_snapshot_info_from_file
Given a csv file containing vm names, look in vCenter and find if the vm names exist or not - 
If the vm names exist in vCenter, generate a report of which vm's contain snapshot and which don't contain snapshots - 
Save the output in csv and html files - 
Display html files in the browser


For PS script:


The main folder will contain the 3 script files and two folders:
Files:
create_snapshot.ps1
generate_report.ps1
remove_snapshot.ps1

Folders:
input_files
reports

input_files folder will contain the following files:
create_snapshot.csv
remove_snapshot.csv
vms.csv

reports folder will be empty

vms.csv is your input file where the vm names are to be entered
The first row will be "name"
The rows below will contain the vm names, for which snapshots need to be taken


GENERATE REPORTS:
Open Powershell in the folder that contains the .ps1 files - PowerCLI has to be installed first
Run .\generate_report.ps1 to generate the reports

This will generate 4 files in the "reports" folder
all_vms.csv
has_snapshot.csv
no_snapshot.csv
not_exist.csv

all_vms.csv is a report of the details of all the vm's from the vms.csv file
has_snapshot.csv is a report of all the vm's from the vms.csv that have existing snapshots, including snapshot names
no_snapshot.csv is a report of all the vm's from the vms.csv that do not have snapshots
not_exist.csv is a report of all the vm's from the vms.csv that do not exist on this vCenter

CREATE SNAPSHOTS:
Edit ./input_files/create_snapshot.csv to contain the names of the vm's for which snapshots are to be created
Edit ./create_snapshot.ps1 to specify the name and description of the snapshots that will be created. You can also enable or disable async mode, memory, quiesce, confirm.
Open Powershell in the folder that contains the .ps1 files - PowerCLI has to be installed first
Run .\create_snapshot.ps1 will create snapshots for the vm's that have been entered in ./input_files/create_snapshot.csv
Scripts should run and snapshots will be created

DELETE SNAPSHOTS:
Edit ./input_files/remove_snapshot.csv to contain the names of the vm's for which snapshots are to be deleted
Edit ./remove_snapshot.ps1 to specify the name of the snapshots that are to be deleted. You can also enable or disable async mode, confirm.
Open Powershell in the folder that contains the .ps1 files - PowerCLI has to be installed first
Run .\remove_snapshot.ps1 will create snapshots for the vm's that have been entered in ./input_files/create_snapshot.csv
Scripts should run and snapshots will be deleted



