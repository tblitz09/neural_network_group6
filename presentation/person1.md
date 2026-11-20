# Slide 5: Accuracy depends on the random start

This chart shows how well each of our ten networks predicted the test data. The test data contains 40 examples that the networks did not train on. Every run used the same data and the same network setup. We only changed the random seed, which changes the network’s starting point.

The lowest test accuracy was 65%, and the highest was 90%. That is a difference of 25 percentage points, even though we used the same setup. The average test accuracy was 72.25%. We would report that average and the range, instead of only showing our best result. Our main lesson is that one great run does not tell the whole story.


# Slide 6: Tomorrow - mostly agreement, wide variation

The average score for the price going up was about 31%. However, the individual scores ranged from about half a percent to 73%. That is a big difference for networks using the same data. It shows that changing the starting point can change the prediction quite a lot.

Nine networks voting the same way does not mean we are 90% sure they are right. These are model predictions, and we do not know tomorrow’s actual result yet. The Bank should report that most networks predict no rise, while clearly saying that the forecast is uncertain. Basically, the networks mostly agree, but we should not let them write a very confident press release.