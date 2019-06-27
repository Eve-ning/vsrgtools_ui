library(shinydashboard)
library(osutools)
library(plotly)
library(ggplot2)


shinyServer(function(input, output) {

    observeEvent(input$parse, {
        text <- strsplit(input$text, '\n')
        text <- text[[1]]
        
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
        
        # Render Plots
        {
        chart.stress.plt <- ggplot(chart$sim) +
            aes(offsets, stress) +
            geom_line(alpha = 0.3) + 
            geom_smooth(span = input$smoothing, method='loess', se=F) 
        
        chart.model.plt <- ggplot(chart$model) +
            aes(bins, values) +
            geom_line(alpha = 0.3) + 
            geom_smooth(span = input$smoothing, method='loess', se=F)
        
        chart.jck.plt <- ggplot(chart$jck) +
            aes(offsets, values) +
            geom_line(alpha = 0.3) + 
            geom_smooth(span = input$smoothing, method='loess', se=F) 
        chart.mtn.plt <- ggplot(chart$mtn) +
            aes(offsets, values) +
            geom_line(alpha = 0.3) + 
            geom_smooth(span = input$smoothing, method='loess', se=F)
        chart.dns.plt <- ggplot(chart$dns) +
            aes(offsets, values) +
            geom_line(alpha = 0.3) + 
            geom_smooth(span = input$smoothing, method='loess', se=F) 
        
        output$stress.plt <- renderPlotly(chart.stress.plt)
        output$model.plt <- renderPlotly(chart.model.plt)
        output$jck.plt <- renderPlotly(chart.jck.plt)
        output$mtn.plt <- renderPlotly(chart.mtn.plt)
        output$dns.plt <- renderPlotly(chart.dns.plt)
        }
        output$dly <- renderValueBox(valueBox(dly, subtitle = "ms delay", color = 'teal'))
        output$calc1 <- renderValueBox(
            valueBox(color = "maroon",
            subtitle =
                paste(
                    " Approximate Difficulty (",
                    input$dif.quant[[1]], ' ~ ',
                    input$dif.quant[[2]], ' Quantile)', sep = ''),
            value =
                paste(
                round(quantile(chart$sim$stress, input$dif.quant)[[1]],2),
                round(quantile(chart$sim$stress, input$dif.quant)[[2]],2),
                sep = ' ~ ')
            )
        ) # renderValueBox
        output$calc2 <- renderValueBox(
            valueBox(color = "maroon",
            subtitle =
                paste(
                " Approximate Difficulty (",
                input$dif.quant[[1]], ' ~ ',
                input$dif.quant[[2]], ' Quantile)', sep = ''),
            value =
                paste(
                round(quantile(chart$model$values, input$dif.quant)[[1]],2),
                round(quantile(chart$model$values, input$dif.quant)[[2]],2)
                ,sep = ' ~ ')
            )
        ) # renderValueBox
        
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
