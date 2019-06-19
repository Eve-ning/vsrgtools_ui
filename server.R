library(shinydashboard)
library(osutools)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    source("r/parseInput.R")

    observeEvent(input$parse, {
        text <- strsplit(input$text, '\n')
        text <- text[[1]]
        chart <- parseInput(text,
                            keyset.select = input$keyset.select,
                            span = input$smoothing,
                            rate = input$rate,
                            dif.quant = input$dif.quant)
        
        output$plt <- renderPlot(chart$plt, height="auto")
        output$dly <- renderValueBox(
            valueBox(round(chart$dly, 5), subtitle = "seconds elapsed ",
                     color = "maroon")
            )
            
    })
})
