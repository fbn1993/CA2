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


NIpostcodes_dataframe[NIpostcodes_dataframe==""] <- NA
NIpostcodes_dataframe

# Showing the total number of missing values and their mean

colSums(is.na(NIpostcodes_dataframe))
colMeans(is.na(NIpostcodes_dataframe))


#  Modifying the County attribute to be a categorising factor


NIpostcodes_dataframe$MapLocation[NIpostcodes_dataframe$County == "ANTRIM"] <- "NORTH-EAST"
NIpostcodes_dataframe$MapLocation[NIpostcodes_dataframe$County ==  "LONDONDERRY"] <- "NORTH-WEST"
NIpostcodes_dataframe$MapLocation[NIpostcodes_dataframe$County == "DOWN"] <- "SOUTH-EAST"
NIpostcodes_dataframe$MapLocation[NIpostcodes_dataframe$County == "ARMAGH"] <- "SOUTH"
NIpostcodes_dataframe$MapLocation[NIpostcodes_dataframe$County == "TYRONE"] <- "WEST"
NIpostcodes_dataframe$MapLocation[NIpostcodes_dataframe$County == "FERMANAGH"] <- "SOUTH-WEST"


## Recode MapLocation so that is ordinal and factored with the
## order NORTH-EAST, NORTH-WEST, SOUTH-EAST, SOUTH, WEST, SOUTH-WEST
## We'll srore the ordinal factored data in variable 'MapLocation'
MapLocation <- factor(NIpostcodes_dataframe$MapLocation, order = TRUE, levels = c("NORTH-EAST", "NORTH-WEST", 
                                                                                  "SOUTH-EAST", "SOUTH", "WEST",
                                                                                  "SOUTH-WEST"))

## Replace NIpostcode_dataframe'' attribute with newly ordinal foctored data
NIpostcodes_dataframe$MapLocation <- MapLocation

# Moving the primary key column at start
head(NIpostcodes_dataframe)
NIpostcodes_dataframe <- NIpostcodes_dataframe[, c(15, 1:14, 16)]
head(NIpostcodes_dataframe)

# Creating a new dataset of Town Limavady and storing it in csv file
NIpostcodes_dataframe2 <- NIpostcodes_dataframe[ which(NIpostcodes_dataframe$Town == "LIMAVADY" ), ]
Limavady_data <- NIpostcodes_dataframe2[c(9:11)]
write.csv(Limavady_data, file= "Limavady.csv")


# Saving the cleaned NIpostcode dataframe in csv file
write.csv(NIpostcodes_dataframe, file = "CleanedNIPostcodeData.csv", row.names = FALSE, col.names = FALSE)
