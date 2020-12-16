setwd("../Desktop/masters/data_mining/coursework")

dataset = read.csv("regional_covid_data.csv")
head(dataset)
str(dataset)

# Remove null values from the dataset
dataset = dataset[rowSums(is.na(dataset)) == 0,]

# Convert dataset areaNames to numerical values - Label encoding
# Get unique area names into vector
regions = unique(dataset$areaName)

#Convert to numeric values and set dataset$areaNames to numeric values
dataset$areaName = as.numeric(factor(dataset$areaName, levels=regions))

# Convert dates from chr format to valid date format
dataset$date = as.Date(dataset$date, "%d/%m/%Y")
# Select records after specific range (other data is too early in the outbreak to be useful)
dataset = dataset[dataset$date >= as.Date("2020-04-01"),]

