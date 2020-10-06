library("arules")

weatherData = read.csv("weather.csv")
rules = apriori(weatherData)
rules = apriori(weatherData, parameter=list(supp=0.3, conf=0.3))
rules = apriori(weatherData, parameter=list(supp=0.3, conf=0.3, minlen=2))
inspect(rules)

plot(rules) #requires arulesViz - buggy package, don't use
