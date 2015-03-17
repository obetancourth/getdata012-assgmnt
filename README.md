# getdata012-assgmnt
## Coursera Project for Getting and Cleaning data Module

This project contains all the procedures that merges the data available
in the **rawdata** folder downloaded from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##Packages Required
1. sqldf  *install.packages("sqldf")*
2. dplyr  *install.packages("dplyr")*

## Project Structure
- rawdata
  -- *contains unzipped data files downloaded from url specified aboved*
- tidydata
  -- *contains data file resulting from running run_analysis.R*
- codebook.txt
  -- *file that specifies the variables in the tidy data set*
- run_analysis.R
  -- *r Script File that loads all datasets in rawdata folder, process it and writes the resulting datset into the tidydata folder*

##Running Steps
1. Unzip raw data in the rawdata folder
2. Set r working directory to the directory path of run_analysis.R file.
3. On R Console run source("./run_analysis.R") and press Enter key
4. Search in the tidydata folder for the processed data set.
