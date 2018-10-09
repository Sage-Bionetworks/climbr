#' Get Animals by Job
#'
#' Access the Get Animals by Job API endpoint and retrieve information on all
#' animals.
#'
#' @inheritParams get_animals
#' @param job Job number
#' @return Response object returned from the API call
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Insert actual access token
#' r <- get_animals_by_job(job = "6655", "<token>")
#' content(r)
#' }
get_animals_by_job <- function(job, token) {
  httr::GET(
    url = "https://climb.azure-api.net/animals/get-by-job-number",
    httr::add_headers(Authorization = paste("Bearer", token, sep = " ")),
    query = list(jobNumber = job)
  )
}
