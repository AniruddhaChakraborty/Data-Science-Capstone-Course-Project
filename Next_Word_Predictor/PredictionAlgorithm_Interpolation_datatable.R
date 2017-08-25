library(data.table)
library(tm)
library(stringr)
library(dplyr)
## Load n-grams corpus
DT=as.data.table(readRDS("ngrams_6_1.1perc_minfreq2.rds"))

## Define lambdas for interpolation model
Lambda<-c(.07,.14,.21,.26,.32)

## n-grams indexing
n_start<-c(55861,14260,3191,715,1)
n_end<-c(126563,55860,14259,3190,714)

##inputtext<-"When you were in Holland you were like 1 inch away from me but you hadn't time to take a"

NextWordPredictor <- function(sentence) { 
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
        ## Find all possible matching n-grams starting from last 5 words, then last 4 words and so on.
        for(c in len:1)
        {
                ##if(nrow(matches)>=1000)
                  ##      break
                
                text<-strsplit(text, " ")[[1]]
                text <- tail(text,c)
                text<-str_c(text,collapse=" ")
                
                ## To avoid the selection of the last word, space has been added to text.
                text <- paste0(str_trim(text)," ")
                
                ## Get the predicted word from each matched n-gram along with its Probability and n.
                temp<-data.table()
                temp<-DT[n_start[c]:n_end[c]]
                temp<-temp[grep(paste0('\\<',text), str_trim(ngrams)),.(Prediction=word(ngrams,c+1,c+1),Probability=freq,n=c+1)]
                matches<-rbind(matches,temp)
        }
        ## No match so return some frequently ocurring unigrams
        if (nrow(matches)==0){
                flag=1
                matches<-data.table(Prediction=c("the","to","and","a","of","i","in","for","is","that"),Probability=c(35874,20663,18236,18182,15085,12626,12322,8427,7933,7833))
        }
        
        ## Construct Interpolation model
        if(flag!=1)
        {
                ## Compute probabilities from frequency for each predicted word, grouped by n
                matches<-matches[,.(Prediction,Probability,sumfreq=sum(Probability)),by=n]
                matches[,3]<-matches[,3]/matches[,4]
                
                ## Calculate Interpolated Probabilities (weighted) for each predicted word
                matches<-matches[,.(Prediction,Probability=Lambda[n-1]*Probability)]
                
                ## Look for same predicted words, if any, and add probabilities
                matches<-matches[,.(Probability=sum(Probability)),by=Prediction][order(-Probability)]
                
                if(nrow(matches)>=1000)
                      matches<-matches[1:1000]
        }
        matches<-matches[,.(Prediction,Probability=round(Probability*100/sum(Probability),4))]
        matches
}
##result<-data.table(NextWordPredictor(inputtext))
##result