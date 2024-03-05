# Manual Annotation of Physiological Data using MATLAB GUI

The QA_app is designed for visualizing and manually assessing the quality of physiological data. It allows users to work directly with data files corresponding to individual subject measurements, each containing fields that reference physiological timeseries data such as cardiac, respiration, heart rate, skin conductance, etc. Through the app, users can label the quality of data, add comments, and the app writes out a .csv file with the assessment results.

## Getting Started

### 1. Downloading the Application

First, you need to get the app onto your machine:

- **Clone or download this repository** to your local machine. You can do this by using Git (`git clone https://github.com/neurdylab/physio_QA_manual.git`).

### 2. Organizing Your Data Files

Proper file organization is crucial for the QA_app to function correctly:

- Inside the root directory of the repository, **create a folder named `Data`**. This directory will store your data files.
- **Place all your `.mat` files** within the `Data` folder. Each `.mat` file should represent a different subject and contain multiple fields, each field representing a different measure taken for the subject (e.g., heart rate, skin conductance).


#### Folder Structure Visualization:

```
/physio_QA_manual
    /Data
        subject1.mat
        subject2.mat
        ...
```

### 3. Launching the App

Once your data is organized, you're ready to start assessing quality:

- Open MATLAB and **navigate to the repository's root directory**.
- **Find and run the `QA_App_modified_exported.m` file**. This action will launch the Quality Assessment interface.

#### Using the App:

- **Load Data**: Click the `Load` button to generate a list of fields from your `.mat` files.
- **View Data**: Enter a field name to load data for that field from the first subject. Use the `Previous` and `Next` buttons to navigate between subjects.
- **Rate Data Quality**: For each data field, label the quality as `Great`, `Good`, `Fixable`, or `Bad`.
- **Commenting**: You can add any relevant comments for each file. It is especially helpful that you add a comment if you labeled the waveform as `Fixable`. 

### 4. Checking Results

The app automatically generates an output file to store your assessments:

- Upon first launching the app, a **`result.csv` file will be created in the repository's root directory**. This file will store the quality assessments and comments for each data field and subject.

#### Important Note:

- Your progress is automatically saved in the `result.csv` file. Feel free to close the app and return to your assessment later. However, **ensure not to alter the structure of the repository or the name of the output file (`result.csv`)** to avoid data loss or inconsistencies.

---

Feel free to reach out with any questions or if you encounter issues while setting up or using the app.
