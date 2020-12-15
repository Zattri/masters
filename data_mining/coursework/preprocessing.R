setwd("../Desktop/masters/data_mining/coursework")

dataset = read.csv("regional_covid_data.csv")
head(dataset)
str(dataset)
dataset$areaName

nullRemoved = dataset[rowSums(is.na(dataset)) == 0,]

# Needs to be fixed after here
selectedDates = ifelse((nullRemoved$date >= as.Date('01/09/2020', "%d/%m/%Y")), nullRemoved$date, NA)
str(selectedDates)
selectedDates[-1]
thing = selectedDates[is.na(selectedDates) == 0]