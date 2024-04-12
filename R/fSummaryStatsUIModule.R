fSummaryStatsUIModule <- function(id, Name, Settings) {  # https://mastering-shiny.org/scaling-modules.html#module-basics
  
  shiny::tagList(
    
    shinyMobile::f7Align(shiny::h2(Name, 
                                   style = paste0("color: ", Settings$ColourTheme, "; margin-block-start: 0em; margin-block-end: 0em;"), 
                                   .noWS = "after"), 
                         side = "center"),
    shiny::div(c3::c3Output(NS(id, "SummaryGauge")),
               style = paste0("margin: auto;"))
    # shinyMobile::f7Align(c3::c3Output(NS(id, "SummaryGauge")), 
    #                      side = "right")
    
  )
  
}
