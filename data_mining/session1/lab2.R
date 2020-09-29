iris = read.csv("iris.csv")

# Print dimensions of the data
dim(iris)

# Print a summary
summary(iris)

# Print column names
names(iris)

# Prints data types of each column
str(iris)

# Print first 10 rows
iris[1:10,]
# Print 4th row and 5th column
iris[4,5]

# Print columns and rows from vector
iris[c(10,20,30),c(3,5)]
iris[c(10,20,30),c("petal.length", "petal.width", "variety")]

# Print the mean and variance of a column
mean(iris$sepal.length)
var(iris$sepal.width)

# Analyse co-variance and correlation between two columns
cov(iris$sepal.length, iris$petal.length)
cor(iris$sepal.length, iris$petal.length)

cov(iris$petal.length, iris$petal.width)
cor(iris$petal.length, iris$petal.width)

# Histograph of a single column
hist(iris$sepal.length)
hist(iris$sepal.length, col="green", main="Iris Sepal Length Histogram", xlab="Sepal length")

# Pie chart
pie(table(iris$variety))
pie(table(iris[1:50,]$petal.length), main="Pie chart of petal length for Setosa")

#Bar plot with fancy colours
barplot(table(iris$sepal.length), xlab="Sepal length", ylab="Frequency", col=c(10, 11, 12, 13, 14, 15), main="Sepal length bar plot")

# Box plot
boxplot(sepal.length ~ variety, data = iris, col=c(150, 15, 300))

# Pairs plot
pairs(iris[,1:4], col=c(10,11,12,13,14,15))

# Save a plot to PDF
pdf("irisPlot.pdf")
pairs(iris[,1:4], col=c(10,11,12,13,14,15))
graphics.off()

