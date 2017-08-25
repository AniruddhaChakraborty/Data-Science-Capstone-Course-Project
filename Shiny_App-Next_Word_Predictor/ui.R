library(shiny)
library(markdown)

shinyUI(navbarPage("Data Science Capstone Course Project on Text Prediction",
                   tabPanel("Next Word Predictor",
                            sidebarLayout(
                                    sidebarPanel(
                                            ## Input Control
                                            textInput("inputtext", "Please enter a phrase to get the next word prediction :",value = "a beautiful"),
                                            tags$hr(),
                                            submitButton(text="Submit"),
                                            br(),
                                            tags$hr(),
                                            h5(strong("Application designed and developed by - Aniruddha Chakraborty")),
                                            h5(strong("Resources :")),
                                            h5("1. " , a(" Link to the Rpubs Reproducible Pitch presentation on the Next Word Predictor App.", href="http://rpubs.com/AniruddhaChakraborty/301935")),
                                            h5("2. " , a(" Refer to page numbers 58 and 59 of this lecture on Language Modeling, to know about the Simple/Linear Interpolation algorithm, which has been used in this App.", href="https://web.stanford.edu/class/cs124/lec/languagemodeling.pdf")),
                                            h5("3. " , a(" Link to the source code of n-gram Language model and Interpolation Prediction Algorithm.", href="https://github.com/AniruddhaChakraborty/Data-Science-Capstone-Course-Project/Next_Word_Predictor")),
                                            h5("4. " , a(" Link to the source code of ui.R and server.R files.", href="https://github.com/AniruddhaChakraborty/Data-Science-Capstone-Course-Project/Shiny_App-Next_Word_Predictor"))                       
                                    ),
                                    mainPanel(tags$style(type="text/css","h4 {text-align: center;}","h1 {padding:10 px;background-color:#F1F5F9;border:#005CB9 1px solid;text-align: center;}"),
                                            h4("Next Word Predicted by the Interpolation Algorithm is :"),
                                            fluidRow(h1(textOutput("predicted"))),
                                            br(),
                                            fluidRow(column(6,h4("Top 10 Next Word Predictions")),
                                            column(6,h4("Word Cloud of Next Word Predictions"))),
                                            tags$hr(),
                                            fluidRow(splitLayout(cellWidths = c("50%", "50%"), 
                                                                plotOutput("top10"), 
                                                                plotOutput("wordcloud"), style = "overflow:hidden;")
                                            )
                                    )
                            )
                   ),
                   tabPanel("Documentation",mainPanel(includeMarkdown("Documentation.md"))
                   )))