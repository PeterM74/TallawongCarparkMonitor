fGetSettings <- function() {
  
  Settings <- list()
  
  # API details
  Settings$APIKey <- Sys.getenv("APIKey")
  Settings$APIRootURL <- "https://api.transport.nsw.gov.au/v1/"
  Settings$APIEndpoints <- list(
    
    Realtime = "carpark",
    History = "carpark/history"
    
  )
  Settings$FacilityIDs <- list(
    
    P1 = 26,
    P2 = 27,
    P3 = 28
    
  )
  
  
  
  # App details
  Settings$VersionN <- "0.1.1"

  
  # App themes
  Settings$ColourTheme <- "#168388"
  Settings$GaugeColours <- c("#D3212C", "#FF681E", "#FF980E", "#069C56", "#006B3D")
  
  
  
  return(Settings)
  
}
