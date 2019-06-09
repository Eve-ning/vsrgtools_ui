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
        
        actionButton("parse", "Parse Input")
    )
    )
)
