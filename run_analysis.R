
library(reshape2)
library(dplyr)
library(stringr)

##set a local working directory for this quiz


##download the data from the provided URL

myURL = paste("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",sep = "")

dir = "zippedFile.zip"
download.file(myURL, dir, mode="wb")


##unzip the file
unzip("zippedFile.zip")

##make the list of the unzipped files
lst_zip<-unzip("zippedFile.zip", list = TRUE)

lst_zip<-tbl_df(lst_zip)


##1) Merges the training and the test sets to create one data set

##1.1 Make the list of the files to merge


train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

variable_names <- read.table("./UCI HAR Dataset/features.txt")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

##1.2 Extract each file and merge into a single file

mrg_x <- rbind(train_x, test_x)
mrg_y <- rbind(train_y, test_y)
mrg_subject <- rbind(train_subject, test_subject)


##2) Extracts only the measurements on the mean and standard deviation for each measurement.

selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
mrg_x <- mrg_x[,selected_var[,1]]

##3) Uses descriptive activity names to name the activities in the data set

colnames(mrg_y) <- "ACTIVITY_NM"
mrg_y$ACTIVITY_NM <- factor(mrg_y$ACTIVITY_NM, labels = as.character(activity_labels[,2]))



##4) Appropriately labels the data set with descriptive variable names.

colnames(mrg_x) <- variable_names[selected_var[,1],2]

##5) From the data set in step 4, creates a second, 
##  independent tidy data set with the average of each variable for each activity and each subject.

colnames(mrg_subject) <- "SUBJECT"
new_data <- cbind(mrg_x, mrg_y, mrg_subject)
total_mean <- new_data %>% group_by(ACTIVITY_NM, SUBJECT) %>% summarize_each(funs(mean))

## New file
write.table(total_mean, file = "./UCI HAR Dataset/wk4_tidydata.txt", row.names = FALSE, col.names = TRUE)





