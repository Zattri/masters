library("randomForest")

set.seed(1234)

forest300 = randomForest(Species~., data=iris, ntree=300)
forest300

forest300.mtry1 = randomForest(Species~., data=iris, ntree=300, mtry=1)
forest300.mtry1

forest300.mtry3 = randomForest(Species~., data=iris, ntree=300, mtry=3)
forest300.mtry3

forest500 = randomForest(Species~., data=iris, ntree=300)
# Plot of the error rate
plot(forest500)

# Importance of each feature
importance(forest500)
# Visualised plot of importance
varImpPlot(forest500)