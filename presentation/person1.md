# Slide 5: Accuracy depends on the random start

This chart shows how well each of our ten networks predicted the test data. The test data contains 40 examples that the networks did not train on. Every run used the same data and the same network setup. We only changed the random seed, which changes the network’s starting point.

The lowest test accuracy was 65%, and the highest was 90%. That is a difference of 25 percentage points, even though we used the same setup. The average test accuracy was 72.25%. We would report that average and the range, instead of only showing our best result. Our main lesson is that one great run does not tell the whole story.
