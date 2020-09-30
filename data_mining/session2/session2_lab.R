weather = read.csv("weather.csv")
summary(weather)

# Getting the first and last instances from a data frame
head(weather, 2)
tail(weather, 2)

str(weather)

class(weather)

# Sub-set rows out of the dataset
r2_3 = weather[2:3, ]
r2_3

# Sub-set columns out of the dataset
c4_5 = weather[, 4:5]
c4_5
