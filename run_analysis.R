## read data of X_train, X_test, Y_train, Y_test
X_train<-read.table(file = "X_train.txt",header=F)
Y_train<-read.table(file="Y_train.txt",header=F)
X_test<-read.table(file="X_test.txt",header=F)
Y_test<-read.table(file="Y_test.txt",header=F)

## read features of activities and labels for Y
features<-read.table(file="features.txt")
Y_label<-read.table(file="activity_labels.txt",header=F)

# I use a script to transform label numbers into string labels provided by activity_labels.txt
source("returnActivityLabel.R")
Y_train_in_name<-sapply(Y_train, returnActivityLabel, Y_label)
Y_test_in_name<-sapply(Y_test, returnActivityLabel, Y_label)

# add extra column as identifier for test group and train group
X_test<-cbind(test_or_train=rep("test",2947),X_test)
X_train<-cbind(test_or_train=rep("train",7352),X_train)
total_X<-rbind(X_train,X_test)
colnames(total_X)<-c("test_or_train",features[,2])
titles<-features[,2]
titles<-c("test_or_train",as.character(titles))
colnames(total_X)<-titles

#combine Y_train and Y_test then to total_X
total_Y<-c(Y_train_in_name,Y_test_in_name)
Combined<-cbind(total_Y,total_X)
colnames(Combined)[1]<-"train_activity"

#combine subject number list together then to previously combined list
subject_train<-read.table("subject_train.txt")
subject_test<-read.table("subject_test.txt")
total_subject<-c(subject_train[[1]],subject_test[[1]])
Combined<-cbind(total_subject,Combined)
colnames(Combined)[1]<-"subject_no."

# search for variable names with "mean","std","Mean" and select these from original dataframes to make new one
varnames<-colnames(Combined)
namelist<-c(grep(varnames,pattern="mean"),grep(varnames,pattern="std"),grep(varnames,pattern="Mean"))
namelist<-c(1,2,3,namelist)
namelist<-sort(namelist)
library(dplyr)
new_combined<-select(Combined,namelist)

# split the combined data by factors of (1) subject number (2) type of train activity (3) test/train group
final_combined<-split(new_combined,list(new_combined$subject_no.,new_combined$train_activity,new_combined$test_or_train),drop=T)

# calculate the mean of 86 variables identified by group, then combine together
mean_by_group<-matrix(sapply(final_combined[[1]][4:89],mean),ncol=86,nrow=1)
colnames(mean_by_group)<-names(final_combined[[1]][4:89])
for (var in 2:length(final_combined))
{
  mean_by_group<-rbind(mean_by_group,sapply(final_combined[[var]][4:89],mean))
}

mean_by_group<-cbind(names(final_combined),mean_by_group)
colnames(mean_by_group)[1]<-"subject_no/activity/group"
finalresult<-data.frame(mean_by_group)
write.table(finalresult,file = "result.txt",row.name=F)


