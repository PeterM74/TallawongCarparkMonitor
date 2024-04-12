fCallAPI <- function(RootURL, Endpoint, APIKey, FacilityID) {
  
  Data <- httr2::request(RootURL) %>%
    httr2::req_url_path_append(Endpoint) %>%
    httr2::req_headers(Authorization = paste("apikey", APIKey)) %>%
    httr2::req_url_query(facility = FacilityID) %>%
    httr2::req_perform() %>%
    httr2::resp_body_json()

  return(Data)
  
}
