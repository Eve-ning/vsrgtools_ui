library(shinydashboard)

dashboardPage(

    dashboardHeader(title = "estear"),
    dashboardSidebar(width = "300px",
        textAreaInput("text",
                      label = "Input file contents here",
                      placeholder = "<.osu file>"),
        selectInput("keyset.select",
                    label = "Keyset Selection",
                    choices = c("4", "5R", "5L", "6", "7R", "7L", "8SPR", "8SPL", "8SYM", "9R", "9L"),
                    selected = "4"),
        actionButton("parse", "Parse Input")
        
        
    ),
    dashboardBody(
        fluidRow(
            column(width = 3,
            tabBox(title = "Parameters",
                  id = "tabParams", height = 844, width = NULL,
                  tabPanel("General", width = NULL,
                           sliderInput("rate", "Rate", 0.1, 10.00, value = 1.0, step = 0.1),
                           sliderInput("smoothing", "Smoothing", 0.01, 1.00, value = 0.1, step = 0.01)
                  ),
                  tabPanel("Advanced", width = NULL,
                           sliderInput("dif.quant", "Calculation Quantile (WIP)", 0.01, 1.00, value = 0.85, step = 0.01),
                           sliderInput("decay.ms", "Decay per ms", 0.001, 1.00, value = 0.1, step = 0.001)
                  ),
                  tabPanel("Motion Model", width = NULL,
                           sliderInput("mtn.jack", "Jack Weight", 0.1, 10.0, value = 2.0, step = 0.1),
                           sliderInput("mtn.across", "Across Weight", 0.1, 10.0, value = 1.1, step = 0.1),
                           sliderInput("mtn.in", "In Weight", 0.1, 10.0, value = 1.0, step = 0.1),
                           sliderInput("mtn.out", "Out Weight", 0.1, 10.0, value = 1.4, step = 0.1),
                           checkboxInput("mtn.ignore.jacks", "Ignore Jacks", T)
                  ),
                  tabPanel("Model", width = NULL,
                           sliderInput("jck.pow", "Jack Model Weight", 0, 10.0, value = 1.0, step = 0.1),
                           sliderInput("mtn.pow", "Motion Model Weight", 0, 10.0, value = 1.0, step = 0.1),
                           sliderInput("dns.pow", "Density Model Weight", 0, 10.0, value = 1.0, step = 0.1)     
                  )
            )
            ),
            column(width = 9,
                box(
                    title = "Stress Output",
                    status = "info",
                    width = NULL,
                    background = "navy",
                    plotOutput("stress.plt", height = "350px")
                )
            ),
            column(width = 9,
                box(
                    title = "Model Output",
                    status = "info",
                    width = NULL,
                    background = "light-blue",
                    plotOutput("model.plt", height = "350px")
                )
            ),
            column(width = 4, valueBoxOutput("dly", width = NULL)),
            column(width = 4, valueBoxOutput("calc1", width = NULL)),
            column(width = 4, valueBoxOutput("calc2", width = NULL)),
            
            column(width = 4,
               box(width = NULL, status = 'info',
                   h1("Details"),
                   h2("Histograms for Jack and Motion Difficulty"),
                   p("Those unfamiliar with histograms, histograms are basically
                  the number of occurences within the bin. So a taller bar
                  indicates higher frequency, but a bar that is further to the
                  right indicates higher value."),
                   h2("Density"),
                   p("There are lines prefixed with an 'm', this indicates it's
                  a miniLN, any LN that is < 150 in length is considered so."),
                   
                   p("This is calculated per 1000ms, so it's similar to nps. 
                  However, it's not a stacked graph."),
                   
                   p("Note that LNTails aren't included!")
               ) # Detail Box
            ), # Column
            column(width = 4,
                box(width = NULL, status = 'warning',
                    h2("Difficulty Calculation"),
                    p("As you might already notice, this requires me to cram all
                      these data into 1 singular number, which is hard! This is
                      still a work in progress though, so stay tuned :)")
                ) # Detail Box
            ) # Column
        ) # FluidRow
    ) # DashboardBody
)
