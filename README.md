# Data-Science-Capstone-Course-Project

# [Next Word Predictor Shiny Application link.](https://aniruddhachakraborty.shinyapps.io/Shiny_App-Next_Word_Predictor/)

  

# [Link to the Rpubs Reproducible Pitch presentation on the Next Word Predictor App.](http://rpubs.com/AniruddhaChakraborty/301943)

  

# [Link to the ui.R and server.R files.](https://github.com/AniruddhaChakraborty/Data-Science-Capstone-Course-Project/tree/master/Shiny_App-Next_Word_Predictor)

  

# [Link to the source code of n-gram Language model (ngrams.R) and Interpolation Prediction Algorithm (PredictionAlgorithm_Interpolation_datatable.R).](https://github.com/AniruddhaChakraborty/Data-Science-Capstone-Course-Project/tree/master/Next_Word_Predictor)

## Following instructions have been given for the assignment -

The goal of this exercise is to create a product to highlight the prediction algorithm that you have built and to provide an interface that can be accessed by others. For this project you must submit:

* A Shiny app that takes as input a phrase (multiple words) in a text box input and outputs a prediction of the next word.
* A slide deck consisting of no more than 5 slides created with R Studio Presenter (https://support.rstudio.com/hc/en-us/articles/200486468-Authoring-R-Presentations) pitching your algorithm and app as if you were presenting to your boss or an investor.

#  My Shiny Application - [The Next Word Predictor App](https://aniruddhachakraborty.shinyapps.io/Shiny_App-Next_Word_Predictor/)

## This Shiny Application developed as a part of Data Science Capstone Course Project, on Next Word Predictor has the following main features : 

- **Next Word Predictor** allows users to enter a phrase and the App returns the predicted next word with the help of n-grams Language model and Interpolation Algorithm.

- **Top 10 Next Word Predictions** displays the Top 10 words as a bar chart, returned by the Prediction Algorithm (n-grams Language model and Interpolation Algorithm) along with their Interpolated Probabilities.

- **Word Cloud of Next Word Predictions** displays the Word Cloud of predictions returned by the Algorithm. 

- **Testing and Accuracy :** The Word Cloud of Next Word Predictions has an **Accuracy of about 61% on a Train Set and 50% on a Test Set**. The Top 10 Next Word Predictor has an **Accuracy of 37.6% on a Train Set and 30% on a Test Set**. The Next Word Predictor has an **Accuracy of 17.6% on a Train Set and 11.1% on a Test Set.** 

- **ngram Package and data.table :** The ngram package has been used for fast n-gram tokenization. All n-grams built were then consolidated into one corpus and incorporated in the Next word prediction - Interpolation algorithm. **The n-gram corpus was stored and indexed using data.table leading to faster runtimes. Average run time for the Train Set is 0.28s and that of Test set is 0.2s**. [Refer to Results.csv in this Github Repository.](https://github.com/AniruddhaChakraborty/Data-Science-Capstone-Course-Project). 