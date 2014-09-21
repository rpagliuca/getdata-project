# Project

# Test if one of the files exist. If it does, it is then assumed that all the
# other files also exist and the script continues...
if (!file.exists("./data/test/X_test.txt")) {
    print("Data not found.")
    exit;
}

# It takes a while to load all the files... so first check if the files
# are already loaded in memory, before trying to load them.
if (!exists("testSet")) {
    testSet <- read.table("./data/test/X_test.txt")
    testSubject <- read.table("./data/test/subject_test.txt")
    testActivity <- read.table("./data/test/y_test.txt")
    trainSet <- read.table("./data/train/X_train.txt")
    trainSubject <- read.table("./data/train/subject_train.txt")
    trainActivity <- read.table("./data/train/y_train.txt")
    activityLabels <- read.table("./data/activity_labels.txt")
}

# Group together data from activity and subject, together with the mean and
# standard deviation for the test set
testData <- cbind(testActivity, testSubject, apply(testSet, 1, mean),
                  apply(testSet, 1, sd))
names(testData) <- c('activity_id', 'subject', 'mean', 'sd')

# Do the same thing for the train set
trainData <- cbind(trainActivity, trainSubject, apply(trainSet, 1, mean),
                   apply(trainSet, 1, sd))
names(trainData) <- c('activity_id', 'subject', 'mean', 'sd')

# Combine together the rows from the test data and the train data
fullData <- rbind(testData, trainData)

# Merge with the activity labels data
fullData <- merge(fullData, activityLabels, by.x = "activity_id", by.y = "V1")

# Change names of the columns to reflect the new column "activity"
names(fullData) <- c('activity_id', 'subject', 'mean', 'sd', 'activity')

# Generate tidy dataset
library(plyr)
tidyData <- ddply(fullData, c('activity', 'subject'), summarise, mean = mean(mean), sd = mean(sd))

# Write the tidy dataset to a file
write.table(tidyData, file="tidydata.txt", row.names=FALSE)