fSummaryStatsServerModule <- function(id, RequestData, Settings) {
  
  moduleServer(id, function(input, output, session) {
    
    GaugeData <- c3::c3(data.frame(Capacity = round(RequestData$PercAvail * 100, 1)))
    
    output$SummaryGauge <- c3::renderC3(
      
      c3::c3_gauge(GaugeData,
                   label = list(format = htmlwidgets::JS("function ModifyOutput(value) {return value < 5 ? '<5%' : value+'%';}")),
                   min = 0, max = 100, 
                   pattern = colorRampPalette(Settings$GaugeColours)(9),
                   threshold = list(unit = "value",
                                    max = 100,
                                    values = c(5, 10, 20, 30, 40, 50, 60, 70, 100))) %>%
        c3::legend(hide = TRUE)

    )
    
  })
  
}
