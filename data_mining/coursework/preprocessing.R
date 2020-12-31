library("fpc")
library("dbscan")
library("TTR")
library("forecast")

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
dataset = dataset[dataset$date >= as.Date("2020-11-08"),] # Select last month


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
kNNdistplot(dataMatrix, k=3)
abline(h = 0.035, lty = 2)
abline(h = 0.02, lty = 2)


# DBScan
dbscanOut = dbscan(dataMatrix, eps=0.02, MinPts = 3)
plot(dbscanOut, nonStdDataMatrix, main="DBScan Cluster Results")


# Exponential smoothing for regional data | Data reversed because order is newest -> oldest
northEast = dataset[dataset$areaName == 1,]
northEastTs = rev(ts(northEast$newCases))

westMid = dataset[dataset$areaName == 6,]
westMidTs = rev(ts(westMid$newCases))

london = dataset[dataset$areaName == 7,]
londonTs = rev(ts(london$newCases))

southEast = dataset[dataset$areaName == 8,]
southEastTs = rev(ts(southEast$newCases))

# Raw data for analysis
plot(northEast$date, northEast$newCases)
plot(westMid$date, westMid$newCases)
plot(london$date, london$newCases)
plot(southEast$date, southEast$newCases)

plot.ts(westMidTs, main="West Midlands New Cases", xlab="Days since Nov 8th (1 month prior)", ylab="New cases per day") 

# Holt winters forecasting and evaluation
northEastTs.forecast = HoltWinters(northEastTs, beta=FALSE, gamma=FALSE, l.start=1295)
plot(northEastTs.forecast , xlab="Days since Nov 8th (last month)", ylab="Observed / Fitted, New Cases", main="")
northEastTs.forecast$SSE

westMidTs.forecast = HoltWinters(westMidTs, beta=FALSE, gamma=FALSE, l.start=1076)
plot(westMidTs.forecast, xlab="Days since Nov 8th (last month)", ylab="Observed / Fitted, New Cases")
westMidTs.forecast$SSE

londonTs.forecast = HoltWinters(londonTs, beta=FALSE, gamma=FALSE, l.start=1757)
plot(londonTs.forecast, xlab="Days since Nov 8th (last month)", ylab="Observed / Fitted, New Cases")
londonTs.forecast$SSE

southEastTs.forecast = HoltWinters(southEastTs, beta=FALSE, gamma=FALSE, l.start=1951)
plot(southEastTs.forecast, xlab="Days since Nov 8th (last month)", ylab="Observed / Fitted, New Cases")
southEastTs.forecast$SSE


# Forecasting Models
northEastTs.forecast.future = forecast:::forecast.HoltWinters(northEastTs.forecast, h=7)
plot(northEastTs.forecast.future, xlab="Days since Nov 8th (last month)", ylab="New Cases", main="North East Future Forecasting - HoltWinters")

westMidTs.forecast.future = forecast:::forecast.HoltWinters(westMidTs.forecast, h=7)
plot(westMidTs.forecast.future, xlab="Days since Nov 8th (last month)", ylab="New Cases", main="West Midlands Future Forecasting - HoltWinters")

londonTs.forecast.future = forecast:::forecast.HoltWinters(londonTs.forecast, h=7)
plot(londonTs.forecast.future, xlab="Days since Nov 8th (last month)", ylab="New Cases", main="London Future Forecasting - HoltWinters")

southEastTs.forecast.future = forecast:::forecast.HoltWinters(southEastTs.forecast, h=7)
plot(southEastTs.forecast.future, xlab="Days since Nov 8th (last month)", ylab="New Cases", main="South East Future Forecasting - HoltWinters")




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




