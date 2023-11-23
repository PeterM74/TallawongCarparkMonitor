fFormatParkName <- function(Name, Type) {
  
  if (Type == "Full") {
    
    dplyr::case_when(
      
      stringr::str_starts(Name, pattern = "Tallawong") ~ stringr::str_extract(Name, pattern = "(?<=Tallawong ).*"),
        TRUE ~ Name
      
    )
    
  } else if (Type == "Short") {
    
    dplyr::case_when(
      
      stringr::str_starts(Name, pattern = "Tallawong") ~ stringr::word(Name, start = 2L),
        TRUE ~ Name
      
    )
    
  }
  
}
