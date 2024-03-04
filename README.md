# Manually Annotate Physiological Data using MATLAB GUI

This is a quality assessment app developed initially for visualizing and manually assessing the quality of physiological data. MAT files for each subject have to be created, the fields of each MAT file referencing physiological timeseries data for that subject. The user can launch the app and use the sorting buttons and comment box to generate a single csv result file that includes the classification results for each subject(i.e. plot). The details on how to set up the app is listed below. 

## How to use
#### 1. Downloading
Clone or download this repository on to your machine. 

#### 2. Organize your files
In the repository folder, create a folder named `Data`. In this folder, include all MAT files that correspond with subjects that need to quality assessed. The organization of the MAT files should be that each file corresponds to a subject, and each file has multiple fields, a field for each measure of the subject that was taken (for example, there would be one field with data for the heart rate, one field with data for the skin conductance, etc).


#### 3. Launch the app
After you save your changes, you are ready to begin using this app. You can launch it by clicking the `QA_App_modified_exported.m` file downloaded from this repository and then clicking run in MATLAB. After the app is launched, you should see this interface.

<img width="1201" alt="Screen Shot 2024-03-04 at 1 01 11 PM" src="https://github.com/RickReddy/physio_QA_manual/assets/40832092/b0c540bf-fc89-46a1-a872-f0af07ad5c48">


To load a specific field, click load and a list of all fields associated with the subjects will be generated. Then, type out one of the fields and the data for that field, for the first subject will be loaded. The previous and next buttons can be used to switch between subjects, and each category can be classified, as great, good, fixable, or bad. Comments can be saved for each file as well.

#### 4. Checking the result
The output of this app is a csv file that will be created when the app is launched for the first time. The file will be automatically generated in the repository directory and named `result.csv`. 

#### Note: 
progress will be saved in the result.csv file, so you can close the app at anytime and continue at a later time as long as you do not make any changes to the repository structure or the output file name. 
