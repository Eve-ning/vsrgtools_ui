library(shinydashboard)
library(plotly)
dashboardPage(

  dashboardHeader(title = "estear"),
  dashboardSidebar(width = "300px",
    sidebarMenu(
      textAreaInput("text",
        label = "Input file contents here",
        placeholder = "<.osu file>"),
      selectInput("chart.keyset.select",
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
        id = "tabParams", height = 908, width = NULL,
        tabPanel("General", width = NULL,
          p("Speed of the chart"),
          sliderInput("chart.rate", "Rate", 0.1, 10.00, value = 1.0, step = 0.1),
          p("Smoothing of the plots"),
          sliderInput("smoothing", "Smoothing", 0.1, 1.00, value = 0.1, step = 0.01)
        ),
        tabPanel("Motion Model", width = NULL,
          p("These values affect the model entirely, it is not recommended to adjust"),
          p("Details on adjustment will be written soon on the wiki"),
          sliderInput("mtn.jack", "Jack Weight", 0.0, 10.0, value = 2.5, step = 0.1),
          sliderInput("mtn.across", "Across Weight", 0.0, 10.0, value = 0.9, step = 0.1),
          sliderInput("mtn.in", "In Weight", 0.0, 10.0, value = 1.0, step = 0.1),
          sliderInput("mtn.out", "Out Weight", 0.0, 10.0, value = 1.4, step = 0.1)
        ),
        tabPanel("Manipulation", width = NULL,
          p("These values affect the model entirely, it is not recommended to adjust"),
          p("Details on adjustment will be written soon on the wiki"),
          sliderInput("mnp.window", "Window of MNP", 100, 5000, value = 1000, step = 100),
          sliderInput("mnp.bias.scale", "Bias Scaling", 0.1, 5, value = 0.25, step = 0.05)
        )
        ) # Column
      ),
      column(width = 8,
          box(
            title = "Motion Difficulty",
            status = "info",
            width = NULL,
            background = "navy",
            plotlyOutput("mtn.plt", height = "150px")
          )
      ),
      column(width = 8,
          box(
            title = "Density Difficulty",
            status = "info",
            width = NULL,
            background = "navy",
            plotlyOutput("dns.plt", height = "150px")
          )
      ),
      column(width = 8,
          box(
            title = "Manipulation Correction",
            status = "info",
            width = NULL,
            background = "navy",
            plotlyOutput("mnp.plt", height = "150px")
          )
      ),
      column(width = 8,
             box(
               title = "Long Note Correction",
               status = "info",
               width = NULL,
               background = "navy",
               plotlyOutput("lng.plt", height = "150px")
             )
      ),
      column(width = 4, valueBoxOutput("dly", width = NULL)),
      
      column(width = 12,
        box(h3("Most details here will be moved to GitHub soon."),
          status = 'danger', width = NULL)
      ),
      column(width = 6,
        box(width = NULL, status = 'info',
          h2("TL;DR"),
          h3("Motion"), p("is how hard it is to play 2 different notes"),
          h3("Density"), p("is calculated as Notes per Second"),
          h3("Manipulation Correction"), p("is a negative scaling, where high
            values negatively impact difficulty rating"),
          h3("Long Note Correction"), p("is a positive scaling where high values
            positively impact difficulty rating")
          
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

