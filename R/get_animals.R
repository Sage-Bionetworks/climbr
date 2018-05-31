#' Get Animals
#'
#' Access the Get Animals API endpoint and retrieve information on all animals.
#'
#' @param token Access token; see [get_climb_token()]
#' @return Response object returned from the API call
#'
#' @export
#'
#' @examples
#' \dontrun{
#' r <- get_animals("<token>") # Insert actual access token
#' content(r)
#' }
get_animals <- function(token) {
  httr::GET(
    url = "https://climb.azure-api.net/animals/copy-5af9d-of-/get",
    httr::add_headers(Authorization = paste("Bearer", token, sep = " "))
  )
}
