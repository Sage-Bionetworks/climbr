#' Get Animals by Cohort
#'
#' Access the Get Animals by Cohort API endpoint and retrieve information on all
#' animals.
#'
#' @inheritParams get_animals
#' @param cohort Cohort name
#' @return Response object returned from the API call
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Insert actual access token
#' r <- get_animals_by_cohort(cohort = "5xFAD 6mo Tissue", "<token>")
#' content(r)
#' }
get_animals_by_cohort <- function(cohort, token) {
  httr::GET(
    url = "https://climb.azure-api.net/animals/get-by-cohort-name",
    httr::add_headers(Authorization = paste("Bearer", token, sep = " ")),
    query = list(cohortName = cohort)
  )
}
