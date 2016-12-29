
###get the data


fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./SATTELITE_NV/Dataset.zip",method="curl")
unzip(zipfile="./SATTELITE_NV/Dataset.zip",exdir="./SATTELITE_NV")
setwd("/users/SATTELITE_NV/UCI HAR Dataset")

###read data from targetted files

ActivityTt  <- read.table("test/y_test.txt",header = FALSE)
ActivityTr <- read.table("train/y_train.txt",header = FALSE)

SubjectTr <- read.table("train/subject_train.txt",header = FALSE)
SubjectTt  <- read.table("test/subject_test.txt",header = FALSE)

FeaturesTt  <- read.table("test/x_test.txt",header = FALSE)
FeaturesTr <- read.table("train/X_train.txt",header = FALSE)

###Merges the training and the test sets to create one data set
##1.Concatenate the data tables by rows

dSubject <- rbind(SubjectTr, SubjectTt)
dActivity<- rbind(ActivityTr, ActivityTt)
dFeatures<- rbind(FeaturesTr, FeaturesTt)

##2.set names to variables

names(dSubject)<-c("subject")
names(dActivity)<- c("activity")

##3.Merge columns to get the data frame Data for all data

dFeaturesNames <- read.table("features.txt",head=FALSE)
names(dFeatures)<- dFeaturesNames$V2
dCombine <- cbind(dSubject, dActivity)
Dfinal <- cbind(dFeatures, dCombine)

###Extracts only the measurements on the mean and standard deviation for each measurement
##1.Subset Name of Features by measurements on the mean and standard deviation

subdFeaturesNames<-dFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dFeaturesNames$V2)]

##2.Subset the data frame Data by seleted names of Features

sNames <- c(as.character(subdFeaturesNames), "subject", "activity" )
Dfinal <- subset(Dfinal, select=sNames)


###Uses descriptive activity names to name the activities in the data set
##1.Read descriptive activity names from ???activity_labels.txt???

activityLab <- read.table("activity_labels.txt",header = FALSE)

##2.facorize Variale activity in the data frame Data using descriptive activity names
##3.check

head(Dfinal$activity,30)

###Appropriately labels the data set with descriptive variable names

#prefix t is replaced by time
#Acc is replaced by Accelerometer
#Gyro is replaced by Gyroscope
#prefix f is replaced by frequency
#Mag is replaced by Magnitude
#BodyBody is replaced by Body

###Creates a second,independent tidy data set and ouput it
#In this part,a second, independent tidy data set will be created with the average of each variable for each activity and each subject based on the data set in step 4.

library(dplyr);
Dfinal2<-aggregate(. ~subject + activity, Dfinal, mean)
Dfinal2<-Data2[order(Dfinal2$subject,Dfinal2$activity),]
write.table(Dfinal2, file = "tidydata.txt",row.name=FALSE)


