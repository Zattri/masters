# Creating vectors to add to a data frame
EUCountryNames = c("United Kingdom", "Germany","France","Italy")
EUPopulation = c(63843856, 82562004,64982894,61142221)

# Creating a data frame object and printing it out
EU = data.frame(EUCountryNames,EUPopulation)
EU

# Saving the data frame to file
save(EU, file="EUDataFrame.RData")
# Get the working directory
getwd()

# Remove the data frame
rm(EU)

# Load it in again, and magically assign it to the same variable?
load("EUDataFrame.RData")
EU

# Writing and reading files from CSV
write.csv(EU, "EUInfo.csv")
euDataCsv = read.csv("EUInfo.csv")
euDataCsv

# Writing and reading files from xlsx
write.xlsx(EU, "EUInfo.xlsx", sheetName="Sheet1")
euDataXlsx = read.xlsx("EUInfo.xlsx", sheetName="Sheet1")
euDataXlsx
