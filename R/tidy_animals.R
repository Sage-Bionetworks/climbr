#' Tidy the metadata returned by the API
#'
#' @param data The output response object from [get_animals()] or
#'   [get_animals_by_job()]
#' @param include_params Boolean indicating if query parameters should be added
#'   as columns to the resulting data frame. This is useful for appending the
#'   `jobNumber` to the resulting data frame.
#' @return A tidy data frame containing metadata on the animals
#' @importFrom dplyr %>%
#' @importFrom roomba replace_null
#' @export
#'
#' @examples
#' \dontrun{
#' r <- get_animals()
#' tidy_animals(r)
#' }
#'
tidy_animals <- function(data, include_params = TRUE) {
  UseMethod("tidy_animals")
}

#' @export
tidy_animals.response <- function(data, include_params = TRUE) {
  params <- urltools::param_get(data$url)

  data <- httr::content(data)
  data <- data[["value"]]
  data <- lapply(data, list_to_animal_df) %>%
    dplyr::bind_rows()

  ## Rename columns
  names(data) <- gsub(
    pattern = "(.+)\\.(.+)$",
    replacement = "\\2",
    names(data)
  )

  if (isTRUE(include_params)) {
    params <- do.call(rbind, replicate(nrow(data), params, simplify = FALSE))
    data <- cbind(data, params)
  }

  tibble::as_tibble(data)
}

#' Ensure that the data retrieved from the CLIMB API has all the necessary
#' columns
#'
#' If fields have no data, they're not returned by the CLIMB API, which can lead
#' to missing columns if all the animals returned by a query have missing values
#' in that field. `xomplete_job_columns()` ensures that all columns are present
#' (and populated with `NA` if there is no data).
#'
#' @param data Output of [tidy_animals()]
#' @return A data frame containing all columns returned by the CLIMB Get Animals
#'   By Job API
#' @export
#'
#' @examples
#' \dontrun{
#' r <- get_animals()
#' dat <- tidy_animals(r)
#' complete_job_columns(dat)
#' }
#'
complete_job_columns <- function(data) {
  data[, setdiff(pkgenv$animals_by_job_headers, names(data))] <- NA
  data
}

list_to_animal_df <- function(x) {
  x <- roomba::replace_null(x) # replace NULLs with NAs so they aren't dropped by unlist
  tibble::as_tibble(as.list(unlist(x)))
}

# Column names that should be present in Get Animals By Job
pkgenv <- new.env()
pkgenv$animals_by_job_headers <- c(
  "CommonName",
  "LineName",
  "Identifier",
  "ExternalIdentifier",
  "CurrentLocationPath",
  "AnimalStatus",
  "Sex",
  "AnimalName",
  "DateBorn",
  "DateExit",
  "PhysicalMarker",
  "Comments",
  "MaterialOrigin",
  "Generation",
  "AnimalMatingStatus",
  "MatingID",
  "BirthID",
  "jobNumber"
)
