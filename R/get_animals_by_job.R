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
#' r <- get_animals_by_job("<token>", job = "6655")
#' content(r)
#' }
get_animals_by_job <- function(token, job) {
  httr::GET(
    url = "https://climb.azure-api.net/animals/copy-5b0f3-of-/get-by-job-number",
    httr::add_headers(Authorization = paste("Bearer", token, sep = " ")),
    query = list(jobNumber = job)
  )
}
