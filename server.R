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
            dns.pow = input$dns.pow,
            chart.rate = input$rate,
            sim.bin.size = input$sim.bin.size 
        )
        end.time <- Sys.time()
        dly <- end.time - start.time
        
        require(ggplot2)
        chart.stress.plt <- ggplot(chart$sim) +
            aes(offsets, stress) +
            geom_smooth(span = input$smoothing, method='loess', se=F) 
        
        chart.model.plt <- ggplot(chart$model) +
            aes(bins, values) +
            geom_smooth(span = input$smoothing, method='loess', se=F)
        
        output$stress.plt <- renderPlot(chart.stress.plt, height="auto")
        output$model.plt <- renderPlot(chart.model.plt, height="auto")

        output$dly <- renderValueBox(valueBox(dly, subtitle = "ms delay", color = 'teal'))
        output$calc1 <- renderValueBox(
            valueBox(paste(
                round(quantile(chart$sim$stress, input$dif.quant)[[1]],2),
                round(quantile(chart$sim$stress, input$dif.quant)[[2]],2),
                sep = ' - '
                ), subtitle = " Stress",
                     color = "maroon")
        )
        output$calc2 <- renderValueBox(
            valueBox(paste(
                round(quantile(chart$model$values, input$dif.quant)[[1]],2),
                round(quantile(chart$model$values, input$dif.quant)[[2]],2),
                sep = ' - '
            ), subtitle = " Difficulty",
                     color = "maroon")
        )
        
        output$params.log <- renderText(
            paste(
                "mtn.jack", input$mtn.jack, "\n",
                "mtn.across", input$mtn.across, "\n",
                "mtn.in", input$mtn.in, "\n",
                "mtn.out", input$mtn.out, "\n",
                "mtn.ignore.jacks", input$mtn.ignore.jacks, "\n",
                "jck.pow", input$jck.pow, "\n",
                "mtn.pow", input$mtn.pow, "\n",
                "dns.pow", input$dns.pow, "\n",
                "keyset.select", input$keyset.select, "\n",
                "rate", input$rate, "\n",
                "smoothing", input$smoothing, "\n",
                "dif.quant", input$dif.quant, "\n",
                "decay.ms", input$decay.ms, "\n",
                "sim.bin.size", input$sim.bin.size,
                sep = "; "
            )[1]
        )
        
    })

    
    
})
