# This script will manipulate the UCI HAR Dataset to form a 'clean' dataset as a part of the course project of the Coursera
# course Getting and Cleaning Data (Data Science Sepcialization)

# you can find more about the UCI HAR Dataset by going to the following location
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#BEGIN

#we will require dplyr package to run this script
require(dplyr)


# there are 3 working directories {UCI HAR; Train; Test;}
# we will use this function to navigate through to each of the directories
changeDir <- function(x="main"){
      
      if(x== "train") {
            
            setwd("~/Data Science/GetCleanData/UCI HAR Dataset")
            setwd("train")
            getwd()
            }
            else {
            
                  if(x == "test") {
                  
                        setwd("~/Data Science/GetCleanData/UCI HAR Dataset")
                        setwd("test")
                        getwd()
            }
            else {
                  # we wont add a if statement here since this function is called from within the script
                  setwd("~/Data Science/GetCleanData/UCI HAR Dataset")
                  getwd()
                  
            }
      }
}

# we need to get the features and activity_labels so we can map them onto our data
changeDir("main")
df_features <- as.data.frame(read.table("features.txt"),StringsAsFactors=F)
df_actLabels <- as.data.frame(read.table("activity_labels.txt"),StringsAsFactors=F)
      
# given the size of the datasets we will sequentially manipulate the test and train data
# we will do this in a number of steps

#lets first validate that df_features has legal column names

prepFeatures <- function(){
      # this function will remove the dash, comma and parenthesis from the df_features and return 
      # a data frame with the cleaned data
      feat <- as.data.frame(df_features[,2],StringsAsFactors=F)
      
      v_featRem <- c("\\(","\\)","\\,","-")
      for(i in 1:length(v_featRem)){
            
            feat <- as.data.frame(gsub(v_featRem[i],"_",feat[,1]),StringsAsFactors=F)
      }
      
      feat
}

# call prepFeatures and assign the result to df_features for further use
df_features <- prepFeatures()

# lets prepare test and train data sets before we merge them to gether by adding the subject and activity

getMergedFrame <- function(dir) {
      # this function will get the data set, attach the activity label then attach subject and return a data frame.
      # it will appropriately name the columns added
    
      #set the working directory
      changeDir(dir)
      
      df_x <- as.data.frame(read.table(paste("X_",dir,".txt",sep="")),StringsAsFactors=F)           # values frame                 
      df_y <- as.data.frame(read.table(paste("y_",dir,".txt",sep="")),StringsAsFactors=F)           # labels frame
      df_s <- as.data.frame(read.table(paste("subject_",dir,".txt",sep="")),StringsAsFactors=F)     # subject frame
      
      #make a df with the activity labels attached to the df_y frame
      df_y <- left_join(x=df_y,y=df_actLabels,by="V1")
      
      #set the items of df_featers to the column names of the df_x
      colnames(df_x) <- df_features[,1]
      
      #merge the activities into the df_x
      df_x <- cbind(df_y[,2],df_x)
      
      #rename the column appropriately to Activity
      colnames(df_x)[1] <- "Activity"
      
      #attach subject onto df_x
      df_x <- cbind(df_s,df_x)
      
      #rename the column appropriately to Subject
      colnames(df_x)[1] <- "Subject"
      
      #now the df_x has descriptive colnames (with duplicates) and subject and activity attached
      df_x
}

df_test <- getMergedFrame("test") #generate the test data frame
df_train <- getMergedFrame("train") #generate the train data frame

# next we have to combine the two frames to make a common frame
df_all <- rbind(df_test,df_train)

#free up memory by removing the df_test and df_train
remove(df_test,df_train)

#now we need to remove duplicate column names
df_all <- df_all[,!duplicated(colnames(df_all))]

#trim the table to extract the Subject,Activity mean and standard deviation variables
df_all <- df_all[,grep("Subject|Activity|mean|std",colnames(df_all))]

# group the items which we want to summarise by
df_all <- group_by(df_all,Subject,Activity)

#create a dataframe with a summary of the means
df_summ <- summarise_each(df_all,funs(mean))

#write a file to the main directory
changeDir("main")
write.table(df_summ,file="tidyData.txt",row.name=F)

#create the codebook for the variables

df_cNames <- as.data.frame(colnames(df_summ),StringsAsFactors=F) #get the column names of our final data frame

makeCodeTable <- function(df=df_cNames){ #we will use a function here; although there is not much gain by doing this
      
      repl <- c("^t","^f","Acc","std","_X","_Y","_Z","_", "meanFreq","Mag","Gyro","  ","Subject","Activity") #set the items to be described
      for (i in 1:length(repl)){    #note the "_" and "  " (double space) is added just to clean up 
       # basically any description here is made by looking at the feature_info.txt manbually.
            switch(i,
                  df <- as.data.frame(gsub(repl[i],"Time domain ",as.vector(df[,1])),StringsAsFactors=F),
                  df <- as.data.frame(gsub(repl[i],"Fast Fourier Transform ",as.vector(df[,1])),StringsAsFactors=F),
                  df <- as.data.frame(gsub(repl[i]," Acceleration (g:9.80665 m/sec2) ", as.vector(df[,1])),StringsAsFactors=F),
                  df <- as.data.frame(gsub(repl[i]," Standard Deviation ", as.vector(df[,1])),StringsAsFactors=F),
                  df <- as.data.frame(gsub(repl[i]," X Direction ", as.vector(df[,1])),StringsAsFactors=F),
                  df <- as.data.frame(gsub(repl[i]," Y Direction ", as.vector(df[,1])),StringsAsFactors=F),
                  df <- as.data.frame(gsub(repl[i]," Z Direction ", as.vector(df[,1])),StringsAsFactors=F),
                  df <- as.data.frame(gsub(repl[i]," ", as.vector(df[,1])),StringsAsFactors=F),
                  df <- as.data.frame(gsub(repl[i]," Mean Frequency ", as.vector(df[,1])),StringsAsFactors=F),
                  df <- as.data.frame(gsub(repl[i]," Magnitude ", as.vector(df[,1])),StringsAsFactors=F),
                  df <- as.data.frame(gsub(repl[i]," Gyroscope (rad/sec) ",as.vector(df[,1])),StringsAsFactors=F),
                  df <- as.data.frame(gsub(repl[i]," ", as.vector(df[,1])),StringsAsFactors=F),
                  df <- as.data.frame(gsub(repl[i],"Subject who carried out the test (number)", as.vector(df[,1])),StringsAsFactors=F),
                  df <- as.data.frame(gsub(repl[i],"Type of activity carried out", as.vector(df[,1])),StringsAsFactors=F),
                  )
      }
      #return the df
      df
      
}
#now we bind the descriptions on to the df_cNames which is what will be written to file
df_cNames <- cbind(df_cNames,makeCodeTable(),c(rep("N/A",2),rep("See feature_info.txt for DSP information",nrow(df_cNames)-2))) 

colnames(df_cNames)[1:3] <- c("Variable","Description","Notes") # name the columns

df_cNames <- rbind(data.frame(Variable = "--------",Description = "-----------", Notes = "-----"),df_cNames) #github table maker

df_cNames <- cbind(c("------",1:81),df_cNames) #bind the numbers

colnames(df_cNames)[1] <- "Number" #name the column

write.table(df_cNames,file="CodeBook.md",row.name=F,col.names=T,quote=F, sep="|") #write to the codebook


# remove temporary variables
remove(df_actLabels,df_all,df_features,df_summ,changeDir,getMergedFrame,makeCodeTable,prepFeatures,df_cNames)

#let's notify the use that the code has sucessfully executed!
print("script run_analysis.R has successfully completed")
print(c("Cleaned data successfully written to tidydata.txt at ", getwd()))
print(c("Codebook has been successfully written to CodeBook.md at ", getwd()))

#END