#read Test set
TestData<-read.table("UCI HAR Dataset/test/X_test.txt",stringsAsFactors=FALSE)
TestLabel<-read.table("UCI HAR Dataset/test/y_test.txt",stringsAsFactors=FALSE)

#read Train set
TrainData<-read.table("UCI HAR Dataset/train/X_train.txt",stringsAsFactors=FALSE)
TrainLabel<-read.table("UCI HAR Dataset/train/y_train.txt",stringsAsFactors=FALSE)

#read subject names
TrainSubject<-read.table("UCI HAR Dataset/train/subject_train.txt",stringsAsFactors=FALSE)
TestSubject<-read.table("UCI HAR Dataset/test/subject_test.txt",,stringsAsFactors=FALSE)

#create TestSet
TestSet<-cbind(TestSubject,TestLabel)
TestSet<-cbind(TestSet,TestData)

#create TrainSet
TrainSet<-cbind(TrainSubject,TrainLabel)
TrainSet<-cbind(TrainSet,TrainData)

#read Activity names
ActivityLabel<-read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors=FALSE)

#read features names
features<-read.table("UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)

#Extracts only the measurements on the mean and standard deviation for each measurement. 
TestSet2<-select(TestSet,grep("subject|activity|mean\\(\\)|std\\(\\)",features$V2,perl=TRUE))
TrainSet2<-select(TrainSet,grep("subject|activity|mean\\(\\)|std\\(\\)",features$V2,perl=TRUE))

#extract names of the measurements on the mean and standard deviation for each measurement
VariableNames<-featureslist[grep("subject|activity|mean\\(\\)|std\\(\\)",features$V2,perl=TRUE),1]

#Merges the training and the test sets to create one data set.
ResultSet2<-rbind(TrainSet2,TestSet2)

#independent tidy data set with the average of each variable for each activity and each subject.
ResultSet3<-summarise_each(group_by(ResultSet2,subject,activity),funs(mean))

#Uses descriptive activity names to name the activities in the data set
ResultSet4=ResultSet3

for(i in 1:nrow(ResultSet3)){
        ResultSet4$activity[i]=ActivityLabel[ResultSet3$activity[i],2]
}

#Appropriately labels the data set with descriptive variable names. 
for(i in 3:66){
        names(ResultSet4)[i]=VariableNames[i-2]
}

#output the result
write.table(ResultSet4,"tidy_result.txt",row.names=FALSE)

