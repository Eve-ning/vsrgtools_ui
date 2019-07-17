library(shinydashboard)
library(osutools)
library(plotly)
library(ggplot2)
library(dplyr)


shinyServer(function(input, output) {

  observeEvent(input$parse, {
    text <- strsplit(input$text, '\n')
    text <- text[[1]]
    
    start.time <- Sys.time()
    chart <- chartParse(chart.lines = text)
    chart <- mutate(chart, offsets = offsets / input$chart.rate)
    chart.ext <- chartExtract(chart, chart.keyset.select = input$chart.keyset.select)
    
    mtn <- model.motion(
      chart.ext, directions.mapping = 
      data.frame(
        directions = c('across', 'in', 'out', 'jack'),
        weights = c(input$mtn.across, input$mtn.in, input$mtn.out, input$mtn.jack),
        stringsAsFactors = F
      ))
    
    dns <- model.density(
      chart
    )
    
    mnp <- model.manipulation(
      chart, input$mnp.window, input$mnp.bias.scale
    )
    
    lng <- model.longNote(
      chart, input$chart.keyset.select, directions.mapping = 
      data.frame(
        directions = c('across', 'in', 'out', 'jack'),
        weights = c(input$mtn.across, input$mtn.in, input$mtn.out, input$mtn.jack),
        stringsAsFactors = F
      )
    )
    
    end.time <- Sys.time()
    dly <- end.time - start.time
    
    # Render Plots
    {
    chart.mtn.plt <- ggplot(mtn) +
      aes(offsets, values) +
      geom_line(alpha = 0.3) + 
      geom_smooth(span = input$smoothing, method='loess', se=F)
    chart.dns.plt <- ggplot(dns) +
      aes(offsets, values) +
      geom_line(alpha = 0.3) + 
      geom_smooth(span = input$smoothing, method='loess', se=F)
    chart.mnp.plt <- ggplot(mnp) +
      aes(offsets, values) +
      geom_line(alpha = 0.3) + 
      geom_smooth(span = input$smoothing, method='loess', se=F) 
    chart.lng.plt <- ggplot(lng) +
      aes(offsets, values) +
      geom_line(alpha = 0.3) + 
      geom_smooth(span = input$smoothing, method='loess', se=F) 
    
    output$mtn.plt <- renderPlotly(chart.mtn.plt)
    output$dns.plt <- renderPlotly(chart.dns.plt)
    output$mnp.plt <- renderPlotly(chart.mnp.plt)
    output$lng.plt <- renderPlotly(chart.lng.plt)
    }
    output$dly <- renderValueBox(valueBox(dly, subtitle = "ms delay",
                                          color = 'teal'))
    
    output$params.log <- renderText(
      paste(
        "mtn.jack", input$mtn.jack, "\n",
        "mtn.across", input$mtn.across, "\n",
        "mtn.in", input$mtn.in, "\n",
        "mtn.out", input$mtn.out, "\n",
        "mnp.window", input$mnp.window, "\n",
        "mnp.bias.scale", input$mnp.bias.scale, "\n",
        "chart.keyset.select", input$chart.keyset.select, "\n",
        "chart.rate", input$rate, "\n",
        "smoothing", input$smoothing, "\n",
        sep = "; "
      )[1]
    )
  })
})

