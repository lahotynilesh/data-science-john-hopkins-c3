##Setting Working Directory
dir.create("C3 Project")
setwd("C3 Project")

## Downloading data as 'Project Data.zip'
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "Project Data.zip",mode = "wb")

## Extracting data, extract "UCI HAR Dataset"
unzip("Project Data.zip")
dir("UCI HAR Dataset")

## Defining Header using features.txt
features = read.table(file = "UCI HAR Dataset/features.txt",header = FALSE,sep = "")
features = lapply(features$V2, as.character)

## reading train set
trainset = read.table(file = "UCI HAR Dataset/train/x_train.txt",header = FALSE,sep = "")
names(trainset)=features

## reading test set
testset = read.table(file = "UCI HAR Dataset/test/x_test.txt",header = FALSE,sep = "")
names(testset)=features

## reading train labels
trainlabel = read.table(file = "UCI HAR Dataset/train/y_train.txt",header = FALSE,sep = "")$V1
testlabel = read.table(file = "UCI HAR Dataset/test/y_test.txt",header = FALSE,sep = "")$V1

## readin test labels
subjecttrain = read.table(file = "UCI HAR Dataset/train/subject_train.txt",header = FALSE,sep = "")$V1
subjecttest = read.table(file = "UCI HAR Dataset/test/subject_test.txt",header = FALSE,sep = "")$V1

## merging test & train set (OBJECTIVE 1)
mergedset = rbind(trainset,testset)
mergedlabels = c(trainlabel,testlabel)
mergedsubject = c(subjecttrain,subjecttest)

## extracting cols with mean & std in it (OBJECTIVE 2)
dataset1 = mergedset[,sort(c(grep("mean",names(mergedset)),grep("std",names(mergedset))))]

## renaming activities to descriptive activity labels (OBJECTIVE 3)
activitylabels = read.table(file = "UCI HAR Dataset/activity_labels.txt",header = FALSE,sep = "")$V2
mergedlabels = factor(mergedlabels,labels = activitylabels)

## renaming columns to descriptive names (OBJECTIVE 4)
temp = names(dataset1)
temp = gsub("^t","timeSignal",temp)
temp = gsub("Freq","Frequency",temp)
temp = gsub("^f","frequencySignal",temp)
temp = gsub("Acc","Acceleration",temp)
temp = gsub("Gyro","Gyroscope",temp)
temp = gsub("Mag","ResultantMagnitute",temp)
temp = gsub("-mean()","",temp,fixed=TRUE)
temp = gsub("-std()","Deviation",temp,fixed=TRUE)
temp = gsub("-","",temp,fixed=TRUE)
names(dataset1) = temp

## creates a second, independent tidy data set
## with the average of each variable for each activity
## and each subject (OBJECTIVE 5)
install.packages("reshape2")
library(reshape2)
meltedset = melt(data = cbind(mergedsubject, mergedlabels,dataset1),id.vars = c("mergedsubject","mergedlabels"))
dataset2 = dcast(temp1, mergedsubject + mergedlabels ~ variable, mean)

## writing datasets to csv
write.csv(dataset1,file="dataset1.csv")
write.csv(dataset2,file="dataset2.csv")

## writing dataset to txt
write.table(x = dataset2,file = "dataset2.txt",sep = " ",row.names = FALSE)
write.table(x = names(dataset2),file = "dataset2features.txt",sep = " ")
