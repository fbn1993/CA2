# Merging all the csv files within nested folders into a separate dataset and visulizing the count of rows and columns
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
write.csv(AllNICrimeData_dataframe, file = "AllNICrimeData.csv", row.names = FALSE, col.names = FALSE)
CleanedNIPostcodeData <- read.csv("CleanedNIPostcodeData.csv")
ncol(AllNICrimeData_dataframe)
nrow(AllNICrimeData_dataframe)

str(AllNICrimeData_dataframe)

# Subsetting the dataframe by removing unnecessary columns
AllNICrimeData_dataframe <- subset(AllNICrimeData_dataframe, select = -c(Crime.ID, Reported.by, Falls.within, 
                                                                         LSOA.code,LSOA.name, Last.outcome.category,
                                                                        Context))
str(AllNICrimeData_dataframe)

# Using Crime.type as a categorizing factor to divide the crime types on the basis of crime intensity
AllNICrimeData_dataframe$Crime.type = as.factor(AllNICrimeData_dataframe$Crime.type)
AllNICrimeData_dataframe$Crime_Intensity <- ifelse(AllNICrimeData_dataframe$Crime.type == "Anti-social behaviour", 'Non-lethal', 
                                            ifelse(AllNICrimeData_dataframe$Crime.type == "Public order",'Non-lethal', 
                                            ifelse(AllNICrimeData_dataframe$Crime.type == "Bicycle theft", 'Non-lethal', 
                                            ifelse(AllNICrimeData_dataframe$Crime.type == "Robebry", 'Non-lethal', 
                                            ifelse(AllNICrimeData_dataframe$Crime.type == "Burglary", 'Non-lethal',           
                                            ifelse(AllNICrimeData_dataframe$Crime.type == "Shoplifting", 'Non-lethal',
                                            ifelse(AllNICrimeData_dataframe$Crime.type == "Vehicle crime", 'Non-lethal',
                                            ifelse(AllNICrimeData_dataframe$Crime.type == "Other theft", 'Non-lethal',
                                            ifelse(AllNICrimeData_dataframe$Crime.type == "Theft from the person", 'Non-lethal',
                                                   'Lethal'
                                                   )))))))))
str(AllNICrimeData_dataframe)

# Removing "On or near" from Location so it only contains street name and putting "No Location" at the place of missing values
AllNICrimeData_dataframe$Location <- gsub("On or near", '', AllNICrimeData_dataframe$Location, ignore.case = FALSE)
AllNICrimeData_dataframe$Location <- trimws(AllNICrimeData_dataframe$Location, which = "both")
AllNICrimeData_dataframe$Location <- sub("^$", "No Location", AllNICrimeData_dataframe$Location)

str(AllNICrimeData_dataframe)

# Extracting 1000 random variables from dataset and creating a function to add postcodes column to the dataset 
# and viewing its structure and number of rows and columns. Also writing the dataframe to csv file.

AllNICrimeData_dataframe2 <-AllNICrimeData_dataframe[!rowSums(AllNICrimeData_dataframe[4] == "No Location"),]
random_crime_sample <- sample_n(AllNICrimeData_dataframe2, size = 1000)


random_crime_sample$Location <- toupper(random_crime_sample$Location)

NIpostcodes_subset <- CleanedNIPostcodeData[, c(6, 13)]

NIpostcodes_subset <- NIpostcodes_subset[!duplicated(NIpostcodes_subset$Primary.Thorfare), ]
colnames(NIpostcodes_subset) <- c("Primary.Thorfare", "Postcode")
random_crime_sample$Postcode <- NA
find_a_postcode <- function(random_crime_sample, Location){
Postcode <- NIpostcodes_subset$Postcode[match(random_crime_sample$Location, 
                                                                  NIpostcodes_subset$Primary.Thorfare)]
return(Postcode)
}
Postcode <- find_a_postcode(random_crime_sample, Location)
random_crime_sample$Postcode <- Postcode
str(random_crime_sample)
nrow(random_crime_sample)
ncol(random_crime_sample)

write.csv(random_crime_sample, file = "random_crime_sample.csv", row.names = FALSE, col.names = FALSE)
str(random_crime_sample)

# Updating the random sample dataset such that it only contains specific columns and sorting those columns with respect 
# to postcode column containing "BT1" and Crime.type

updated_random_sample <- subset(random_crime_sample, select = -c(6))
chart_data <- updated_random_sample
chart_data <- filter(chart_data, grepl("BT1", Postcode))
chart_data <- chart_data[order(chart_data$Postcode == "BT1", chart_data$Crime.type), ]
summary(chart_data)

str(chart_data)
# Creating a bar plot using chart data for Crime.type column and also assigning suitable title for the bar plot.
counts <- table(chart_data$Crime.type)
barplot(counts, main = "Crime Type Distribution", xlab = "Types of Crime", ylab = "Count of Crime Type")
