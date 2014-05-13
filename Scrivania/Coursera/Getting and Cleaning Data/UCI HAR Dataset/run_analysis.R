setwd("./UCI HAR Dataset/")
#load the data
features=read.table("features.txt")
activity=read.table("activity_labels.txt")
subject_train=read.table("./train/subject_train.txt")
x_train=read.table("./train/X_train.txt")
y_train=read.table("./train/y_train.txt")
subject_test=read.table("./test/subject_test.txt")
x_test=read.table("./test/X_test.txt")
y_test=read.table("./test/y_test.txt")

#build data.frame from different vectors
names(x_train)=features$V2
x_train$subject=subject_train$V1
x_train$activity=y_train$V1
names(x_test)=features$V2
x_test$subject=subject_test$V1
x_test$activity=y_test$V1

#"Inertial Signals" folder was not considered as these data have only been used to generate the other data

##Requirements:
#You should create one R script called run_analysis.R that does the following. 

#1) Merges the training and the test sets to create one data set.
merged.data=rbind(x_test, x_train)
#2) Extracts only the measurements on the mean and standard deviation for each measurement. 
#as shown in the features_info.txt file I took only the column that contained the word "mean" or "std" (for "standard deviation")
index1=grep("mean", colnames(merged.data))
index2=grep("std", colnames(merged.data))
index=c(index1, index2)
index=sort(index)
merged.data.filt=merged.data[,index]
#3) Uses descriptive activity names to name the activities in the data set
names=gsub("\\(\\)", "", colnames(merged.data.filt)) #eliminate "()" to make the names "lighter"
names=gsub("^t", "time", names) # substitute the t in the beginning of the names to "time" which is more understandable
names=gsub("-", ".", names) #substitute "dashes" with "points"
names=tolower(names) #change all cases to "lower"
merged.data.filt$subject=merged.data$subject


#4) Appropriately labels the data set with descriptive activity names. 

for(x in activity$V1) {
merged.data$activity=gsub(as.character(x), as.character(activity$V2[x]),merged.data$activity)
}

merged.data.filt$activity=merged.data$activity

#5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

avg.dataset=aggregate(x=merged.data.filt[,1:79],merged.data.filt[,80:81], mean)

write.table(avg.dataset, file="avg.dataset.txt", sep="\t")