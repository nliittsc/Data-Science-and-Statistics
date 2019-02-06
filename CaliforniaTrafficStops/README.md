This folder contains my analysis of the California Traffic Stop data of the Stanford Open Policing Project.

# Goal: Attempt to determine if there is racial or systemic bias in the way California Highway Patrol conducts its traffic stops.
To that end, I will be following Pierson et al. in attempting to uncover this by looking at the outcomes of individual traffic stops
and analyze the associations of race on outcome. The outcomes of interest are: Whether a person was searched, whether a person was arrested,
and whether a search led to finding contraband (a "hit"). 

# Results: Pending. `countyAnalysis.ipynb` indicates that there may be a potentially spurious relationship between the search rate and
the contraband hit rate, at the county level. Further analysis is needed. Treat `countyAnalysis.ipynb` as exploratory.

Stanford's (working) technical paper has the following citation:
E. Pierson, C. Simoiu, J. Overgoor, S. Corbett-Davies, V. Ramachandran, C. Phillips, S. Goel. (2017) 
“A large-scale analysis of racial disparities in police stops across the United States”.

I am not affiliated with Stanford in any way.

This README will be updated as I post my results,
and this folder will contain much of what I have decided to do. Notebooks with actual analysis will be kept in this folder, while the 
more technical or less interesting aspects of the analysis will be delegated to the subfolders. I'll provide descriptions of each item and
eventually update this page with a summary of final conclusions and my methods. Since the data is open, the code and analysis here are
neccesarily open. But if you decide to use my code, or my analytical results, please give the following citation *in addition to the above 
citation*:

N. Liittschwager, California Traffic Stops, (2013), GitHub repository,
https://github.com/nliittsc/Data-Science-and-Statistics

Below is a brief description of the folders and notebooks:

`Data Processing and Sampling` contains notebooks and scripts on what I did to clean, aggregate, condense, and sample from the
original data set, which may be obtained here: https://openpolicing.stanford.edu/data/

`Data` is just a collection of the aggregated forms of the data.

`Imputation` had some attempts at imputation, until I realized that it doesn't work and shouldn't be done, since the variable
I wanted to impute turned out to be a response variable that had a non-random missing mechanism. I've left the folder for posterity, but
I would not use it for anything.

`Models` may contain scripts of my final modeling attempts, for reproducibility.
Likely will remain empty until I am completely done with my analysis.

`Visualization` contains some scripts and notebooks for some visuals I did.

And finally, this folder will contain the finished jupyter notebooks that attempt to tell a story with the data, and drive us to our 
final results. The first in the series is `countyAnalysis.ipynb`. There are currently plans for at least two more extensive notebooks,
one which contains a more indepth county-level analysis of the data, and one that tries to procure a full model for the data at the individual
level. 

# To do:
1) More formal county level analysis and estimates of search/arrest/hit rates on race.
2) A plausible model for the data that accounts for intra-county correlations and estimates the associations of race with the 
search/arrest/hit rates.
