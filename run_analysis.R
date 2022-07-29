library(dplyr)
library(readr)

##################################################################
## 0. Obtain the data --------------------------------------------
data_dir <- "UCI HAR Dataset"

# Download and unpack the original UCI HAR Dataset. Only do this if the data
# doesn't exist locally.
if (!file.exists(data_dir)) {
  data_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(data_url, 'UCI_HAR_Dataset.zip')
  unzip('UCI_HAR_Dataset.zip')
}

# Read features/labels from features.txt
features <- read.csv(file.path(data_dir, "features.txt"), 
                     header=FALSE, 
                     sep=' ',
                     row.names=1, 
                     col.names=c('index', 'feature')
                     )

# Read activity labels
read_activity_labels <- function(path) {
  a <- read.csv(file.path(data_dir, 'activity_labels.txt'), sep=' ', header=FALSE, col.names=c('index', 'activity'), row.names=1)
  a
}



##################################################################
## 1. Merge the training and the test sets to create one data set

# Read data from file, normalize separators to single space, trim, 
# and return as string
get_cleaned_data <- function(path) {
  # Read entire data file into a variable
  t <- read_file(path)
  # Get rid of whitespace before and after newlines
  t1 <- gsub('[ \t]*\n[ \t]*', '\n', t)
  # Collapse all space/tab sequences into a single space
  t2 <- gsub('[ \t]+', ' ', t1)
  # Trim beginning
  t3 <- trimws(t2, which="left")
  t3
}

# Read main data file 'X_*.txt'
read_data <- function(path, features) {
  print(paste("Reading: ", path))
  t <- get_cleaned_data(path)
  # note that features are automatically normalised using `make.names`
  # so all mean() and std() become mean.. and std..
  df <- read.table(text=t, col.names=features)
  df
}

# Read activity for all rows
read_activity <- function(path) {
  a <- read.csv(path, sep=' ', header=FALSE, col.names=c('activity'))
  a
}

# Read subject for all rows
read_subject <- function(path) {
  s <- read.csv(path, header=FALSE, col.names=c("subject"))
  s
}

# Per either 'train' or 'test': Combine 'X_*', 'y_*' (=activity), 'subject_*' and combine them into a single
# dataset for either train or test
read_and_combine <- function(train_or_test, features) {
  base_dir <- file.path(data_dir, train_or_test)
  df <- read_data(file.path(base_dir, paste('X_', train_or_test, '.txt', sep='')), features)
  a <- read_activity(file.path(base_dir, paste('y_', train_or_test, '.txt', sep='')))
  s <- read_subject(file.path(base_dir, paste('subject_', train_or_test, '.txt', sep='')))
  ndf <- cbind(df, a, s)
  ndf
  }

# Actually read the data. Note that column names are set based on 'features'
train <- read_and_combine("train", features[['feature']])
test <- read_and_combine("test", features[['feature']])

# Combine records of train and test
df <- rbind(train, test)


##############################################################################
# 2. Extract only the measurements on the mean and standard deviation for each measurement.

# Select only the columns representing a mean or standard deviation.
# Exclude columns where means are combined into an angle, 
# e.g. angle(tBodyAccMean,gravity)
select_columns <- function(df) {
  ndf <- select(df, !starts_with("angle") & (
    contains("std..") | contains("mean..")), activity, subject )
  ndf
}

ndf <- select_columns(df)

########################################################################
# 3. Use descriptive activity names to name the activities in the data set

# Use activity names, rather than index name
make_activity_names <- function(df) {
  activities <- read.csv(file.path(data_dir, 'activity_labels.txt'), sep=' ', header=FALSE, col.names=c('index', 'activity'), row.names=1)
  #ndf <- mutate(df, activity_label = activities[[1]][activity])
  ndf <- mutate(df, activity = activities[[1]][activity])
}

ndf <- make_activity_names(ndf)

#########################################################################
# 4. Appropriately label the data set with descriptive variable names

# We have already set meaningful column names by using 'features.txt' and 
# setting other column names when reading the data, so there is nothing 
# more to be done.



##########################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

# Group the dataset by activity and subject
g <- group_by(ndf, activity, subject)

# Create the new dataset using `summarise``
dataset2 <- data.frame(unclass(summarise(g, across(everything(), list(mean)))))

write.table(dataset2, "dataset2.txt", row.name=FALSE)


