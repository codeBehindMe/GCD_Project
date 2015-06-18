# Getting and Cleaning Data
## Course Project

### About
This Readme file is a guide to the script (run_analysis.R) generated to complete the course project of Getting and Cleaning Data (Data Science Specialization) offered by John Hopkins University Bloomberg School of Public Health through Coursera. 
The data set for this project is sourced through the UCI Machine Learning Repository. 

The data set is :

"Human Activity Recognition Using Smartphones"  Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

You may find the dataset at :http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

It is strongly recommended that you read the Readme.txt found with the Human Activity Recognition dataset prior to utilizing run_analysis.R

There are three component's to the readme;
1. The script itself (what it does)
2. tidydata.txt file
3. codebook.md file

### run_analysis.R
This script is generated to meet the requirements set out by the Course project. In summary they are;

1. Merge training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities
4. Appropriately labels the data set with descriptive variable names.
5. Generates a second independent tidy data set with the average of each variable for each activity and each subject

The code within run_analysis.R is annotated and should be used in reference with this Readme file. 
#### Aim
The original data set from UCI-HAR is separated into training and test data sets (see readme of the original data set for more information). For each of the sets, the Activity carried out and the subject who carried it out is separated out into individual files. All files are of .txt format with tables. The variable names are also separated into a different file (also of .txt format table). Column names (features) are also separated in a different file.

The aim is to connect these data sets (files) together into a one data set with descriptive variable names (column names), subject names and activity names; then group this frame by subject and activity with the mean value for each variable. 

##### Furthermore, the assignment is interested in variables that measure mean and standard deviations from the digital signal processing (DSP) data, so we will only recover where the feature name (variable) has a mean or a standard deviation (std) sign in it. 

Therefore the result should be the average values for each feature for each subject over the 6 activities. Result should be the following { 30 subjects x 6 activities by 79 features (and columns for subject and activity) } 

#### Method
To help manipulate this set will use the dplyr package (http://cran.r-project.org/web/packages/dplyr/index.html).

##### Assumed folder structure is  working directory / UCI HAR Dataset

1. A utility function is required to navigate between the different directories of test and training. A function named changeDir is used in this script.
2. Get the descriptive activity labels from activity_labels.txt. This will be used to descriptive activities for each row of the data. Stored in variable df_actLabels
3. Get the feature names from features.txt. This file contains the column names for the data sets. Stored in variable df_features
4. Since the feature names contain escape sequence characters (such as parenthesis) remove or replace them. A function called prepFeatures is called to convert any illegal characters to underscores and is used to modify df_features.
5. Prior to merging the two data sets we assign subjects, descriptive activity names and feature names (column names). A function called getMergedFrame is used to carry out these steps. getMergedFrame will read X_ file, y_ file and the subject_ file, then assign a new column to y_ with the matching descriptive activity name. Then bind the descriptive activity name to the X_. then bind the subject to the X_ set. It will also rename the new columns appropriately to Subject and Activity
6. Once we called getMergedFrame on the test and training data, they are merged using rbind. This is now stored in df_all while the individual data frames for training and test are removed.
7. Next any duplicate columns are removed
8. Since we are only interested in mean and standard deviation DSP data, we extract those columns. 
9. Now we group the data frame by subject and activity.
10. Then we summarise the data in a table by taking all the means. This is stored in df_summ
11. Write  the output table to tidyData.txt
12. Next make a code table containing all the column names and their descriptions. This is done using makeCodeTable function. The function essentially calls gsub on key words to replace them with a more descriptive sentence.
13. Prepare the code table for gitHub by adding dash and pipe symbols.
14. Write the codebook to CodeBook.md
15. Set the working directory back to what it was at the start using changeDir
16. Remove temporary variables and print to the console alerting the user the script has run successfully. 



##### Ensure to take a look at the annotations on the code, which provide line level descriptions. 

#### tidydata.txt
This file contains the cleaned data set. The data set has 81 columns and 180 rows (observations)
First column contains the subject numbers (non unique)
Second column contains the activity which the performed.
Subsequent column contains the average values of each of the features that were selected from the digital signal processing.
#### CodeBook.md
This file contains the different variable names and a more detailed description of those names.
##### CodeBook.md does not contain details on the digital signal processing methods used for features. The feature_info.txt should be consulted for further understanding on the variables.
