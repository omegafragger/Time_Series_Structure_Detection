# Time_Series_Structure_Detection
Unsupervised approach for automated structure detection in any given time-series

Although an economic time-series apparently looks like a random sequence of data points, there exists certain regularity
in the functional behavior of the series. The project contains an approach to identify the regularly occurring structures
in a time-series with an aim to describe the series as a specific sequence of such structures for various applications.
A sample application is the prediction of the most probable structure with its expected duration, and the sequence of
time-series values lying on the forecasted structure. Representation of a time-series by regularly occurring structures
is performed through three main steps:
i) segmentation of the time-series into time-blocks of non-uniform length
ii) clustering of the generated segments to identify the recurrent patterns
iii) representing the sequence of regular patterns using a specially designed automaton.

The automaton is used here to both encode the sequence of structures representing the time-series and also to act as an
inference engine to stochastic forecasting about the time-series.
Extensive experiments are also included to demonstrate the performance of the proposed technique in structure prediction.

In order to reproduce the results, just follow the instructions provided in the individual folders.
