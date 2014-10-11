This is the README file for Peer reviewed course project of JHU MOOC course: Getting and Cleaning Data.

The run_analysis.R is the script for generating final dataset.
First we read data from X_train,X_test,Y_train,Y_test.
then features of activities was read from features.txt
I used a script named “returnActivityLabel.R” to turn activity labels into activity names.

Additional column was added as identifier for test/train group.
The data was combined accordingly(as described in commentary in the code)
I searched for variable names with "mean","std","Mean" and select these from original data.frames to make new one.

Finally I split the combined data by factors of subject number,train activity and test/train group, mean was calculated in the variables identified, then combined again as matrix.

The 1st column of the final data is the subject number and type of activities performed. Each row has the 1st column as identifier, followed by means of means or standard deviations of the data.

for each data, the coding scheme as follows:
Body - body signals
Gravity - gravity signals
Acc - acceleration signals
Gyro - gyroscope signals
Jerk - jerk signals derived from acceleration and angular velocity
Mag: stands for magnitude
XYZ stands for directions in 3D space
the prefix “t” denote time, and “f” stands for signal applied FFT.

Other related naming please refer to features_info.txt

