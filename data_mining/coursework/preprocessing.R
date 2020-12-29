library("fpc")
library("dbscan")
setwd("../Desktop/masters/data_mining/coursework")

dataset = read.csv("regional_covid_data.csv")

# Removing unnecessary columns and renaming
dataset = subset(dataset, select = -c(areaType, areaCode))
names(dataset)[names(dataset) == "cumCasesBySpecimenDate"] = "cumCases"
names(dataset)[names(dataset) == "newCasesBySpecimenDate"] = "newCases"
names(dataset)[names(dataset) == "cumDeathsByDeathDate"] = "cumDeaths"
names(dataset)[names(dataset) == "newDeathsByDeathDate"] = "newDeaths"
names(dataset)[names(dataset) == "newCasesBySpecimenDateRollingRate"] = "newCasesAvg" 
# Rolling rate is a calculated weekly average

# Remove null values
dataset = dataset[rowSums(is.na(dataset)) == 0,]
# Label encode regions as integers
regions = unique(dataset$areaName)
dataset$areaName = as.numeric(factor(dataset$areaName, levels=regions))


# Convert dates to valid date format and select date range
dataset$date = as.Date(dataset$date, "%d/%m/%Y")
# Time-span cut-off
dataset = dataset[dataset$date >= as.Date("2020-04-01"),] # Beginning of dataset
dataset = dataset[dataset$date >= as.Date("2020-09-01"),] # 2nd Lockdown released


#Standardisation
dataset$date = as.numeric(dataset$date - min(dataset$date, na.rm = TRUE))
dataset$stdDate = dataset$date - min(dataset$date, na.rm = TRUE)
dataset$stdDate = dataset$date / max(dataset$date, na.rm = TRUE)
dataset$stdRollRate = dataset$newCasesAvg - min(dataset$newCasesAvg, na.rm = TRUE)
dataset$stdRollRate = dataset$newCasesAvg / max(dataset$newCasesAvg, na.rm = TRUE)


# DBScan pre-processing
dataMatrix = cbind(dataset$stdDate, dataset$stdRollRate)
nonStdDataMatrix = cbind(dataset$date, dataset$newCasesAvg)
colnames(dataMatrix) = c("Date", "RollRate")
colnames(nonStdDataMatrix) = c("Date", "RollRate")

# Finding the optimal epoc for minimum points
kNNdistplot(dataMatrix, k=3) # Min points 3 seems best for  Sept+ data
abline(h = 0.035, lty = 2)
abline(h = 0.02, lty = 2)


# DBScan
dbscanOut = dbscan(dataMatrix, eps=0.02, MinPts = 3) # The best one for Sept data

plot(dbscanOut, nonStdDataMatrix, main="DBScan Cluster Results")

# Conclusion - DBScan is ok for seeing overall groupings, like maybe tier 2 and below (see Sept data)
# Not so good for general conclusions with large numbers of data



# Chart analysis
# New cases per day
plot(dataset$date, dataset$newCases, col=dataset$areaName, xlab="Date", ylab="New Cases", pch=19, 
     main="COVID-19, New cases per day")
legend("topleft", legend=regions, col=c(1:9), pch=19)

# Rolling Rate Chart
plot(dataset$date, dataset$newCasesAvg, col=dataset$areaName, xlab="Date", ylab="Average Cases per 100K", pch=19, 
     main="COVID-19, Average new cases per week")
legend("topleft", legend=regions, col=c(1:9), pch=19)

# Cumulative Deaths Chart
plot(dataset$date, dataset$newDeaths, col=dataset$areaName, xlab="Date", ylab="Deaths per 100k", pch=19, 
     main="COVID-19, Cummulative deaths")
legend("topleft", legend=regions, col=c(1:9), pch=19)




