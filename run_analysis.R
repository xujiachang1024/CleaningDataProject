## loading subject data
test_subject <- read.table("data/test/subject_test.txt", header = FALSE)
train_subject <- read.table("data/train/subject_train.txt", header = FALSE)

## loading features data
test_features <- read.table("data/test/X_test.txt", header = FALSE)
train_features <- read.table("data/train/X_train.txt", header = FALSE)

## loading activity data
test_activity <- read.table("data/test/Y_test.txt" , header = FALSE)
train_activity <- read.table("data/train/Y_train.txt", header = FALSE)

## take a look at the top rows of datasets
head(test_subject)
head(train_subject)
head(test_features)
head(train_features)
head(test_activity)
head(train_activity)

subject <- rbind(train_subject, test_subject)
features <- rbind(train_features, test_features)
activity <- rbind(train_activity, test_activity)
head(subject)
head(features)
head(activity)

## factoring activity labels
labels <- read.table("data/activity_labels.txt", header = FALSE)
activity$V1 <- factor(activity$V1, levels = as.integer(labels$V1), labels = labels$V2)

## naming variables: subject & activity
names(subject) <- c("subject")
names(activity) <- c("activity")

## naming variables: features
features_variables <- read.table("data/features.txt", head=FALSE)
head(features_variables)
names(features)<- features_variables$V2

## subsetting features data with mean and standard deviation
meanstdev <- c(as.character(features_variables$V2[grep("mean\\(\\)|std\\(\\)", features_variables$V2)]))
features_subdata <- subset(features, select = meanstdev)

## combining subject, activity, and features data to a final data frame
subjectactivity <- cbind(subject, activity)
finaldata <- cbind(features_subdata, subjectactivity)

## explicitly naming time and frequency variables
names(finaldata) <- gsub("^t", "time", names(finaldata))
names(finaldata) <- gsub("^f", "frequency", names(finaldata))

suppressWarnings(
    cleandata <- aggregate(finaldata, by = list(finaldata$subject, finaldata$activity), FUN = mean)
)
colnames(cleandata)[1] <- "Subject"
names(cleandata)[2] <- "Activity"

head(cleandata)
## writing clean data to text file
write.table(cleandata, file = "cleandata.txt", row.name = FALSE)