Explanation of how the run_analysis.R scripts works
========================================================

# Introduction
The run_analysis.R script starts from the UCI HAR Dataset, Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors. More information about this data can be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Objective

The script performs the following tasks:

*Merges the training and the test sets to create one data set.
*Extracts only the measurements on the mean and standard deviation for each measurement. 
*Uses descriptive activity names to name the activities in the data set
*Appropriately labels the data set with descriptive activity names. 
*Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Steps and code

## First task: merging the training and the test sets to create one data set.

The first step is the loading of the data from the folders and subfolders. We discarded data presents in the "Intertial Signals" folder, as they had just been used to generate our data of interests.


```r
features = read.table("features.txt")
activity = read.table("activity_labels.txt")
subject_train = read.table("./train/subject_train.txt")
x_train = read.table("./train/X_train.txt")
y_train = read.table("./train/y_train.txt")
subject_test = read.table("./test/subject_test.txt")
x_test = read.table("./test/X_test.txt")
y_test = read.table("./test/y_test.txt")
```


After two dataframes are created, one for the test set and one for the training test.


```r
names(x_train) = features$V2
x_train$subject = subject_train$V1
x_train$activity = y_train$V1
names(x_test) = features$V2
x_test$subject = subject_test$V1
x_test$activity = y_test$V1
```


Finally the two datasets are merged:


```r
merged.data = rbind(x_test, x_train)
```


## Second task: Extracting only the measurements on the mean and standard deviation for each measurement.

As shown in the features_info.txt file I took only the column that contained the word "mean" or "std" (for "standard deviation")


```r
index1 = grep("mean", colnames(merged.data))
index2 = grep("std", colnames(merged.data))
index = c(index1, index2)
index = sort(index)
merged.data.filt = merged.data[, index]
merged.data.filt$subject = merged.data$subject  #Put again the 'subject column'
```


## Task three: using descriptive activity names to name the activities in the data set.

Using the substitution function the scripts eliminates parentheses, dashes, capital letters and not clear abbreviations

```r
names = gsub("\\(\\)", "", colnames(merged.data.filt))  #eliminate '()' to make the names 'lighter'
names = gsub("^t", "time", names)  # substitute the t in the beginning of the names to 'time' which is more understandable
names = gsub("-", ".", names)  #substitute 'dashes' with 'points'
names = tolower(names)  #change all cases to 'lower'
```


## Task four: labeling the data set with descriptive activity names. 


I used a for-loop to substitute for each activity number its corresponding activity as indicated in the "activity_labels.txt" file.


```r
for (x in activity$V1) {
    merged.data$activity = gsub(as.character(x), as.character(activity$V2[x]), 
        merged.data$activity)
}

merged.data.filt$activity = merged.data$activity
```


## Step five: creating a second, independent tidy data set with the average of each variable for each activity and each subject. 

I used the fuction "aggregate" for aggregating all the variables using the "mean" formula, based on the activity name and the subject number. The dataset is saved as a tab-delimited file called "avg.dataset.txt".


```r
avg.dataset = aggregate(x = merged.data.filt[, 1:79], merged.data.filt[, 80:81], 
    mean)

write.table(avg.dataset, file = "avg.dataset.txt", sep = "\t")
```


