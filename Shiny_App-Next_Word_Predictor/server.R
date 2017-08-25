library(shiny)
library(ggplot2)
library(wordcloud)
library(data.table)
source("PredictionAlgorithm_Interpolation_datatable.R")
# Define server logic 
shinyServer(function(input, output) {
        data<-reactive(data.table(NextWordPredictor(input$inputtext)))
        output$predicted<-renderText({
                result<-data()
                result$Prediction[1]
        })
        
        output$top10<-renderPlot({
                result<-data()
                if(nrow(result)>=10)
                        result<-result[1:10]
                ggplot(result,aes(x=reorder(Prediction,Probability),y=Probability,fill=Prediction,label=paste(round(Probability,0),"%")))+ labs(x = "Predictions", y = "Probability (Percentage)") +geom_bar(stat="identity")+ geom_text(hjust=-.2,size = 5, color = "black")+coord_flip()+theme(axis.text.x = element_text( face = "bold", size = 16, color = "black") , axis.ticks.x = element_blank() , axis.text.y = element_text( face = "bold", size = 16, color = "black") , axis.ticks.y = element_blank(), complete = TRUE)+guides(fill=FALSE)+ scale_y_continuous(expand = c(.2, .2))
                
        })
        
        output$wordcloud<-renderPlot({
                result<-data()
                if(nrow(result)>=100)
                        result<-result[1:100]
                wordcloud(result$Prediction, result$Probability*100, scale=c(5,0.8), max.words=100, colors=brewer.pal(8, "Dark2"),rot.per=.2,use.r.layout = FALSE, random.order = FALSE)
        })
})
