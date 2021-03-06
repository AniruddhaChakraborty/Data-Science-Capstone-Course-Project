Reproducible Pitch Presentation on the Next Word Predictor Shiny Application
========================================================
author:Aniruddha Chakraborty 
date: 25-08-2017
autosize: true
[You can click on this link to refer to the Milestone Report, for the initial Exploratory Analysis. This was submitted earlier, in Week-2 of the Data Science Capstone Course. ](http://rpubs.com/AniruddhaChakraborty/299610)


User Guide and Main Features
========================================================
<small>
This Next Word Predictor Shiny Application has the following main features-
- **Next Word Predictor** allows users to enter a phrase and the App returns the predicted next word with the help of **n-grams Language model and Interpolation Algorithm.** 
- **Top 10 Next Word Predictions** displays the Top 10 words as a bar chart, returned by the Prediction Algorithm along with their Interpolated Probabilities.
- **Word Cloud of Next Word Predictions** displays the Word Cloud of predictions returned by the Algorithm. 
- **Simple/Linear Interpolation Algorithm** has been used in the prediction algorithm as it works better than the **Backoff model**.  
- **ngram Package and data.table :** The ngram package has been used for fast n-gram tokenization. All n-grams built were consolidated into one corpus and **the n-grams corpus (bigrams to hexagrams) was stored and indexed using data.table leading to faster runtimes.**
</small>
The Next Word Predictor App - Snapshot
========================================================
![The Next Word Predictor App - Snapshot](Next_Word_Predictor_App.png)
<h5>Resources :</h5>
<small>1. [Link to the Next Word Predictor Shiny Application.](https://aniruddhachakraborty.shinyapps.io/Shiny_App-Next_Word_Predictor/)  
2. [Link to the Github Repository containing all R codes including ui.R, server.R and Interpolation Prediction Algorithm.](https://github.com/AniruddhaChakraborty/Data-Science-Capstone-Course-Project/tree/master/Shiny_App-Next_Word_Predictor)  
</small>
Prediction Algorithm used - Simple/Linear Interpolation
========================================================
<small>
In **Backoff Algorithm**, we use the highest order matching n-gram to make the prediction. For eg., we use trigram if we have good evidence/probability. Otherwise, we **backoff to bigram**, and again in case of insufficient evidence, **we backoff to unigram**.[ Refer to this lecture about Text Prediction Algorithms.](https://web.stanford.edu/class/cs124/lec/languagemodeling.pdf)

In **Simple Interpolation algorithm**, we mix the n-grams by **calculating the wighted average of their probabilities.** The mathematical expression for Simple Interpolation of n-grams is -  
![Simple Interpolation Expression](SimpleInterpolationExpression.png)

Therefore, **Interpolation works better**. The λs for the algorithm were chosen to maximize the probability of held-out/validation data set. **The final values of λs used : λ1=.32(hexagrams), λ2=.26, λ3=.21, λ4=.14, λ5=.07 (bigrams)**.
</small>
Accuracy - Quantitatively summarizing the performance
========================================================
<small>
**Testing process :** The **en_US corpus** was divided into train and test sets in the ratio 70:30. After data cleaning and processing, 1000 random lines were read from both train and test data sets. Further, substrings of length 3,4,5 and 6 were drawn randomly from these 1000 lines. After leaving one word out from these substrings, they were given as inputs to the prediction algorithms - **Interpolation and Backoff.** Following are the results -  
![Testing Results - Snapshot](Results.png)  
Clearly, **the performance of Interpolation is better than backoff.** We can now Quantitatively summarize the performance of the **Interpolation Prediction Algorithm** -  
The Word Cloud of Next Word Predictions has an **Accuracy of about 61% on the Train Set and 50% on the Test Set**. The Top 10 Next Word Predictor has an **Accuracy of 37.6% on the Train Set and 30% on the Test Set**. The Next Word Predictor has an **Accuracy of 17.6% on the Train Set and 11.1% on the Test Set.** **Average run time for the Train Set is 0.28s and that of Test set is 0.2s.**
</small>

