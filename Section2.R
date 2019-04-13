
setwd("NI Crime Data")
csv_files <- dir(pattern='*.csv$', recursive = TRUE)
library(dplyr)


for(i in 1:length(csv_files)) {
  if(i == 1)
    AllNICrimeData_dataframe <- read.csv(csv_files[i])
  else
    AllNICrimeData_dataframe <- rbind(AllNICrimeData_dataframe, read.csv(csv_files[i]))
}
AllNICrimeData_dataframe <- rbind_all(lapply(csv_files, read.csv))
head(AllNICrimeData_dataframe)
setwd("..")
write.csv(AllNICrimeData_dataframe, file = "AllNICrimeData.csv")
ncol(AllNICrimeData_dataframe)
nrow(AllNICrimeData_dataframe)
CleanedNIPostcodeData <- read.csv("CleanedNIPostcodeData.csv")
AllNICrimeData_dataframe <- subset(AllNICrimeData_dataframe, select = -c(Crime.ID, Reported.by, Falls.within, 
                                                                         LSOA.code,LSOA.name, Last.outcome.category,
                                                                         Context))
str(AllNICrimeData_dataframe)
AllNICrimeData_dataframe$Crime.type = as.factor(AllNICrimeData_dataframe$Crime.type)
str(AllNICrimeData_dataframe)
AllNICrimeData_dataframe$Location <- gsub("On or near", '', AllNICrimeData_dataframe$Location, ignore.case = FALSE)
AllNICrimeData_dataframe$Location <- trimws(AllNICrimeData_dataframe$Location, which = "both")
AllNICrimeData_dataframe$Location <- sub("^$", "No Location", AllNICrimeData_dataframe$Location)

head(AllNICrimeData_dataframe)

AllNICrimeData_summary <- group_by(AllNICrimeData_dataframe, Location)

colSums(is.na(AllNICrimeData_dataframe["Location"]))

random_crime_sample <- sample_n(AllNICrimeData_dataframe, 1000)

