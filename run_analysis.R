#Run this file to merge and process the dataset files in
#the dataraw folder to merge and process it into one
#single tidy dataset.
#must set working directory to be on run_analysis.R folder level
#with setwd("path_to_folder_with_r_Script")

#Loading needed libraries
library(sqldf);
library(dplyr);
#Cheking if rawdata exists and contains README.txt,
#assumimng that the data was unzipped under rawdata folder
if(!file.exists("./rawdata/README.txt")){
  stop("unzip files in rawdata Folder");
}else{
  print("Tidy Data Conversion Started");
  #Setting helper vector with activity data
  activity_frame <- read.table("./rawdata/activity_labels.txt", encoding="UTF-8");
  colnames(activity_frame) <- c("activity_code","activity_name");
  #setting helper vector with features data
  features_frame <- read.table("./rawdata/features.txt", encoding="UTF-8");
  colnames(features_frame) <- c("feature_column_num","feature_name");
  #getting features vectors with mean or sdt data, using sqldf is quite handy
  working_features <- sqldf("select * from features_frame where feature_name like '%mean()%' or feature_name like '%std()%'");
  #removing usused datasets
  rm(features_frame);
  
  #Loading datasets from test and train data
  test_feature_values <- read.table("./rawdata/test/X_test.txt");
  train_feature_values <-read.table("./rawdata/train/X_train.txt");
  #merging with only working columns containing mean and std values
  merged_feature_set <- rbind(test_feature_values[,working_features[,1]], train_feature_values[,working_features[,1]]);
  #setting features descriptive names to merged set without special characters
  colnames(merged_feature_set) <- gsub("\\(\\)","",gsub("-","_",working_features[,2]));
  #cleaning memory for unused datasets
  rm(test_feature_values);
  rm(train_feature_values);
  #rm(working_features);
  
  print("Merging Data Sets Completed");
  
  #getting activity dataset from test and train
  test_feature_activities <- read.table("./rawdata/test/y_test.txt");
  train_feature_activities <- read.table("./rawdata/train/y_train.txt");
  #merging both datasets into one set (same order as the merge in features values first test then train dataset)
  merged_feature_activities <- rbind(test_feature_activities, train_feature_activities);
  #using sqldf to make activity name replacement by code
  #using alias to datasets for easy comparison from both datasets
  merged_feature_activities <- sqldf("select b.activity_name from merged_feature_activities a inner join activity_frame b on a.V1= b.activity_code");
  #renaming column name to a descriptive variable name
  colnames(merged_feature_activities)<-c("activity_name");
  #cleaning memory from unused data frames
  rm(test_feature_activities);
  rm(train_feature_activities);
  rm(activity_frame);
  
  print("Merging Activities Completed");
  
  #loading datasets from test and train of subject for every observation
  test_feature_subject <- read.table("./rawdata/test/subject_test.txt");
  train_feature_subject <- read.table("./rawdata/train/subject_train.txt");
  #mergin dataset in same order as the values and activities first test and then train
  merged_feature_subject <- rbind(test_feature_subject, train_feature_subject);
  #setting column name to descriptive value
  colnames(merged_feature_subject) <- c("subject_code");
  #cleaning unused datasets
  rm(test_feature_subject);
  rm(train_feature_subject);
  
  
  #binding merged dataset into one
  merged_tidy_dataset <- cbind(merged_feature_activities, merged_feature_subject, merged_feature_set);
  
  #cleaning unused dataset
  rm(merged_feature_activities);
  rm(merged_feature_set);
  rm(merged_feature_subject);
  
  print("Merging Subjects Completed");
  
  #subsetting dataset to get the mean of every variable summarized by subject and activiy
  grouped_set <- group_by(merged_tidy_dataset, activity_name, subject_code);
  #summarizing data using summarise_each which uses the functions passed to funs parameter for every
  #column not in the group_by declaration
  tidy_summary <-summarise_each(grouped_set, funs(mean));
  #writing to persistent file
  write.table("./tidydata/tidy_wearable_summarized_data.txt", tidy_summary,row.name=FALSE);
  #cleaning unused data sets
  rm(grouped_set);
  
  print("Tidy Data Set saved completed");
  
  print("Tidy Data Conversion Completed");
}