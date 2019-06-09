#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
require(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    observeEvent(input$parse, {
        osu <- strsplit(input$osu, '\n')
        osu <- osu[[1]]
        chart <- f.chart.parse(chart.lines = osu)
        
        # Stress Simulation
        chart.sim <- f.stress.sim(chart = chart,
                                  stress.init = 0)
        
        print(chart.sim)
        
        # Difference Broadcasting
        chart.bcst <- f.diff.broadcast(chart,
                                       ignore.types = c('lnotel'))
        
        output$stress_sim <- renderPlot({
            ggplot(chart.sim) +
                aes(offsets, stress,
                    group = keys,
                    color = keys) +
                geom_point(alpha = 0.2) + 
                geom_line() +
                facet_wrap(. ~ keys, ncol = 1)
        })
    })
    
    # output$distPlot <- renderPlot({
    # 
    #     # generate bins based on input$bins from ui.R
    #     x    <- faithful[, 2]
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white')
    # 
    # })

})
