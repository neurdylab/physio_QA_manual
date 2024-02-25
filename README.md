# Manually Annotate Physiological Data using MATLAB GUI

This is a quality assessment app developed initially for visualizing and manually assessing the quality of physiological data. MAT files for each subject have to be created, the fields of each MAT file referencing physiological timeseries data for that subject. The user can launch the app and use the sorting buttons and comment box to generate a single csv result file that includes the classification results for each subject(i.e. plot). The details on how to set up the app is listed below. 

## How to use
#### 1. Downloading
Clone or download this repository on to your machine. 

#### 2. Organize your files
In the repository folder, create a folder named `Data`. In this folder, include all MAT files that correspond with subjects that need to quality assessed.


#### 3. Launch the app
After you save your changes, you are ready to begin using this app. You can either launch it by clicking the `QA_App_New.mlapp` file downloaded from this repository or clicking the "Play" button in MATLAB. After the app is launched, you should see this interface with the image in the middle being the first plot in your `Plots` folder. 

![image](https://github.com/rachel0427/QA_app_new/assets/55034774/7b42ad1a-ce9e-442c-b4d3-db040b9937f1)

The first row of buttons allows you to classify a general quality of the signal combining your assessment for both the cardiac and respiration signal. Then you can go into more detail and provide classifications for the cardiac signal and respiration signal separately by clicking the buttons on corresponding rows. For each plot you are sorting, you can type in some comment in the text box at the bottom and click the `Add comment` to add a line of comment for future reference. 

#### 4. Checking the result
The output of this app is a csv file that will be created when the app is launched for the first time. The file will be automatically generated in the repository directory and named `result.csv`. 

#### Note: 
progress will be saved in the result.csv file, so you can close the app at anytime and continue at a later time as long as you do not make any changes to the repository structure or the output file name. 
