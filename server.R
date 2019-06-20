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
        # dif <- reactive(list("jck" = quantile(chart$s.mdls$jck$jack.invs,
        #                                       input$dif.quant,
        #                                       type = 7),
        #                      "mtn" = quantile(chart$s.mdls$mtn$diffs.invs,
        #                                       input$dif.quant,
        #                                       type = 7),
        #                      "dns" = quantile(chart$s.mdls$dns$counts[chart$s.mdls$dns$counts > 0],
        #                                       input$dif.quant,
        #                                       type = 7)))
        # 
        # output$jck <- renderValueBox(
        #     valueBox(round(dif()$jck, 5) * 1000,
        #              subtitle = paste0("Jack Quantile ", input$dif.quant * 100, "%"),
        #              color = "light-blue")
        # )
        # 
        # output$mtn <- renderValueBox(
        #     valueBox(round(dif()$mtn, 5) * 1000,
        #              subtitle = paste0("Motion Quantile ", input$dif.quant * 100, "%"),
        #              color = "blue")
        # )
        # output$dns <- renderValueBox(
        #     valueBox(round(dif()$dns, 5),
        #              subtitle = paste0("Density Quantile ", input$dif.quant * 100, "%"),
        #              color = "navy")
        # )
            
    })

    
    
})
