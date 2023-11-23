library(shiny)
library(tidyverse)
library(shinyMobile)
library(httr2)
library(c3)

readRenviron(".Renviron")

Settings <- fGetSettings()

ui <- shinyMobile::f7Page(
  
  title = "Tallawong Parking Monitor",
  
  options = list(dark = FALSE,
                 theme = "aurora",
                 color = Settings$ColourTheme),
  
  
  
  # Core app
  shinyMobile::f7TabLayout(
    
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "Parking.css")
    ),
    
    navbar = shinyMobile::f7Navbar(
      
      title = "Tallawong Parking Monitor",  # TODO? Update title? shiny::textOutput("Title")
      leftPanel = TRUE,
      rightPanel = FALSE
      
    ),
    
    # Help panel
    panels = shinyMobile::f7Panel(
      
      id = "UserPanel",
      side = "left",
      theme = "light",
      effect = "reveal",
      title = "Help",
      
      shiny::tags$div(class = "GitHubIcon",
                      shiny::a(shinyMobile::f7Icon("logo_github"),
                               href = "https://github.com/PeterM74/TallawongCarparkMonitor")
      ),

      # Help spiel
      shinyMobile::f7Padding(shiny::p(paste0("This webapp was designed to reflect realtime usage of the Tallawong ",
                                                "carpark.")), 
                             side = "horizontal"),
      shinyMobile::f7Padding(shiny::p("If you encounter an issue, please raise a bug on the Github page."), 
                             side = "horizontal"),
      shinyMobile::f7Padding(shiny::tags$i("Author: Peter Moritz"),
                             side = "horizontal")
      
    ),
    
    
    
    # Tabs
    shinyMobile::f7Tabs(
      
      id = "tabs",
      
      ##  First tab - Home -----
      shinyMobile::f7Tab(
        
        tabName = "Home",
        title = "Home",
        icon = shinyMobile::f7Icon("house_fill"),
        active = TRUE,
        
        # Summary section
        shiny::tagList(
          
          shiny::tags$u(shinyMobile::f7Padding(shiny::h2("Tallawong parking", 
                                                         style = paste0("color: ", Settings$ColourTheme), 
                                                         .noWS = "after"), side = "left")),
          fSummaryStatsUIModule("TallawongP1SummaryGauge",
                                Name = "P1",
                                Settings = Settings),
          fSummaryStatsUIModule("TallawongP2SummaryGauge",
                                Name = "P2",
                                Settings = Settings),
          fSummaryStatsUIModule("TallawongP3SummaryGauge",
                                Name = "P3",
                                Settings = Settings)
          
        ),
        
        # Tallawong park breakdown
        shiny::tagList(
          
          shiny::tags$u(shinyMobile::f7Padding(shiny::h2("Park breakdown", 
                                                         style = paste0("color: ", Settings$ColourTheme), 
                                                         .noWS = "after"), side = "left")),
          shiny::uiOutput("SummaryTable")
          
        )
        
        
        
      ),
      
      
      ## Second tab - Historical data -----
      shinyMobile::f7Tab(
        
        tabName = "Historical",
        title = "History",
        icon = shinyMobile::f7Icon("calendar"),
        
        # Historical view
        shiny::tagList(
          
          shiny::p("Data being collected")
          
        ),
        
      )
      
    )
    
  )
  
)

server <- function(input, output, session) {
  
  # Summary page elements -----
  ## Summary page API call
  P1APICall <- fCallAPI(Settings$APIRootURL,
                        Endpoint = Settings$APIEndpoints$Realtime, 
                        APIKey = Settings$APIKey, 
                        FacilityID = Settings$FacilityIDs$P1) %>%
    fExtractAPIData() %>%
    fParseRequestForAvailableParks()
  
  P2APICall <- fCallAPI(Settings$APIRootURL,
                        Endpoint = Settings$APIEndpoints$Realtime, 
                        APIKey = Settings$APIKey, 
                        FacilityID = Settings$FacilityIDs$P2) %>%
    fExtractAPIData() %>%
    fParseRequestForAvailableParks()
  
  P3APICall <- fCallAPI(Settings$APIRootURL,
                        Endpoint = Settings$APIEndpoints$Realtime, 
                        APIKey = Settings$APIKey, 
                        FacilityID = Settings$FacilityIDs$P3) %>%
    fExtractAPIData() %>%
    fParseRequestForAvailableParks()
  
  
  ## Summary page gauges
  fSummaryStatsServerModule("TallawongP1SummaryGauge",
                            RequestData = P1APICall, 
                            Settings = Settings)
  
  fSummaryStatsServerModule("TallawongP2SummaryGauge",
                            RequestData = P2APICall, 
                            Settings = Settings)
  
  fSummaryStatsServerModule("TallawongP3SummaryGauge",
                            RequestData = P3APICall, 
                            Settings = Settings)
  
  ## Summary table
  TallawongTable <- fCreateSummaryTable(list(P1APICall, P2APICall, P3APICall),
                                        Settings = Settings)
  output$SummaryTable <- shiny::renderUI({
    shinyMobile::f7Table(TallawongTable)
  })
  
}

shinyApp(ui, server)
