setwd("../Desktop/masters/data_mining/coursework")

dataset = read.csv("regional_covid_data.csv")
head(dataset)
str(dataset)

# Drop areaType and areaCode columns, these are unnecessary
dataset = subset(dataset, select = -c(areaType, areaCode))

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


# Chart analysis
westMid = dataset[dataset$areaName == 5,]
plot(westMid$date, westMid$newCasesBySpecimenDateRollingRate, xlab="Date", ylab="New Cases, Rolling Rate", pch=19)
plot(westMid$date, westMid$newCasesBySpecimenDate, xlab="Date", ylab="New Cases, Rolling Rate", pch=19)

septStats = dataset[(dataset$areaName == 5 || dataset$areaName ==  8) & dataset$date >= as.Date("2020-09-01"),]
plot(westMidRecent$date, westMidRecent$newCasesBySpecimenDate, xlab="Date", ylab="New Cases", pch=19, main="COVID-19 West Midlands new cases per day since Sept")

southEastRecent = dataset[dataset$areaName == 8 & dataset$date >= as.Date("2020-09-01"),]

septStats = dataset[(dataset$areaName == 5 | dataset$areaName ==  8) & dataset$date >= as.Date("2020-09-01"),]
plot(septStats$date, septStats$newCasesBySpecimenDate, col=septStats$areaName, xlab="Date", ylab="New Cases", pch=19, 
    main="COVID-19, New cases per day since Sept")
legend("topleft", legend=c("West Mid", "South"), col=c(5,8), pch=19)

regionStats = dataset[dataset$date >= as.Date("2020-09-01") & dataset$areaName <= 8,]
plot(regionStats$date, regionStats$newCasesBySpecimenDate, col=regionStats$areaName+2, xlab="Date", ylab="New Cases", pch=19, 
     main="COVID-19, New cases per day since Sept")
legend("topleft", legend=regions[1:8], col=c(1:8), pch=19)



