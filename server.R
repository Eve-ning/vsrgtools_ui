library(shinydashboard)
library(osutools)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    source("r/parseInput.R")

    observeEvent(input$parse, {
        text <- strsplit(input$text, '\n')
        text <- text[[1]]
        # chart <- parseInput(text,
        #                     keyset.select = input$keyset.select,
        #                     span = input$smoothing,
        #                     rate = input$rate,
        #                     dif.quant = input$dif.quant)
        
        start.time <- Sys.time()
        chart <- calculateDifficulty(
            chart.lines = text,
            keyset.select = input$keyset.select,
            decay.ms = input$decay.ms,
            mtn.ignore.jacks = input$mtn.ignore.jacks,
            mtn.across.weight = input$mtn.across,
            mtn.in.weight = input$mtn.in,
            mtn.out.weight = input$mtn.out,
            mtn.jack.weight = input$mtn.jack,
            jck.pow = input$jck.pow,
            mtn.pow = input$mtn.pow,
            dns.pow = input$dns.pow
        )
        end.time <- Sys.time()
        dly <- end.time - start.time
        
        require(ggplot2)
        chart.stress.plt <- ggplot(chart$sim) +
            aes(offsets, stress) +
            geom_smooth(span = input$smoothing, method='loess', se=F) 
        
        chart.model.plt <- ggplot(chart$model) +
            aes(offsets, values) +
            geom_smooth(span = input$smoothing, method='loess', se=F)
        
        output$stress.plt <- renderPlot(chart.stress.plt, height="auto")
        output$model.plt <- renderPlot(chart.model.plt, height="auto")

        output$dly <- renderValueBox(valueBox(dly, subtitle = "ms delay", color = 'teal'))
        output$calc1 <- renderValueBox(
            valueBox(quantile(chart$sim$stress, input$dif.quant), subtitle = " Stress",
                     color = "maroon")
        )
        output$calc2 <- renderValueBox(
            valueBox(quantile(chart$model$values, input$dif.quant), subtitle = " Difficulty",
                     color = "maroon")
        )
        # dif <- reactive(list("jck" = quantile(chart$s.mdls$jck$values,
        #                                       input$dif.quant,
        #                                       type = 7),
        #                      "mtn" = quantile(chart$s.mdls$mtn$values / 100,
        #                                       input$dif.quant,
        #                                       type = 7),
        #                      "dns" = quantile(chart$s.mdls$dns$values[chart$s.mdls$dns$values > 0],
        #                                       input$dif.quant,
        #                                       type = 7),
        #                      "calc1" = quantile(chart$s.mdls$mtn$values *
        #                                         chart$s.mdls$dns$values,
        #                                         input$dif.quant,
        #                                         type = 7),
        #                      "calc2" = quantile(chart$s.mdls$mtn$values *
        #                                         chart$s.mdls$jck$values *
        #                                         chart$s.mdls$dns$values * 100,
        #                                         input$dif.quant,
        #                                         type = 7)))
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
        # 
        # output$calc1 <- renderValueBox(
        #     valueBox(round(dif()$calc1, 5),
        #              subtitle = paste0("Calculation VER 1 ", input$dif.quant * 100, "%"),
        #              color = "red")
        # )
        # 
        # output$calc2 <- renderValueBox(
        #     valueBox(round(dif()$calc2, 5),
        #              subtitle = paste0("Calculation VER 2 ", input$dif.quant * 100, "%"),
        #              color = "yellow")
        # )
            
    })

    
    
})
