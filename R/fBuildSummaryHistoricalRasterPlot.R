fBuildSummaryHistoricalRasterPlot <- function(HistoricalData, DateType, ParkType, Settings) {
  
  PlotData <- HistoricalData %>%
    dplyr::mutate(Time = factor(forcats::as_factor(Time), ordered = TRUE)) %>%
    ggplot(aes(x = Day, y = Time)) +
    geom_raster(aes(fill = AvailablePercentage, label = Percent)) +
    scale_x_discrete(expand = expansion()) +
    scale_y_discrete(breaks = paste0(stringr::str_pad(0:23, side = "left", pad = "0", width = 2), ":00")) +
    scale_fill_continuous(breaks = seq(0, 1, 0.25), labels = paste0(seq(0, 100, 25), "%"), limits = c(0, 1),
                          name = NULL) +
    labs(x = NULL, y = "Time", 
         title = paste0("Parking availability in ", ParkType)) +
    theme(legend.position = "none")
  
  plotly::ggplotly(PlotData,
                   tooltip = c("x", "y", "label"))
  
}
