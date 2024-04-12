library(shiny)
library(tidyverse)
library(shinyMobile)
library(httr2)
library(c3)
library(plotly)

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
      tags$link(rel = "stylesheet", type = "text/css", href = "Parking.css"),
      tags$link(rel="shortcut icon", href="favicon.ico"),
      tags$link(rel="apple-touch-icon", href="apple-touch-icon.png")
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
      

      # Help spiel
      shinyMobile::f7Padding(shiny::p(paste0("This webapp was designed to reflect realtime usage of the Tallawong ",
                                                "carpark.")), 
                             side = "horizontal"),
      shinyMobile::f7Padding(shiny::p("If you encounter an issue, please raise a bug on the Github page."), 
                             side = "horizontal"),
      shinyMobile::f7Padding(shiny::tags$i("Author: Peter Moritz"),
                             side = "horizontal"),
      shiny::br(),
      shinyMobile::f7Padding(shiny::tags$i(paste0("Version: ", Settings$VersionN)),
                             side = "horizontal"),
      shiny::tags$div(class = "GitHubIcon",
                      shiny::a(shinyMobile::f7Icon("logo_github", style = "font-size: 35px"),
                               href = "https://github.com/PeterM74/TallawongCarparkMonitor")
      )
      
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
          
          shinyMobile::f7Padding(shiny::h2("Tallawong parking", 
                                           style = paste0("color: ", Settings$ColourTheme), 
                                           .noWS = "after"), side = "left"),
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
          
          shinyMobile::f7Padding(shiny::h2("Park breakdown", 
                                           style = paste0("color: ", Settings$ColourTheme), 
                                           .noWS = "after"), side = "left"),
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
          
          ## P1
          shinyMobile::f7Padding(shinyMobile::f7Card(
            
            shiny::selectInput("HistoricalDateType", label = "Date type:",
                               choices = unique(Settings$HistoricalData$FinalDayClassification),
                               selected = "Regular day"),
            
            shiny::h2("P1", 
                      style = paste0("color: ", Settings$ColourTheme), 
                      .noWS = "after"),
            
            plotly::plotlyOutput("HistoricalRasterPlotP1",
                                 width = "100%",
                                 height = "60vh"),
            
            shiny::img(src = "PlotLegend.png", style = "display: block; margin-left: auto; margin-right: auto; width: 80vw; max-width: 10cm;")
            
          ), side = NULL),
          
          ## P2
          shinyMobile::f7Padding(shinyMobile::f7Card(

            shiny::h2("P2", 
                      style = paste0("color: ", Settings$ColourTheme), 
                      .noWS = "after"),
            
            plotly::plotlyOutput("HistoricalRasterPlotP2",
                                 width = "100%",
                                 height = "60vh"),
            
            shiny::img(src = "PlotLegend.png", style = "display: block; margin-left: auto; margin-right: auto; width: 80vw; max-width: 10cm;")
            
          ), side = NULL),
          
          ## P3
          shinyMobile::f7Padding(shinyMobile::f7Card(

            shiny::h2("P3", 
                      style = paste0("color: ", Settings$ColourTheme), 
                      .noWS = "after"), 
            
            plotly::plotlyOutput("HistoricalRasterPlotP3",
                                 width = "100%",
                                 height = "60vh"),
            
            shiny::img(src = "PlotLegend.png", style = "display: block; margin-left: auto; margin-right: auto; width: 80vw; max-width: 10cm;")
            
          ), side = NULL)
          
        ),
        
      ),
      swipeable = TRUE, animated = FALSE
      
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
    shinyMobile::f7Padding(shinyMobile::f7Table(TallawongTable),
                           side = "horizontal")
  })
  
  
  
  # Historical page elements -----
  ## Summary data
  MasterHistoricalData <- Settings$HistoricalData %>%
    dplyr::left_join(TallawongTable %>%
                       dplyr::select(Park, Total),
                     by = c("FacilityNameShort" = "Park"),
                     relationship = "many-to-one") %>%
    dplyr::mutate(AvailablePercentage = fWinsorise(BootMedian / Total, min = 0, max = 1),
                  CI95Percentage = paste0("(",
                                          scales::percent(fWinsorise(LowerCI / Total, min = 0, max = 1),
                                                          accuracy = 0.1),
                                          "-",
                                          scales::percent(fWinsorise(UpperCI / Total, min = 0, max = 1),
                                                          accuracy = 0.1),
                                          ")"),
                  Percent = paste(scales::percent(AvailablePercentage, accuracy = 0.1), CI95Percentage),
                  Day = factor(stringr::str_sub(Day, end = 3), levels = stringr::str_sub(levels(Day), end = 3),
                               ordered = TRUE))
  ## Summary raster charts
  output$HistoricalRasterPlotP1 <- plotly::renderPlotly({
    
    MasterHistoricalData %>%
      dplyr::filter(FinalDayClassification == input$HistoricalDateType &
                      FacilityNameShort == "P1") %>%
      fBuildSummaryHistoricalRasterPlot(DateType = input$HistoricalDateType,
                                        ParkType = "P1",
                                        Settings = Settings)
    
  })
  output$HistoricalRasterPlotP2 <- plotly::renderPlotly({
    
    MasterHistoricalData %>%
      dplyr::filter(FinalDayClassification == input$HistoricalDateType &
                      FacilityNameShort == "P2") %>%
      fBuildSummaryHistoricalRasterPlot(DateType = input$HistoricalDateType,
                                        ParkType = "P2",
                                        Settings = Settings)
    
  })
  output$HistoricalRasterPlotP3 <- plotly::renderPlotly({
    
    MasterHistoricalData %>%
      dplyr::filter(FinalDayClassification == input$HistoricalDateType &
                      FacilityNameShort == "P3") %>%
      fBuildSummaryHistoricalRasterPlot(DateType = input$HistoricalDateType,
                                        ParkType = "P3",
                                        Settings = Settings)
    
  })
  
  
}

shinyApp(ui, server)
