# LAB 1 ---------------------------------------------------------
hw = read.csv("HW.csv")

# Take random seeds from the dataset
seed1 = hw[3,]
seed2 = hw[6,]

dist = round(dist(hw), digits=2)
dist

cent_c1 = colMeans(hw[c(1,2,5,9,10),])
cent_c2 = colMeans(hw[c(4,6,7,8),])

cent_c1
cent_c2

hw_iter1 = rbind(hw, cent_c1, cent_c2)
hw_iter1

dist = round(dist(hw_iter1), digits=2)
dist

cent_c3 = colMeans(hw[c(1,2,5,9,10),])
cent_c4 = colMeans(hw[c(4,6,7,8),])

# Method had converged, centroids have now changed after first iteration


# LAB 2 ---------------------------------------------------------

# Default kmeans
hw_cluster1 = kmeans(hw, 2)
hw_cluster1

# Specified centroids with Lloyd algorithm
hw_cluster2 = kmeans(hw, centers=hw[c(3,6),], algorithm="Lloyd")
hw_cluster2
# Access the component of an object with $
hw_cluster2$size

# Cluster 1 plot
plot(hw, col=hw_cluster1$cluster+1)
points(hw_cluster1$centers, col=2:3,pch=15)

# Cluster 2 plot
plot(hw, col=hw_cluster2$cluster+1)
points(hw_cluster2$centers, col=2:3,pch=15)

# Investigating 3 clusters
hw_cluster3 = kmeans(hw, 3)
plot(hw, col=hw_cluster3$cluster+1)
points(hw_cluster3$centers, col=2:4,pch=15)

# Investigating 5 clusters
hw_cluster4 = kmeans(hw, 5)
plot(hw, col=hw_cluster4$cluster+1)
points(hw_cluster4$centers, col=2:6,pch=15)


# Hierarchical Cluster - Different distance measures
hw_hierClust1 = hclust(dist(hw), method="centroid")
plot(hw_hierClust1, hang=-1)

hw_hierClust2 = hclust(dist(hw), method="single")
plot(hw_hierClust2, hang=-1)

hw_hierClust3 = hclust(dist(hw), method="complete")
plot(hw_hierClust3, hang=-1)

hw_hierClust4 = hclust(dist(hw), method="average")
plot(hw_hierClust4, hang=-1)
# Drawing a box border around a number of clusters
rect.hclust(hw_hierClust4,k=3,border="red")

