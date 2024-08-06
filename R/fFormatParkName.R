fFormatParkName <- function(Name, Type) {
  
  if (Type == "Full") {
    
    dplyr::case_when(
      
      stringr::str_detect(Name, pattern = "At-Grade A") | 
        stringr::str_detect(Name, pattern = "P1") ~ "P1 Car Park",
      stringr::str_detect(Name, pattern = "At-Grade B") | 
        stringr::str_detect(Name, pattern = "P2")  ~ "P2 Car Park",
      stringr::str_detect(Name, pattern = "At-Grade D") | 
        stringr::str_detect(Name, pattern = "P3")  ~ "P3 Car Park",
      stringr::str_starts(Name, pattern = "Tallawong") ~ stringr::str_extract(Name, pattern = "(?<=Tallawong ).*"),
      TRUE ~ Name
      
    )
    
  } else if (Type == "Short") {
    
    dplyr::case_when(
      
      stringr::str_detect(Name, pattern = "At-Grade A") | 
        stringr::str_detect(Name, pattern = "P1") ~ "P1",
      stringr::str_detect(Name, pattern = "At-Grade B") | 
        stringr::str_detect(Name, pattern = "P2") ~ "P2",
      stringr::str_detect(Name, pattern = "At-Grade D")  | 
        stringr::str_detect(Name, pattern = "P3") ~ "P3",
      stringr::str_starts(Name, pattern = "Tallawong") ~ stringr::word(Name, start = 2L),
      TRUE ~ Name
      
    )
    
  }
  
}
