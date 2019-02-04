This directory contains scripts and notebooks on the preprocessing stages for the California Traffic Dataset, in both R and Python.

`stratified-Subsample.R` is a script that pulls a stratified sample from the California Traffic Stops Data. Its written so that it can easily be adapted to pull stratified subsamples with different sizes from  the main data. The resulting CSV is used in the following notebook `DataProcessing.ipynb`.

`stratified-subsample (1).R` is an updated version of the above script. It pulls a stratified subsample, as well as outputs an aggregated version of the *entire* California Traffic Stops data. It is the version that will be used in the traffic stop analysis at the county and individual level. 

`DataProcessing.ipynb` is a notebook that adds some exposition to adding county-level predictors to the extracted data from `stratified-Subsample.R`. It also creates an aggregated version of the data that is potentially easier to deal with. I may come back and adapt the aggregation process to the entire data set.
