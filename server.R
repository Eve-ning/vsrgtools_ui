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
        dif <- reactive(list("jck" = quantile(chart$s.mdls$jck$values,
                                              input$dif.quant,
                                              type = 7),
                             "mtn" = quantile(chart$s.mdls$mtn$values / 100,
                                              input$dif.quant,
                                              type = 7),
                             "dns" = quantile(chart$s.mdls$dns$values[chart$s.mdls$dns$values > 0],
                                              input$dif.quant,
                                              type = 7),
                             "calc1" = quantile(chart$s.mdls$mtn$values *
                                                chart$s.mdls$dns$values,
                                                input$dif.quant,
                                                type = 7),
                             "calc2" = quantile(chart$s.mdls$mtn$values *
                                                chart$s.mdls$jck$values *
                                                chart$s.mdls$dns$values * 100,
                                                input$dif.quant,
                                                type = 7)))

        output$jck <- renderValueBox(
            valueBox(round(dif()$jck, 5) * 1000,
                     subtitle = paste0("Jack Quantile ", input$dif.quant * 100, "%"),
                     color = "light-blue")
        )

        output$mtn <- renderValueBox(
            valueBox(round(dif()$mtn, 5) * 1000,
                     subtitle = paste0("Motion Quantile ", input$dif.quant * 100, "%"),
                     color = "blue")
        )
        output$dns <- renderValueBox(
            valueBox(round(dif()$dns, 5),
                     subtitle = paste0("Density Quantile ", input$dif.quant * 100, "%"),
                     color = "navy")
        )
        
        output$calc1 <- renderValueBox(
            valueBox(round(dif()$calc1, 5),
                     subtitle = paste0("Calculation VER 1 ", input$dif.quant * 100, "%"),
                     color = "red")
        )
        
        output$calc2 <- renderValueBox(
            valueBox(round(dif()$calc2, 5),
                     subtitle = paste0("Calculation VER 2 ", input$dif.quant * 100, "%"),
                     color = "yellow")
        )
            
    })

    
    
})
