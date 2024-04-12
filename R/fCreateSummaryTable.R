fCreateSummaryTable <- function(ListParks, Settings) {
  
  purrr::map(ListParks,
             function(List) {
               
               tibble::tibble(Park = List$FacilityNameShort, 
                              Available = List$Available,
                              Taken = List$Taken,
                              Total = List$Total,
                              Capacity = scales::percent(List$PercAvail, accuracy = 0.1))
               
             }) %>%
    purrr::list_rbind() %>%
    # Add total column
    tibble::add_row(Park = "Total", 
                    Available = sum(.$Available, na.rm = TRUE),
                    Taken = sum(.$Taken, na.rm = TRUE),
                    Total = sum(.$Total, na.rm = TRUE),
                    Capacity = scales::percent(sum(.$Available, na.rm = TRUE) / sum(.$Total, na.rm = TRUE), accuracy = 0.1))
  
}
