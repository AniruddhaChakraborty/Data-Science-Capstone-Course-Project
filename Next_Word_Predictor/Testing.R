## Evaluates Interpolation vs Backoff Algorithm on Perplexity,Accuracy and Time Complexity
library(data.table)
library(tm)
library(stringr)
library(dplyr)

train<-readRDS("train.rds")
test<-readRDS("test.rds")

set.seed(111)
## Pick 1000 random lines from both train and test
train<-train[sample(length(train),1000)]
test<-test[sample(length(test),1000)]

##Clean text

## Remove non-graphical characters
train=str_replace_all(train,"[^[:graph:]]", " ") 
test=str_replace_all(test,"[^[:graph:]]", " ") 

train <- sapply(train, function(x) iconv(enc2utf8(x), sub = "byte"))
test <- sapply(test, function(x) iconv(enc2utf8(x), sub = "byte"))

## Remove numbers,punctuation and convert to lowecase
train<- str_trim(tolower(removeNumbers(removePunctuation(train))))
test<- str_trim(tolower(removeNumbers(removePunctuation(test))))

## Remove Profanity words
profanity = read.csv("profanity_en.txt",header=FALSE, stringsAsFactors=FALSE)
profanity <- profanity$V1
train<-str_trim(removeWords(train,profanity))
test<-str_trim(removeWords(test,profanity))

set.seed(400)
## Pick substrings of size - 3,4,5,6 from the lines of text
len=sample(3:6,1000,replace=TRUE,prob=c(.25,.25,.25,.25))

for(i in 1:1000){
        start1=sample(1:(length(strsplit(train[i], " ")[[1]])-len[i]+1),1)
        start2=sample(1:(length(strsplit(test[i], " ")[[1]])-len[i]+1),1)
        
        train[i]<-word(train[i], start = start1, end = start1+len[i]-1)
        test[i]<-word(test[i], start = start2, end = start2+len[i]-1)
}

## Remove NAs
train<-train[!is.na(train)]
test<-test[!is.na(test)]

TrainResults<-data.frame()
TestResults<-data.frame()

## Separate the last word from each substring for both train and test sets
for (i in 1:length(train)){
        l=length(strsplit(train[i], " ")[[1]])
        TrainResults<-rbind(TrainResults,data.frame(InputString=word(train[i],1,l-1),Actual=word(train[i],l)))
}
for (i in 1:length(test)){
        l=length(strsplit(test[i], " ")[[1]])
        TestResults<-rbind(TestResults,data.frame(InputString=word(test[i],1,l-1),Actual=word(test[i],l)))
}  

## Remove NAs
TrainResults=na.omit(TrainResults)
TestResults=na.omit(TestResults)


## Get Predictions from Interpolation and back-off models

source("/Next_Word_Predictor/PredictionAlgorithm_Interpolation_datatable.R")
source("/Next_Word_Predictor/PredictionAlgorithm_BackoffAlgorithm.R")


TrainResults$Predicted_Interpolation<-c()
TrainResults$Correct_Interpolation<-c()
TrainResults$InTop10_Interpolation<-c()
TrainResults$InWordCloud_Interpolation<-c()
TrainResults$Runtime_Interpolation<-c()

TrainResults$Predicted_Backoff<-c()
TrainResults$Correct_Backoff<-c()
TrainResults$InTop10_Backoff<-c()
TrainResults$InWordCloud_Backoff<-c()
TrainResults$Runtime_Backoff<-c()
for (i in 1:nrow(TrainResults)){
        
        Runtime_Interpolation=system.time(result1<-data.table(NextWordPredictor(TrainResults[i,1])))[1]
        Runtime_Backoff=system.time(result2<-data.table(WordPredictor(TrainResults[i,1])))[1]

        TrainResults$Predicted_Interpolation[i]<-result1[1,1]
        TrainResults$Correct_Interpolation[i]<-as.character(TrainResults$Actual[i])==as.character(result1[1,1])
        if(nrow(result1)>=10)
                TrainResults$InTop10_Interpolation[i]<-TrainResults$Actual[i] %in% result1$Prediction[1:10]
        else
                TrainResults$InTop10_Interpolation[i]<-TrainResults$Actual[i] %in% result1$Prediction
        TrainResults$InWordCloud_Interpolation[i]<-TrainResults$Actual[i] %in% result1$Prediction
        TrainResults$Runtime_Interpolation[i]<-Runtime_Interpolation
        TrainResults$Predicted_Backoff[i]<-result2[1,1]
        TrainResults$Correct_Backoff[i]<-as.character(TrainResults$Actual[i])==as.character(result2[1,1])
        if(nrow(result2)>=10)
                TrainResults$InTop10_Backoff[i]<-TrainResults$Actual[i] %in% result2$Prediction[1:10]
        else
                TrainResults$InTop10_Backoff[i]<-TrainResults$Actual[i] %in% result2$Prediction  
        TrainResults$InWordCloud_Backoff[i]<-TrainResults$Actual[i] %in% result2$Prediction
        TrainResults$Runtime_Backoff[i]<-Runtime_Backoff
}

## Store as TrainResults.csv for Analysis
fwrite(TrainResults, file ="TrainResults.csv")
##write.csv(TrainResults,"TrainResults.csv",row.names = FALSE)

TestResults$Predicted_Interpolation<-c()
TestResults$Correct_Interpolation<-c()
TestResults$InTop10_Interpolation<-c()
TestResults$InWordCloud_Interpolation<-c()
TestResults$Runtime_Interpolation<-c()

TestResults$Predicted_Backoff<-c()
TestResults$Correct_Backoff<-c()
TestResults$InTop10_Backoff<-c()
TestResults$InWordCloud_Backoff<-c()
TestResults$Runtime_Backoff<-c()
for (i in 1:nrow(TestResults)){
        Runtime_Interpolation=system.time(result1<-data.table(NextWordPredictor(TestResults[i,1])))[1]
        Runtime_Backoff=system.time(result2<-data.table(WordPredictor(TestResults[i,1])))[1]
        
        TestResults$Predicted_Interpolation[i]<-result1[1,1]
        TestResults$Correct_Interpolation[i]<-as.character(TestResults$Actual[i])==as.character(result1[1,1])
        if(nrow(result1)>=10)
                TestResults$InTop10_Interpolation[i]<-TestResults$Actual[i] %in% result1$Prediction[1:10]
        else
                TestResults$InTop10_Interpolation[i]<-TestResults$Actual[i] %in% result1$Prediction
        TestResults$InWordCloud_Interpolation[i]<-TestResults$Actual[i] %in% result1$Prediction
        TestResults$Runtime_Interpolation[i]<-Runtime_Interpolation
        TestResults$Predicted_Backoff[i]<-result2[1,1]
        TestResults$Correct_Backoff[i]<-as.character(TestResults$Actual[i])==as.character(result2[1,1])
        if(nrow(result2)>=10)
                TestResults$InTop10_Backoff[i]<-TestResults$Actual[i] %in% result2$Prediction[1:10]
        else
                TestResults$InTop10_Backoff[i]<-TestResults$Actual[i] %in% result2$Prediction   
        TestResults$InWordCloud_Backoff[i]<-TestResults$Actual[i] %in% result2$Prediction
        TestResults$Runtime_Backoff[i]<-Runtime_Backoff
}

## Store as TestResults.csv for Analysis
fwrite(TestResults, file ="TestResults.csv")
##write.csv(TestResults,"TestResults.csv",row.names = FALSE)

## Generate Statistics for Perplexity and Accuracy
TrainResults<-TrainResults[,-c(1,2,3,8)]
TestResults<-TestResults[,-c(1,2,3,8)]

## Perplexity
TrainResults$Correct_Interpolation<-round(mean(TrainResults$Correct_Interpolation)*100,2)
TrainResults$InTop10_Interpolation<-round(mean(TrainResults$InTop10_Interpolation)*100,2)
TrainResults$InWordCloud_Interpolation<-round(mean(TrainResults$InWordCloud_Interpolation)*100,2)
TrainResults$Runtime_Interpolation<-round(mean(TrainResults$Runtime_Interpolation),2)
TrainResults$Correct_Backoff<-round(mean(TrainResults$Correct_Backoff)*100,2)
TrainResults$InTop10_Backoff<-round(mean(TrainResults$InTop10_Backoff)*100,2)
TrainResults$InWordCloud_Backoff<-round(mean(TrainResults$InWordCloud_Backoff)*100,2)
TrainResults$Runtime_Backoff<-round(mean(TrainResults$Runtime_Backoff),2)
TrainResults<-unique(TrainResults)

## Accuracy
TestResults$Correct_Interpolation<-round(mean(TestResults$Correct_Interpolation)*100,2)
TestResults$InTop10_Interpolation<-round(mean(TestResults$InTop10_Interpolation)*100,2)
TestResults$InWordCloud_Interpolation<-round(mean(TestResults$InWordCloud_Interpolation)*100,2)
TestResults$Runtime_Interpolation<-round(mean(TestResults$Runtime_Interpolation),2)
TestResults$Correct_Backoff<-round(mean(TestResults$Correct_Backoff)*100,2)
TestResults$InTop10_Backoff<-round(mean(TestResults$InTop10_Backoff)*100,2)
TestResults$InWordCloud_Backoff<-round(mean(TestResults$InWordCloud_Backoff)*100,2)
TestResults$Runtime_Backoff<-round(mean(TestResults$Runtime_Backoff),2)
TestResults<-unique(TestResults)

## Combine and display
Results<-rbind(TrainResults,TestResults)
row.names(Results)<-c("Training Accuracy (Perplexity)","Testing Accuracy")
Results

## Save as Results.csv
write.csv(Results,"Results.csv",row.names = TRUE)

                                    
