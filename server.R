library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    source("r/parseInput.R")
    require(osutools)
    observeEvent(input$parse, {
        osu <- strsplit(input$osu, '\n')
        osu <- osu[[1]]
        osu <- parseInput(osu,
                          keyset.select = input$keyset.select,
                          span = input$smoothing,
                          rate = input$rate,
                          dif.quant = input$dif.quant)
        
        output$plt <- renderPlot(osu$plt, height="auto")
        output$dif <- renderText(osu$dif)
        output$dly <- renderText(paste0(osu$dly, " seconds elapsed "))
            
    })
})
