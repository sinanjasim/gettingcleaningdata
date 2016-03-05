#Getting and Cleaning Data Course Project
library(dplyr)
#If there is no folder create one to put the data in it
if(!file.exists("./data1")){dir.create("./data1")}

#Download the zip file after checking if it has not been downloaded 
if (!file.exists("./data1/UCIHARDataset.zip")){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, destfile="./data1/UCIHARDataset.zip")}  

#unzip the downloaded file 
if (!file.exists("./data1/UCI HAR Dataset")) {
        unzip("./data1/UCIHARDataset.zip", exdir = "./data1")}

#set the directory the directory of data to ease arriving to the data
setwd('C:\\Users\\Sinan Jasim Hadi\\Documents\\data1\\UCI HAR Dataset\\');

#read the data (x = features , y = Activities, Subject = Subject)
#Training data
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

#Test data of the same variables
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

#read the name of the features with their variable number
features <- read.table("features.txt")

#Read the Activities file
activities <- read.table("activity_labels.txt")

#Get only the required features
requiredfeatures <- grep(".*mean.*|.*std.*", features[,2])

#Gathering train with test data
fullx <- rbind(x_train, x_test)
fully <- rbind(y_train, y_test)
fullsubj<- rbind(subject_train, subject_test)

#Extract the required features only from the full variables
finalfeatures <- fullx[,requiredfeatures]

#Change the names of the columns based on the names of required features
names(finalfeatures)<- features[requiredfeatures,2]

#naming the Activities (data frame) and the factors (rows) of Activities based on their numbers
finalActivities <- fully
finalActivities[,1] <- activities[finalActivities[, 1], 2]
names(finalActivities)<- "Activities"

#naming the variable of Subject
names(fullsubj)<- "Subject"

#Binding the data in one in one data frame
Fulldata <- cbind(finalfeatures, finalActivities, fullsubj)

#Calculating the mean of every variable by grouping them based on activities and Subject
final <- aggregate(x = Fulldata[,1:79], by = list(Fulldata$Activities, Fulldata$Subject), FUN = "mean")

#save the data to file
write.table(final, file = "C:\\Users\\Sinan Jasim Hadi\\gettingcleaningdata\\Tidydata.txt")
