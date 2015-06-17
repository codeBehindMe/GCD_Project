# Getting and Cleaning Data
## Course Project

### About
This Readme file is a guide to the script (run_analysis.R) generated to complete the course project of Getting and Cleaning Data (Data Science Specialization) offered by John Hopkins University Bloomberg School of Public Health through Coursera. 
The data set for this project is sourced through the UCI Machine Learning Repository. 

The data set is :

"Human Activity Recognition Using Smartphones"  Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

You may find the dataset at :http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

It is strongly recommended that you read the Readme.txt found with the original dataset prior to utilizing run_analysis.R

There are three component's to the script;
1. The script itself (what it does)
2. tidydata.txt file
3. codebook.md file

### run_analysis.R
This script is generated to meet the requirements set out by the Course project. In summary they are;

1. Merge training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities
4. Appropriately labels the data set with descriptive variable names.
5. Generates a second independant tidy data set with the average of each variable for each activity and each subject

The code within run_analysis.R is annotated and should be used in reference with this Readme file. 
#### Aim
The orignial data set from UCI-HAR is separated into training and test data sets (see readme of the original data set for more information). For each of the sets the Activity carried out and the subject who carried it out is separated out into individual files. All files are of .txt format with tables. The variable names are also separated into a different file (also of .txt format table). 
The aim is to connect these files together into a one data set with descriptive variable names (column names), subject names and activity names; then group this frame by subject and activity with the mean value for each variable. 

#### Method
To help manipulate this set will use the dplyr package (http://cran.r-project.org/web/packages/dplyr/index.html).

1. Get the features that have been measured (variables - column names of data set) from the features.txt file.
2. Get the activity labels describing each activity number ( 1 - STANDING) from activity_labels.txt (see UCI-HAR readme).
3. Legalise names of the features.txt names. There are column names which contain reserved characters in R, these must be filtered out. Any illigal character is replaced with an underscore. 
4. Prior to merging the data sets, carry out subject attachment, activity attachment and descriptive variable naming for training and test data sets. To do this, we load the X_ text file which contains the values (See readme of UCI-HAR set), load the y_ (See readme of UCI-HAR set) file which contains the corresponding activity number for the values in each row, load the subject_ file (See readme of UCI-HAR set).
5. Join the descriptive names in activity_labels.txt to the y_ text file to give descriptive activity names to each row in X_.
6. Now bind the values of features.txt to the column names of the X_ dataframe. Now the X_ frame will have descriptive column names.
7. Attach the descriptive activity names as as gotton in step 6 to the X_ dataframe and name the column Activity.
8. Attach the subjects to the X_ dataframe and name the column Subject. Now we should have a data frame with the subject column showing which subject, the Activity column showing what type of activity the subject carried out and the remaining columns with values for the result of each variable.
9. Steps 4 - 8 are contained in a function and this function is called on the test and training data sets respectively. Now we simply join the two data frames to get a complete set with 10,299 rows.
10. The original data set has a few duplicate column names and this causes dplyr to throw exceptions, so we remove the duplicate column names.
11. since we are interested in all features that have mean or standard deviation we pull out anything that is denoted as a mean or std. Note: FFTs and other frequency based features from DSP are deemed INCLUSIVE of requirement 2. This should return a 79 Variables + Subject and Activity columns in the dataframe.
12. Then group the variables by Subject and Activity so we can pull out the means for each subject and each activity.
13. Summarise the groups with the mean function as required. This will return a 180 row data frame with 81 variables (including Activity and Subject). 30 x Subjects with 6 x activities with the means for 79 measured features. 
14. Write the data frame to a file (tidydata.txt) using data.table(,row.names=F) as required by the assignement
15. Make a table of Variables and their descriptions for the tidydata.txt
16. Write the this table to CodeBook.md
17. Clean up and remove any temporary variables (used to store dataframes and vectors)
18. Notify the user of successfull completion.


