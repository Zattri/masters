import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os

os.chdir("C:\\Users\\Zattri\\Desktop\\masters\\big_data\\week6")
df = pd.read_csv("daily_weather.csv")

cleanDf = df.dropna()
avgFilledDf = df.fillna(df.mean())


# Histogram
counts, bins = np.histogram(cleanDf["air_pressure_9am"])
plt.hist(bins[:-1], bins, weights=counts)


# Scatter plot
plt.scatter(cleanDf["air_temp_9am"], cleanDf["relative_humidity_9am"])
plt.xlabel("Air temp 9am")
plt.ylabel("Relative Humidity 9am")


# Singular boxplot
plt.boxplot(cleanDf["relative_humidity_9am"])


# Multiple box plots on the same chart
data = [cleanDf["relative_humidity_9am"], cleanDf["relative_humidity_3pm"]]
fig, ax = plt.subplots()
ax.boxplot(data)
plt.show()


# Histogram with bin count numbers above
counts, bins = np.histogram(avgFilledDf["air_temp_9am"])
arr = plt.hist(bins[:-1], bins, weights=counts)
for i in range(len(bins[:-1])):
    plt.text(arr[1][i],arr[0][i],str(arr[0][i]))
    
    
counts, bins = np.histogram(cleanDf["air_temp_9am"])
arr = plt.hist(bins[:-1], bins, weights=counts)
for i in range(len(bins[:-1])):
    plt.text(arr[1][i],arr[0][i],str(arr[0][i]))
    
# Correlation between columns
cleanDf.corr()
cleanDf["rain_accumulation_9am"].corr(cleanDf["rain_duration_9am"])