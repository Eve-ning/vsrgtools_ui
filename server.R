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
require(directlabels)
require(magrittr)
require(dplyr)
require(osutools)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    observeEvent(input$parse, {
        osu <- strsplit(input$osu, '\n')
        osu <- osu[[1]]
        chart <- f.chart.parse(chart.lines = osu)
        
        # Stress Simulation
        chart.sim <- f.stress.sim(chart = chart,
                                  stress.init = 0,
                                  decay_alpha = input$decay_a,
                                  decay_beta = input$decay_b)
        
        chart.sim %<>%
            mutate(bins = (offsets %/% input$bin_size) * input$bin_size) %>% 
            group_by(bins, keys) %>% 
            summarise(stress.mean = mean(stress))
        
        sim.plot <- ggplot(chart.sim) +
                    aes(bins, stress.mean,
                        group = factor(keys),
                        color = factor(keys))
        
        if (input$raw_show) {
            sim.plot <- sim.plot + geom_line(alpha = input$raw_op)
        }
        
        if (input$smoothing_show) {
            sim.plot <- sim.plot + stat_smooth(geom='line',
                                               alpha = input$smoothing_op,
                                               method = "loess",
                                               span = input$smoothing) 
        }
        
        output$stress_sim <- renderPlot({sim.plot})
        
        # Difference Broadcasting
        chart.bcst <- f.diff.broadcast(chart,
                                       ignore.types = c('lnotel'))
        
        chart.bcst %<>% 
            filter(keys.froms == keys.tos) %>% 
            mutate(jack.inverse = 1/diffs) %>% 
            mutate(bins = (offsets %/% input$bin_size) * input$bin_size) %>% 
            group_by(bins, keys.froms) %>% 
            summarise(jack.inverse.mean = mean(jack.inverse))
        
        bcst.plot <- ggplot(chart.bcst) +
                     aes(bins, jack.inverse.mean,
                         group = factor(keys.froms),
                         color = factor(keys.froms)) +
            geom_line() +
            facet_wrap(. ~ keys.froms, nrow = 2)
        
        output$broadcast <- renderPlot({bcst.plot})
            
    })
})
