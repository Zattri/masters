library("FSelector")
library("rpart")
library("rpart.plot")

contact = read.csv("contact.csv")
infogain = information.gain(contactLenses~., contact)
infogain

weather = read.csv("weather.csv")
weather

decisionTree = rpart(play~., method = "class", control = rpart.control(minsplit = 1), data=weather)
prp(decisionTree, main="Decision Tree", box.palette = "auto", faclen = 0)


decisionTree.infoGain = 
  rpart(play~., method = "class", control = rpart.control(minsplit = 1), parms= list(split = "information"), data=weather)

prp(decisionTree.infoGain, main="Decision Tree using Information Gain", box.palette = "auto", faclen = 0)