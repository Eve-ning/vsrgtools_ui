library(shinydashboard)
library(plotly)
x <- 1
dashboardPage(

  dashboardHeader(title = "estear"),
  dashboardSidebar(width = "300px",
    sidebarMenu(
      textAreaInput("text",
        label = "Input file contents here",
        placeholder = "<.osu file>"),
      selectInput("keyset.select",
        label = "Keyset Selection",
        choices = c("4", "5R", "5L", "6", "7R", "7L",
                    "8SPR", "8SPL", "8SYM", "9R", "9L"),
        selected = "4"),
      actionButton("parse", "Parse Input"),
      menuItem(text = "@def_evening on Twitter",
           href = "https://twitter.com/def_evening",
           icon = icon('twitter')),      
      menuItem(text = "User Interface Repository",
           href = "https://github.com/Eve-ning/osutools",
           icon = icon('github')),      
      menuItem(text = "Package Repository",
           href = "https://github.com/Eve-ning/osutools_ui",
           icon = icon('github')),
      menuItem(text = "Report an Issue Here",
           href = "https://github.com/Eve-ning/osutools/issues/new",
           icon = icon('github'))
    )
    
    
  ),
  dashboardBody(
    fluidRow(
      column(width = 4,
      tabBox(title = "Parameters",
        id = "tabParams", height = 826, width = NULL,
        tabPanel("General", width = NULL,
          p("Speed of the chart"),
          sliderInput("rate", "Rate", 0.1, 10.00, value = 1.0, step = 0.1),
          p("Smoothing of the plots"),
          sliderInput("smoothing", "Smoothing", 0.01, 1.00, value = 0.1, step = 0.01)
        ),
        tabPanel("Advanced", width = NULL,
          p("The Calculation is dependent on this quantile"),
        
          sliderInput("dif.quant", "Calculation Quantile", 0.01, 1.00, value = c(0.85, 0.95), step = 0.01),
          sliderInput("decay.ms", "Decay per ms", 0.001, 1.00, value = 0.1, step = 0.001)
        ),
        tabPanel("Motion Model", width = NULL,
          p("These values affect the model entirely, it is not recommended to adjust"),
          p("Details on adjustment will be written soon on the wiki"),
          sliderInput("mtn.jack", "Jack Weight", 0.0, 10.0, value = 2.5, step = 0.1),
          sliderInput("mtn.across", "Across Weight", 0.0, 10.0, value = 1.1, step = 0.1),
          sliderInput("mtn.in", "In Weight", 0.0, 10.0, value = 1.0, step = 0.1),
          sliderInput("mtn.out", "Out Weight", 0.0, 10.0, value = 1.4, step = 0.1),
          checkboxInput("mtn.ignore.jacks", "Ignore Jacks", F)
        ),
        tabPanel("Model", width = NULL,
          p("These values affect the model entirely, it is not recommended to adjust"),
          p("Details on adjustment will be written soon on the wiki"),
          sliderInput("jck.pow", "Jack Model Weight", 0, 10.0, value = 0.0, step = 0.1),
          sliderInput("mtn.pow", "Motion Model Weight", 0, 10.0, value = 0.5, step = 0.1),
          sliderInput("dns.pow", "Density Model Weight", 0, 10.0, value = 1.0, step = 0.1),
          sliderInput("sim.bin.size", "Simulation Bin Size", 500, 20000, value = 5000, step = 500)
        )
      )
      ),
      column(width = 4,
          box(
            title = "Model Output",
            status = "info",
            width = NULL,
            background = "light-blue",
            plotlyOutput("model.plt", height = "200px")
          )
      ),
      column(width = 4,
        box(
          title = "Stress Output",
          status = "info",
          width = NULL,
          background = "navy",
          plotlyOutput("stress.plt", height = "200px")
        )
      ),
      column(width = 4,
          box(
            title = "JCK Output",
            status = "info",
            width = NULL,
            background = "light-blue",
            plotlyOutput("jck.plt", height = "200px")
          )
      ),
      column(width = 4,
          box(
            title = "MTN Output",
            status = "info",
            width = NULL,
            background = "navy",
            plotlyOutput("mtn.plt", height = "200px")
          )
      ),
      column(width = 4,
          box(
            title = "DNS Output",
            status = "info",
            width = NULL,
            background = "navy",
            plotlyOutput("dns.plt", height = "200px")
          )
      ),
      column(width = 4,
          box(
            title = "MNP Output",
            status = "info",
            width = NULL,
            background = "navy",
            plotlyOutput("mnp.plt", height = "200px")
          )
      ),
      column(width = 4, valueBoxOutput("dly", width = NULL)),
      column(width = 4, valueBoxOutput("calc1", width = NULL)),
      column(width = 4, valueBoxOutput("calc2", width = NULL)),
      
      column(width = 12,
        box(h3("Most details here will be moved to GitHub soon."),
          status = 'danger', width = NULL)
      ),
      column(width = 6,
        box(width = NULL, status = 'info',
          h2("More Info"),
          p("All information you'll need will be on the side-bar on the left.")
          
        ) # Detail Box
      ), # Column
      column(width = 6,
        box(width = NULL, status = 'warning',
          h1("Parameter Log"),
          p("Share this if you want to your settings with someone else."),
          p("There's currently no way to import settings, but it may be a thing
           in the future"),
          verbatimTextOutput("params.log")
        ) # Detail Box
      ) # Column
    ) # FluidRow
  ) # DashboardBody
)
