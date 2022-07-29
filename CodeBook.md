# Codebook

## Dataset

The UCI HAR Dataset is described in the following article and was made available "as is".

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. *Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine.* International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

Download data from `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip` and unzip.

The script `run_analysis.R` downloads and unpacks the data. Subsequently, it converts the data.

Variables of the original dataset are described in `UCI ../features_info.txt`.

# Conversion

The script `run_analysis.R` converts the data as follows:

- Clean the data from `UCI HAR Dataset/train/X_train.txt` and `UCI HAR Dataset/test/X_test.txt` by removing redundant whitespace around observations
- Import the cleaned versions of the above two CSV formatted files as a data frame, setting the column names based on `UCI HAR Dataset/features.txt`. Note that `(` and `)` in feature names are replaced by `.`.
- Add a column for activities by importing and binding respectively  `UCI HAR Dataset/train/y_train.txt` and `UCI HAR Dataset/test/y_test.txt`.
- Add a column for subjects by importing and binding respectively `UCI HAR Dataset/train/subject_train.txt` and `UCI HAR Dataset/test/subject_test.txt`
- Add the rows of the resulting test data frame to the train data frame
- Select (besides activity and subject) only columns for mean and standard deviation. This excluded the different `angle*` columns.
- Replace indexes in the column for activities with their textual values as found in `UCI HAR Dataset/activity_labels.txt`.

Next, create a second dataset summarizing results:
- Group by activity and subject (in that order)
- Take the mean of all columns for that grouping
- Note that the column headers are changed by having `_1` added
- Save the resulting data frame in CSV format as `dataset2.txt` using `write.table` with `row.names=FALSE`

## Features

Features of the resulting dataset are:
- activity: name of the activity measured, one of 
  * WALKING 
  * WALKING_UPSTAIRS
  * WALKING_DOWNSTAIRS
  * SITTING
  * STANDING
  * LAYING
- subject: identifier of the subject in a range of 1 to 30
- Mean giving grouping by activity and subject for fields included in the overview below, which is a numeric value in the range [-1, 1] The fields are among those described in `UCI HAR Dataset/features_info.txt`, where `(` and `)` have here been transformed into `.`.


Example:
tBodyAcc.mean...X_1
  is
- tBodyAcc: time body accelleration
- .mean..: mean() 
- _X: over axis X 
- _1: without extra meaning, but denoting a new field in which the mean
of all these records has been taken after grouping by activity and subject.

Full list of features of the tidy dataset:

```
1                       activity
2                        subject
3            tBodyAcc.mean...X_1
4            tBodyAcc.mean...Y_1
5            tBodyAcc.mean...Z_1
6             tBodyAcc.std...X_1
7             tBodyAcc.std...Y_1
8             tBodyAcc.std...Z_1
9         tGravityAcc.mean...X_1
10        tGravityAcc.mean...Y_1
11        tGravityAcc.mean...Z_1
12         tGravityAcc.std...X_1
13         tGravityAcc.std...Y_1
14         tGravityAcc.std...Z_1
15       tBodyAccJerk.mean...X_1
16       tBodyAccJerk.mean...Y_1
17       tBodyAccJerk.mean...Z_1
18        tBodyAccJerk.std...X_1
19        tBodyAccJerk.std...Y_1
20        tBodyAccJerk.std...Z_1
21          tBodyGyro.mean...X_1
22          tBodyGyro.mean...Y_1
23          tBodyGyro.mean...Z_1
24           tBodyGyro.std...X_1
25           tBodyGyro.std...Y_1
26           tBodyGyro.std...Z_1
27      tBodyGyroJerk.mean...X_1
28      tBodyGyroJerk.mean...Y_1
29      tBodyGyroJerk.mean...Z_1
30       tBodyGyroJerk.std...X_1
31       tBodyGyroJerk.std...Y_1
32       tBodyGyroJerk.std...Z_1
33          tBodyAccMag.mean.._1
34           tBodyAccMag.std.._1
35       tGravityAccMag.mean.._1
36        tGravityAccMag.std.._1
37      tBodyAccJerkMag.mean.._1
38       tBodyAccJerkMag.std.._1
39         tBodyGyroMag.mean.._1
40          tBodyGyroMag.std.._1
41     tBodyGyroJerkMag.mean.._1
42      tBodyGyroJerkMag.std.._1
43           fBodyAcc.mean...X_1
44           fBodyAcc.mean...Y_1
45           fBodyAcc.mean...Z_1
46            fBodyAcc.std...X_1
47            fBodyAcc.std...Y_1
48            fBodyAcc.std...Z_1
49       fBodyAccJerk.mean...X_1
50       fBodyAccJerk.mean...Y_1
51       fBodyAccJerk.mean...Z_1
52        fBodyAccJerk.std...X_1
53        fBodyAccJerk.std...Y_1
54        fBodyAccJerk.std...Z_1
55          fBodyGyro.mean...X_1
56          fBodyGyro.mean...Y_1
57          fBodyGyro.mean...Z_1
58           fBodyGyro.std...X_1
59           fBodyGyro.std...Y_1
60           fBodyGyro.std...Z_1
61          fBodyAccMag.mean.._1
62           fBodyAccMag.std.._1
63  fBodyBodyAccJerkMag.mean.._1
64   fBodyBodyAccJerkMag.std.._1
65     fBodyBodyGyroMag.mean.._1
66      fBodyBodyGyroMag.std.._1
67 fBodyBodyGyroJerkMag.mean.._1
68  fBodyBodyGyroJerkMag.std.._1
```



