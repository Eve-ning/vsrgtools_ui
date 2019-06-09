#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("VSRG Simulator Interface"),

    mainPanel(
        plotOutput("stress_sim"),
        plotOutput("broadcast")
        ),
    
    sidebarPanel(
        textAreaInput("osu",
                      "Input .osu contexts here",
                      placeholder = "<.osu file>"),
        
        sliderInput("decay_a", "Decay Alpha", 1.0, 5.0, value = 1.5, step = 0.1),
        sliderInput("decay_b", "Decay Beta", 100, 10000, value = 1000, step = 100),
        
        sliderInput("smoothing", "Smoothing", 0.01, 1.00, value = 0.5, step = 0.01),
        sliderInput("smoothing_op", "Smoothing Opacity", 0.01, 1.00, value = 0.75, step = 0.01),
        checkboxInput("smoothing_show", "Show Smoothing", value = T),
        
        sliderInput("raw_op", "Raw Opacity", 0.01, 1.00, value = 0.75, step = 0.01),
        checkboxInput("raw_show", "Show Raw", value = T),
        
        checkboxInput("label_show", "Show Labels", value = T),
        
        actionButton("parse", "Parse Input")
    )
    )
)
