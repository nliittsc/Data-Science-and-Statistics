# Data-Science-and-Statistics
This repository is a collection of my projects pertaining to data science and statistics. It includes both statistical analyses of data using R and Python, as well as implementations of various algorithms. Presently, there is only one algorithm, which is a latent factor model for predicting amazon product ratings. In the future, I may (hopefully) add more implentations of various algorithms.

Here is a brief description of the folders/projects:

#### Algorithms
Any algorithms I develop or code up that are interesting or useful get placed here. This isn't my speciality by any means, so it will be pretty infrequently updated. Currently there is a Latent Factor Model used for rating prediction. A (sparse) matrix of items by users is fed to the model, where the ijth entry is the rating given to the i-th item by the j-th user. The model generates a linear predictor from the observed ratings, then estimates some unseen latent factors within the linear predictor by way of alternating least squares. Performance is fast, for very large sparse matrices. I would like to maybe write an algorithm to fit random effects models, but we'll see if that ever happens. 


#### California Traffic Stops
This folder contains my attempts at analyzing California Traffic Stop data, a subset of the data from https://openpolicing.stanford.edu. The California subset of the data consists of over 30 million traffic stops.
The analysis is ongoing, and I work on it when I have time or am not absorbed into other projects, so at times my progress has been slow.

#### Mortality Analysis
This is a simple, somewhat naive analysis of mortality data. It was one of my first data analysis projects I undertook on my own, without instruction from a course, so the analysis is rough, but relatively complete. It's up here mostly for completeness.

#### funStuff
This is just a folder of some stuff I did for fun. Perhaps I was curious about answering a question, and created a little simulation. There is currently not much content, just a little simulation that predicts the probability you fail a class by randomly guessing on every question, under a simple model that generates a classroom of students with normally distributed ability, calculates their respective scores, calculates your (random) score, then curves the grade. The probability of failing the class is a long-run proportion of times the random-guessing strategy fails. I like this little project a lot, but it could probably be improved.

### My Blog and LinkedIn
I write a blog that covers topics related to statistics and probability. It is an opinionated work in progress, but I want to include elements such as book reviews (I currently have one for Baby Rudin on there) and other fun questions like, what is the probability my friend has tuberculosis(TB) given her positive TB test? 

Blog: https://probabilitymeasure.blog/
LinkedIn: https://www.linkedin.com/in/nathan-liittschwager-ba60b4177/ 
