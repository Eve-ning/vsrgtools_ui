library(shinydashboard)

dashboardPage(

    dashboardHeader(title = "estear"),
    dashboardSidebar(
        textAreaInput("text",
                      label = "Input file contents here",
                      placeholder = "<.osu file>"),
        sliderInput("rate", "Rate", 0.1, 10.00, value = 1.0, step = 0.1),
        sliderInput("smoothing", "Smoothing", 0.01, 1.00, value = 0.1, step = 0.01),
        selectInput("keyset.select",
                    label = "Keyset Selection",
                    choices = c("4", "5R", "5L", "6", "7R", "7L", "8SPR", "8SPL", "8SYM", "9R", "9L"),
                    selected = "4"),
        sliderInput("dif.quant", "Calculation Quantile", 0.01, 1.00, value = 0.85, step = 0.01),
        actionButton("parse", "Parse Input")
        
    ),
    dashboardBody(
        fluidRow(
            column(width = 12,
                box(
                    title = "Plot Output",
                    status = "info",
                    width = NULL,
                    background = "light-blue",
                    plotOutput("plt", height = "900px")
                ),
                valueBoxOutput("dly")
            )
        )
        )
        
        
        
        
        
        
    
    # # Application title
    # titlePanel("VSRG Simulator Interface"),
    # 
    # mainPanel(
    #     
    #     plotOutput("plt", height = "900px"),
    #     textOutput("dly")
    #     ),
    # 
    # sidebarPanel(
    #     textAreaInput("osu",
    #                   "Input .osu contexts here",
    #                   placeholder = "<.osu file>"),
    #     
    #     sliderInput("rate", "Rate", 0.1, 10.00, value = 1.0, step = 0.1),
    #     sliderInput("smoothing", "Smoothing", 0.01, 1.00, value = 0.1, step = 0.01),
    #     selectInput("keyset.select",
    #                 label = "Keyset Selection",
    #                 choices = c("4", "5R", "5L", "6", "7R", "7L", "8SPR", "8SPL", "8SYM", "9R", "9L"),
    #                 selected = "4"),
    #     sliderInput("dif.quant", "Calculation Quantile", 0.01, 1.00, value = 0.85, step = 0.01),
    # 
    #     
    #     actionButton("parse", "Parse Input")
    # )
    # )
)
