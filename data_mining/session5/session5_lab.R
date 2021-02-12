library("fpc")

something = iris[,1:4]

dbscanOut = dbscan(iris[,1:4], eps=0.42)
table(dbscanOut$cluster, iris$Species)

plotcluster(iris[,1:4], dbscanOut$cluster)
plot(dbscanOut, iris[,1:4])

data("multishapes", package="factoextra")
dataToCluster = multishapes[, 1:2]
plot(dataToCluster[,1], dataToCluster[,2])