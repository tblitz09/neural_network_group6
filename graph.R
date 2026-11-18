# Replace mydata and price_up with your own names

# Clean up workspace
rm(list = ls()) # clear variables from previous work.
graphics.off() # clear out all old plots
cat("\014") # clear the console

library(tidyverse)
library(neuralnet)

# Read the CSV file for your group
mydata <- read_csv("nn_group6_llama_stocks.csv")
head(mydata)       # what do the first rows look like?
summary(mydata)    # look at the RANGE of each variable!

# Step 1: what is the baseline to beat?
mean(mydata$price_up)   # the proportion of 1s (edit price_up to match)

# Step 2: scale every input (but not the 0/1 price_up) to 0 to 1
normalize <- function(x) {
  (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}
scaled <- mydata %>% mutate(across(-price_up, normalize))

# Step 3: an honest split - 75% of the rows for training
set.seed(301)
train_rows <- sample(nrow(scaled), round(0.75 * nrow(scaled)))
train <- scaled[train_rows, ]
test  <- scaled[-train_rows, ]

# Step 4: train the network
fit <- neuralnet(price_up ~ ., data = train, hidden = 3,
                 linear.output = FALSE, stepmax = 1e5)

# Step 5: draw it
plot(fit, rep = "best")

# Step 6: predict for the test rows (a probability between 0 and 1)
prob      <- predict(fit, test)[, 1]
predicted <- ifelse(prob > 0.5, 1, 0)

# Step 7: which mistakes does it make?
table(actual = test$price_up, predicted)   # the confusion matrix
mean(predicted == test$price_up)           # the test accuracy

# ... and how does that compare with the TRAINING accuracy?
train_pred <- ifelse(predict(fit, train)[, 1] > 0.5, 1, 0)
mean(train_pred == train$price_up)

# Predict for new cases: scale them like the ORIGINAL data first!
new_scaled <- scale_like(new_cases, mydata)
predict(fit, new_scaled)

# Group 6 specific code
llama <- read_csv("nn_group6_llama_stocks.csv")
tomorrow <- tibble(hay_price = 6.5, llama_posts = 260, spit_incidents = 4,
                   fog_level = 0.4, head_llama_mood = 3)
scaled <- llama %>% mutate(across(-price_up, normalize))
set.seed(301)                                   # this seed fixes the SPLIT
rows  <- sample(nrow(scaled), 120)
train <- scaled[rows, ];  test <- scaled[-rows, ]
tomorrow_scaled <- scale_like(tomorrow, llama)

runs <- map_dfr(1:10, \(s) {
  set.seed(s)                                   # this seed fixes the START
  fit <- neuralnet(price_up ~ ., data = train, hidden = 3,
                   linear.output = FALSE, stepmax = 1e5)
  tibble(seed      = s,
         train_err = fit$result.matrix["error", 1],
         test_acc  = mean((predict(fit, test)[, 1] > 0.5) == test$price_up),
         tomorrow  = predict(fit, tomorrow_scaled)[1, 1])                       # P(price goes up tomorrow)
})
runs
ggplot(runs, aes(seed, test_acc)) + geom_col()
