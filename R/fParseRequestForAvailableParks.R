fParseRequestForAvailableParks <- function(Request) {
  
  Spots <- as.integer(Request$spots)
  Taken <- as.integer(Request$occupancy$total)
  Available <- fWinsorise(Spots - Taken, min = 0, max = Spots) %>%
    as.integer()
  
  # Object return
  ReturnList <- list(
    
    Available = Available,
    Taken = Taken,
    Total = Spots,
    PercFull = fWinsorise(Taken/Spots, min = 0, max = 1),
    PercAvail = fWinsorise(Available/Spots, min = 0, max = 1),
    
    FacilityID = Request$facility_id,
    FacilityName = fFormatParkName(Request$facility_name, Type = "Full"),
    FacilityNameShort = fFormatParkName(Request$facility_name, Type = "Short"),
    Date = Request$MessageDate
    
  )
  
  return(ReturnList)
  
}
