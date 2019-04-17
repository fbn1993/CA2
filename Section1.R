# Insert NI postcodes data into data frame
NIpostcodes_dataframe=read.csv("NIPostcodes.csv",header = 0)
head(NIpostcodes_dataframe)
# Showing total number of rows in data frame
nrow(NIpostcodes_dataframe)

# Visualizing the structure of dataframe
str(NIpostcodes_dataframe)

# Showing the first 10 rows of dataframe
head(NIpostcodes_dataframe, n = 10)

# Adding suitable titles to the attributes
colnames(NIpostcodes_dataframe) <- c("Organization Name", "Sub-building Name", "Building Name", "Number", 
                                     "Primary Thorfare", "Alt Thorfare", "Secondary Thorfare", "Locality", 
                                     "Townland", "Town", "County","Postcode", "x-coordinates", "y-coordinates",
                                     "Primary Key")
str(NIpostcodes_dataframe)

# Replacing the missing values with "Not Available"
NIpostcodes_dataframe[1:14] <- lapply(NIpostcodes_dataframe[1:14], as.character)
NIpostcodes_dataframe[NIpostcodes_dataframe == ""] <- 'Not Available'

str(NIpostcodes_dataframe)

# Showing the total number of missing values and their mean
sum(NIpostcodes_dataframe == "Not Available")
mean(NIpostcodes_dataframe == "Not Available")

#Categorizing the County column based on the year they were created.
NIpostcodes_dataframe$County <- as.factor(NIpostcodes_dataframe$County)
NIpostcodes_dataframe$County_Created <- ifelse(NIpostcodes_dataframe$County == "ARMAGH", 'Before 1600s', 
                                     ifelse(NIpostcodes_dataframe$County == "TYRONE",
                                  'Before 1600s', ifelse(NIpostcodes_dataframe$County == "FERMANAGH", 
                                                         'Before 1600s', 'After 1600s')))

str(NIpostcodes_dataframe)


# Moving the primary key column at start

NIpostcodes_dataframe <- NIpostcodes_dataframe[, c(15, 1:14, 16)]
str(NIpostcodes_dataframe)

# Creating a new dataset of Town Limavady and storing it in csv file
NIpostcodes_dataframe2 <- NIpostcodes_dataframe[ which(NIpostcodes_dataframe$Town == "LIMAVADY" ), ]
Limavady_data <- NIpostcodes_dataframe2[c(9:11)]
write.csv(Limavady_data, file= "Limavady.csv", row.names = FALSE, col.names = FALSE)
str(Limavady_data)

# Saving the cleaned NIpostcode dataframe in csv file
write.csv(NIpostcodes_dataframe, file = "CleanedNIPostcodeData.csv", row.names = FALSE, col.names = FALSE)
str(NIpostcodes_dataframe)
