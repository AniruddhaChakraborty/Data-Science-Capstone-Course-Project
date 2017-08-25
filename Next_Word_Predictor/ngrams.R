## Load and partition the data into training and testing corpus in the ratio 70:30. Sample both datasets and save them in test.rds and train.rds files.

## For training dataset, create n-grams up to the order 6 and merge all of them in a single corpus. Return ngcorpus.rds file with n-grams corpus.

## Load and partition the data

Blogs <- readLines("final/en_US/en_US.blogs.txt",skipNul=TRUE,encoding="UTF-8")
## Opening news.text in binary mode as in default read mode, readLines was not able to read the whole file due to 'incomplete final line found by readLines' error
con=file("final/en_US/en_US.news.txt","rb")
News <- readLines(con,skipNul=TRUE,encoding="UTF-8")
close(con)
Twitter <- readLines("final/en_US/en_US.twitter.txt",skipNul=TRUE,encoding="UTF-8")

## Partition the Data
set.seed(1100)
inTrain1<-sample(1:length(Blogs),0.7*length(Blogs))
inTrain2<-sample(1:length(News),0.7*length(News))
inTrain3<-sample(1:length(Twitter),0.7*length(Twitter))

## Test Data
Blogs_Test<-Blogs[-inTrain1]
News_Test<-News[-inTrain2]
Twitter_Test<-Twitter[-inTrain3]

## Train Data
Blogs<-Blogs[inTrain1]
News<-News[inTrain2]
Twitter<-Twitter[inTrain3]

## Preprocess the Data

## 1. Sub-sample the datasets

## Sample n% of the lines using rbinom function  
n=.011
set.seed(2017)
Blogs_Sub=Blogs[which(as.logical(rbinom(length(Blogs),1,n)))]
News_Sub=News[which(as.logical(rbinom(length(News),1,n)))]
Twitter_Sub=Twitter[which(as.logical(rbinom(length(Twitter),1,n)))]

Blogs_Test_Sub=Blogs_Test[which(as.logical(rbinom(length(Blogs_Test),1,n)))]
News_Test_Sub=News_Test[which(as.logical(rbinom(length(News_Test),1,n)))]
Twitter_Test_Sub=Twitter_Test[which(as.logical(rbinom(length(Twitter_Test),1,n)))]

## Remove original datasets
rm(Blogs,News,Twitter,Blogs_Test,News_Test,Twitter_Test)

### 2. Corpus creation and tidying data

## Merge all the sources
enUS<-c(Blogs_Sub,News_Sub,Twitter_Sub)
enUS_Test<-c(Blogs_Test_Sub,News_Test_Sub,Twitter_Test_Sub)

## Write as rds files for use in evaluating Accuracy and Perplexity
saveRDS(enUS,"train.rds")
saveRDS(enUS_Test,"test.rds")

library(tm)
library(SnowballC)

## Create Corpus
corpus = Corpus(VectorSource(enUS),readerControl=list(reader=readPlain,language="en"))

## Remove sub-samples
rm(Blogs_Sub,News_Sub,Twitter_Sub,enUS,enUS_Test,Blogs_Test_Sub,News_Test_Sub,Twitter_Test_Sub)

## Remove non-ASCII to avoid invalid input error in tm_map function
corpus <- Corpus(VectorSource(sapply(corpus, function(row) iconv(row, "latin1", "ASCII", sub="")))) 

## Remove URLs
removeURL = function(x) gsub("http\\w+", "", x)
corpus = tm_map(corpus, content_transformer(removeURL))

## Remove Punctuations, Numbers and convert to lowercase
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, content_transformer(tolower))

## Remove Profanity words
profanity = read.csv("profanity_en.txt",header=FALSE, stringsAsFactors=FALSE)
profanity <- profanity$V1
corpus <- tm_map(corpus, removeWords, profanity)

## Finally remove whitespace
corpus<- tm_map(corpus, stripWhitespace)

## and for format to Plain Text
##corpus <- tm_map(corpus, PlainTextDocument)

## Exploratory Data Analysis : n-grams

library(ngram)
str <- concatenate(lapply(corpus,"[",1))

## Remove corpus
rm(corpus)

## string.summary (str)

## Analysis of Individual Words (Unigrams)
library(tidytext)
library(dplyr)
d<-data_frame(txt=str)

## Creating Word count table (Unigrams and their frequencies)
WordCount <- d %>%unnest_tokens(word,txt) %>%count(word, sort = TRUE) %>%ungroup()
WordCount=data.frame(ngrams=WordCount$word,freq=WordCount$n)

## Save unigrams as rds file
saveRDS(WordCount,"Unigrams_1.1perc.rds")

## Remove d
rm(d,WordCount)

## n-grams generation
Hexagrams<-ngram(str,n=6)
Pentagrams<-ngram(str,n=5)
Quadgrams<-ngram(str,n=4)
Trigrams<-ngram(str,n=3)
Bigrams<-ngram(str,n=2)
## Unigrams<-ngram(str,n=1)

## n-grams table generation
## UnigramsT<-get.phrasetable(Unigrams)
BigramsT<-get.phrasetable(Bigrams)
TrigramsT<-get.phrasetable(Trigrams)
QuadgramsT<-get.phrasetable(Quadgrams)
PentagramsT<-get.phrasetable(Pentagrams)
HexagramsT<-get.phrasetable(Hexagrams)

## Remove str
rm(str)

## Merge into one n-grams corpus and save to rds file
ngcorpus <- rbind(HexagramsT,PentagramsT,QuadgramsT,TrigramsT,BigramsT )

## Subset by frequency>1
ngcorpus=subset(ngcorpus,freq>1)

## Write to rds file
saveRDS(ngcorpus,"ngrams_6_1.1perc_minfreq2.rds")
