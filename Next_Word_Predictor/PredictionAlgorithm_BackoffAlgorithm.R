library(tm)
library(stringr)
library(data.table)
library(dplyr)
## Load n-grams corpus
DT=as.data.table(readRDS("ngrams_6_1.1perc_minfreq2.rds"))

##inputtext<-"When you were in Holland you were like 1 inch away from me but you hadn't time to take a"

## n-grams indexing
n_start<-c(55861,14260,3191,715,1)
n_end<-c(126563,55860,14259,3190,714)

WordPredictor <- function(sentence) {
        if (is.null(str_trim(sentence)) ||str_trim(sentence)  == ''){
                matches<-data.table(Prediction=c("the","to","and","a","of","i","in","for","is","that"),Probability=c(35874,20663,18236,18182,15085,12626,12322,8427,7933,7833))
                matches<-matches[,.(Prediction,Probability=round(Probability*100/sum(Probability),4))]
                return (matches)
        }
        ## Format user input
        text<- str_trim(removeNumbers(removePunctuation(tolower(sentence))))
        text<-strsplit(text, " ")[[1]]
        len = length(text) 
        if(len >= 6) {
                text = paste(text[(len-4):len], collapse = ' ')    
        } else {
                text = paste(text[1:len], collapse = ' ')      
        }
        matches <- data.table()
        flag=0
        if(len>=6)
                len=5
        
        ## Implementation of Back Off Algorithm - Predict using hexagrams first, return high freuency words. If match is not found in hexagrams, then backoff to pentagrams and so on.
        for(c in len:1)
        {
                if(nrow(matches)>=1)
                      break
                
                text<-strsplit(text, " ")[[1]]
                text <- tail(text,c)
                text<-str_c(text,collapse=" ")
                
                ## To avoid the selection of the last word, space has been added to text.
                text <- paste0(str_trim(text)," ")
                
                ## Get the predicted word from each matched n-gram along with its Probability and n.
                temp<-data.table()
                temp<-DT[n_start[c]:n_end[c]]
                temp<-temp[grep(paste0('\\<',text), str_trim(ngrams)),.(Prediction=word(ngrams,c+1,c+1),Probability=freq)]
                matches<-rbind(matches,temp)
        }
        
                # No match so return some frequently ocurring unigrams
        if (nrow(matches)==0){
                flag=1
                matches<-data.table(Prediction=c("the","to","and","a","of","i","in","for","is","that"),Probability=c(35874,20663,18236,18182,15085,12626,12322,8427,7933,7833))
        }
        
        
        ## Prediction
        if(nrow(matches)>=1000)
                matches<-matches[1:1000]
        matches<-matches[,.(Prediction,Probability=round(Probability*100/sum(Probability),4))]
        matches
}

##result<-data.table(WordPredictor(inputtext))
##result
