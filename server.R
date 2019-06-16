#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
require(osutools)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    source("r/calculateDifficulty.R")
    observeEvent(input$parse, {
        osu <- strsplit(input$osu, '\n')
        osu <- osu[[1]]
        osu <- calculateDifficulty(osu,
                                   keyset.select = input$keyset.select,
                                   span = input$smoothing,
                                   is.summarised = input$summarise,
                                   rate = input$rate,
                                   dif.quant = input$dif.quant)
        
        output$plt <- renderPlot(osu$plt)
        output$dif <- renderText(osu$dif)
        output$dly <- renderText(osu$dly)
            
    })
})
