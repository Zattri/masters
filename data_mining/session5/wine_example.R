library('fpc')
wine <- read.csv('wine.csv', header=FALSE)
colnames(wine) <- c('Type', 'Alcohol', 'Malic', 'Ash',
                    'Alcalinity', 'Magnesium', 'Phenols',
                    'Flavanoids', 'Nonflavanoids',
                    'Proanthocyanins', 'Color', 'Hue',
                    'Dilution', 'Proline')
head(wine,10)
wine = wine[ , colSums(is.na(wine)) == 0]
head(wine,10)
str(wine)

# To standarize the variables
wine.stand <- scale(wine[-1])  

# Determine number of clusters 
wss <- (nrow(wine.stand)-1)*sum(apply(wine.stand,2,var)) 
for (i in 2:dim(wine.stand)[2]) { 
  wss[i] <- sum(kmeans(wine.stand, centers = i)$withinss) 
}  

# Plot the clusters 
plot(1:dim(wine.stand)[2], wss, type = "b", xlab = "Number of Clusters", ylab = "Within groups sum of squares")

# K-Means
k.means.fit <- kmeans(wine.stand, 3) # k = 3
k.means.fit

# Clusters:
k.means.fit$cluster

# Cluster size:
k.means.fit$size

# Compute cluster stats
wine2 <- as.numeric(wine[,1])
km_stats <- cluster.stats(dist(wine.stand),  wine2, k.means.fit$cluster)

plotcluster(wine.stand, k.means.fit$cluster)

#Hierarchical clustering:
d <- dist(wine.stand, method = "euclidean")
H.fit <- hclust(d, method="centroid")
plot(H.fit) # display dendogram
groups <- cutree(H.fit, k=3) # cut tree into 3 clusters

# draw dendogram with red borders around the 3 clusters
rect.hclust(H.fit, k=3, border="red") 
km_stats2 <- cluster.stats(dist(wine.stand),  wine2, groups)

#DBSCAN clustering:
dbscanOutput <- dbscan(wine.stand, eps=2.1, MinPts = 3)
table(dbscanOutput$cluster, wine2)
plotcluster(wine.stand, dbscanOutput$cluster, col=c(1,2,3,6,7))
