library("adabag")

# Adaboosting theory
weights = rep(0.1,10)

# Epsiolon is the error rate, 2 errors in 10 classifications
epsilon = ((0.1+0.1)/1)

# Alpha is effectiveness of classification
alpha = 0.5 * log((1-epsilon)/epsilon)

# Adjusting weights
weights.correct = 0.1 * exp(-alpha)

weights.incorrect = 0.1 * exp(alpha)

weights.correct.new = weights.correct / (weights.correct*8 + weights.incorrect*2)

weights.incorrect.new = weights.incorrect / (weights.correct*8 + weights.incorrect*2)

# Adaboosting library 

adaboost.result = boosting(Species~., data=iris, mfinal=50)

adaboost.result$weights
adaboost.result$tree[[1]]
adaboost.result$tree[[2]]
adaboost.result$importance