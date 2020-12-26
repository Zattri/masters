library("fpc")
library("dbscan")
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


# Select records within specific range
dataset = dataset[dataset$date >= as.Date("2020-04-01"),] # Beginning of dataset
dataset = dataset[dataset$date >= as.Date("2020-09-01"),] # Recent lockdown selection


# Convert the dates to ordered integer of days since first selected record in dataset
dataset$date = as.numeric(dataset$date - min(dataset$date, na.rm = TRUE))

# Standardise date numbers to be between 0 and 1
dataset$stdDate = dataset$date - min(dataset$date, na.rm = TRUE)
dataset$stdDate = dataset$date / max(dataset$date, na.rm = TRUE)
# Standardise the rolling average
dataset$stdRollRate = dataset$newCasesBySpecimenDateRollingRate - min(dataset$newCasesBySpecimenDateRollingRate, na.rm = TRUE)
dataset$stdRollRate = dataset$newCasesBySpecimenDateRollingRate / max(dataset$newCasesBySpecimenDateRollingRate, na.rm = TRUE)




dataMatrix = cbind(dataset$stdDate, dataset$stdRollRate)
nonStdDataMatrix = cbind(dataset$date, dataset$newCasesBySpecimenDateRollingRate)
colnames(dataMatrix) = c("Date", "RollRate")
colnames(nonStdDataMatrix) = c("Date", "RollRate")
#plot(dataMatrix)

kNNdistplot(dataMatrix, k=2)
kNNdistplot(dataMatrix, k=3)
kNNdistplot(dataMatrix, k=4)
kNNdistplot(dataMatrix, k=5)
abline(h = 0.04, lty = 2)
abline(h = 0.03, lty = 2)
abline(h = 0.02, lty = 2)
abline(h = 0.008, lty = 2)

kNNdistplot(dataMatrix, k=6)
kNNdistplot(dataMatrix, k=7)
kNNdistplot(dataMatrix, k=8)
kNNdistplot(dataMatrix, k=9)
kNNdistplot(dataMatrix, k=10)
kNNdistplot(dataMatrix, k=15)
kNNdistplot(dataMatrix, k=20)

# DBScan
dbscanOut = dbscan(dataMatrix, eps=0.02, MinPts = 3) # The best one for Sept data
dbscanOut = dbscan(dataMatrix, eps=0.008, MinPts = 2) # The one for all time data - doesn't work well
dbscanOut = dbscan(dataMatrix, eps=0.03, MinPts = 3)
dbscanOut = dbscan(dataMatrix, eps=0.03, MinPts = 5)
dbscanOut = dbscan(dataMatrix, eps=0.04, MinPts = 5)
dbscanOut = dbscan(dataMatrix, eps=0.06, MinPts = 9)

plot(dbscanOut, nonStdDataMatrix)

# Conclusion - DBScan is ok for seeing overall groupings, like maybe tier 2 and below (see Sept data)
# Not so good for general conclusions with large numbers of data



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

regionStats = dataset[dataset$date >= as.Date("2020-11-01"),]
plot(regionStats$date, regionStats$newCasesBySpecimenDate, col=regionStats$areaName, xlab="Date", ylab="New Cases", pch=19, 
     main="COVID-19, New cases per day since Sept")
legend("topleft", legend=regions[1:9], col=c(1:9), pch=19)

regionStats = dataset[dataset$date >= as.Date("2020-09-01"),] #& dataset$areaName <= 8
plot(regionStats$date, regionStats$newCasesBySpecimenDateRollingRate, col=regionStats$areaName, xlab="Date", ylab="New Cases", pch=19, 
     main="COVID-19, Average cases per week since September")
legend("topleft", legend=regions[1:9], col=c(1:9), pch=19)

# Cummulative Deaths Graph
dataset = dataset[dataset$date >= as.Date("2020-10-01"),]
plot(dataset$date, dataset$newDeathsByDeathDate, col=dataset$areaName, xlab="Date", ylab="Deaths per 100k", pch=19, 
     main="COVID-19, Cummulative Deaths")
legend("topleft", legend=regions[1:9], col=c(1:9), pch=19)




