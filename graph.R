# Replace mydata and outcome with your own names

# Clean up workspace
rm(list = ls()) # clear variables from previous work.
graphics.off() # clear out all old plots
cat("\014") # clear the console

library(tidyverse)
library(neuralnet)

# Read the CSV file for your group
mydata <- read_csv("files/neuralNetworks/data/nn_groupN_something.csv")
head(mydata)       # what do the first rows look like?
summary(mydata)    # look at the RANGE of each variable!

# Step 1: what is the baseline to beat?
mean(mydata$outcome)   # the proportion of 1s (edit outcome to match)

# Step 2: scale every input (but not the 0/1 outcome) to 0 to 1
scaled <- mydata %>% mutate(across(-outcome, normalize))

# Step 3: an honest split - 75% of the rows for training
set.seed(301)
train_rows <- sample(nrow(scaled), round(0.75 * nrow(scaled)))
train <- scaled[train_rows, ]
test  <- scaled[-train_rows, ]

# Step 4: train the network
fit <- neuralnet(outcome ~ ., data = train, hidden = 3,
                 linear.output = FALSE, stepmax = 1e5)

# Step 5: draw it
plot(fit, rep = "best")

# Step 6: predict for the test rows (a probability between 0 and 1)
prob      <- predict(fit, test)[, 1]
predicted <- ifelse(prob > 0.5, 1, 0)

# Step 7: which mistakes does it make?
table(actual = test$outcome, predicted)   # the confusion matrix
mean(predicted == test$outcome)           # the test accuracy

# ... and how does that compare with the TRAINING accuracy?
train_pred <- ifelse(predict(fit, train)[, 1] > 0.5, 1, 0)
mean(train_pred == train$outcome)

# Predict for new cases: scale them like the ORIGINAL data first!
new_scaled <- scale_like(new_cases, mydata)
predict(fit, new_scaled)