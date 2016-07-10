library("shinydashboard")
library(ggiraph)

header <- dashboardHeader(title = "Demo ggiraph")
sidebar <- dashboardSidebar(disable = TRUE)

body <- dashboardBody(
  box(
    width = 12,
    fluidRow(
      column(
        width = 5,
        box(status = "success",
          title = "Focus département", solidHeader = TRUE, width = NULL,
          uiOutput("title_departement"),
          ggiraphOutput("detail_plot", height = "100%")
        )
      ),
      column(
        width = 7,
        box(status = "warning",
        title = "Statistiques générales", solidHeader = TRUE, width = NULL,
        ggiraphOutput("plot", height = "100%")
      )
      )
    ),
    fluidRow(
      column(
        width = 12,
        box(status = "primary",
          title = "Focus nuance", solidHeader = TRUE, width = NULL,
          uiOutput("title_nuance"),
          fluidRow(
            column(width=5,
                   ggiraphOutput("nuance_across_fr", height = "100%"),
                   actionButton("reset", label = "Reset selection", width = "100%")
            ),
            column(width=7, DT::dataTableOutput("data", height = "100%"))
          )
        )
      )
    )


  )
)


dashboardPage(header = header, sidebar = sidebar, body = body, skin = "red")

