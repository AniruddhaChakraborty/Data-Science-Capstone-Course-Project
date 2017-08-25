### Application designed and developed by - Aniruddha Chakraborty

### User Guide and Main Features -

##### This Shiny Application developed as a part of Data Science Capstone Course Project, on Next Word Predictor has the following main features : 

- **Next Word Predictor** allows users to enter a phrase and the App returns the predicted next word with the help of n-grams Language model and Interpolation Algorithm. [Refer to this Github Repository for the source code of n-gram Language model (ngrams.R) and Interpolation Algorithm (PredictionAlgorithm_Interpolation_datatable.R).](https://github.com/AniruddhaChakraborty/Data-Science-Capstone-Course-Project/tree/master/Next_Word_Predictor) 

- **Top 10 Next Word Predictions** displays the Top 10 words as a bar chart, returned by the Prediction Algorithm (n-grams Language model and Interpolation Algorithm) along with their Interpolated Probabilities.

- **Word Cloud of Next Word Predictions** displays the Word Cloud of predictions returned by the Algorithm. 

- **Testing and Accuracy :** The Word Cloud of Next Word Predictions has an **Accuracy of about 61% on a Train Set and 50% on a Test Set**. The Top 10 Next Word Predictor has an **Accuracy of 37.6% on a Train Set and 30% on a Test Set**. The Next Word Predictor has an **Accuracy of 17.6% on a Train Set and 11.1% on a Test Set.** [Refer to this Github Repository for the source code used to test the performance of Interpolation Algorithm against Backoff (Testing.R), along with the generated results (Results.csv).](https://github.com/AniruddhaChakraborty/Data-Science-Capstone-Course-Project/tree/master/Next_Word_Predictor)

- **ngram Package and data.table :** The ngram package has been used for fast n-gram tokenization. All n-grams built were then consolidated into one corpus and incorporated in the Next word prediction - Interpolation algorithm. **The n-gram corpus was stored and indexed using data.table leading to faster runtimes. Average run time for the Train Set is 0.28s and that of Test set is 0.2s**. [Refer to Results.csv in this Github Repository.](https://github.com/AniruddhaChakraborty/Data-Science-Capstone-Course-Project). 

### Resources -

##### [1. Link to the Rpubs Reproducible Pitch presentation on the Next Word Predictor App.](http://rpubs.com/AniruddhaChakraborty/301943)

##### [2. Refer to page numbers 58 and 59 of this lecture on **Language Modeling**, to know about the **Simple/Linear Interpolation algorithm**, which has been used in this App.](https://web.stanford.edu/class/cs124/lec/languagemodeling.pdf)

##### [3. Link to the source code of n-gram Language model (ngrams.R) and Interpolation Prediction Algorithm (PredictionAlgorithm_Interpolation_datatable.R).](https://github.com/AniruddhaChakraborty/Data-Science-Capstone-Course-Project/tree/master/Next_Word_Predictor)

##### [4. Link to the source code of ui.R and server.R files.](https://github.com/AniruddhaChakraborty/Data-Science-Capstone-Course-Project/tree/master/Shiny_App-Next_Word_Predictor)





