#' Convert metadata to a data frame
#'
#' Given a response object, converts the animal metadata into a data frame. The
#' result should be relatively tidy if each animal has only one value for every
#' field, but there will be duplicated columns if animals have multiple values
#' for a given field. For example, if an animal is in multiple cohorts, there
#' will be multiple `cohortName` columns
#'
#' @param data The output response object from [get_animals()] or
#'   [get_animals_by_job()]
#' @param include_params Boolean indicating if query parameters should be added
#'   as columns to the resulting data frame. This is useful for appending the
#'   `jobNumber` to the resulting data frame.
#' @return A data frame containing metadata on the animals
#' @importFrom dplyr %>%
#' @importFrom roomba replace_null
#' @export
#'
#' @examples
#' \dontrun{
#' r <- get_animals()
#' make_animals_df(r)
#' }
#'
make_animals_df <- function(data, include_params = TRUE) {
  UseMethod("make_animals_df")
}

#' @export
make_animals_df.response <- function(data, include_params = TRUE) {
  params <- urltools::param_get(data$url)

  data <- httr::content(data)
  data <- data[["value"]]
  data <- lapply(data, list_to_animal_df) %>%
    dplyr::bind_rows()

  ## Rename columns -- matches the last component of the name, e.g. for
  ## $value$cv_ExitReason$ExitReason matches ExitReason.
  names(data) <- gsub(
    pattern = "(.+)\\.([^0-9\\.](.+))$",
    replacement = "\\2",
    names(data)
  )

  if (isTRUE(include_params)) {
    params <- do.call(rbind, replicate(nrow(data), params, simplify = FALSE))
    data <- cbind(data, params)
  }

  tibble::as_tibble(data)
}

#' Tidy the metadata returned by the Get Animals By Job endpoint
#'
#' Does a little extra work beyond `make_animals_df()` to ensure that some
#' expected columns are present.
#'
#' @inheritParams make_animals_df
#' @rdname make_animals_df
#' @export
tidy_animals_by_job <- function(data, include_params = TRUE) {
  UseMethod("make_animals_df_by_job")
}

#' @export
tidy_animals_by_job.response <- function(data, include_params = TRUE) {
  tidy_data <- make_animals_df(data)
  tidy_data <- complete_job_columns(tidy_data)
  tidy_data
}

#' Ensure that the data retrieved from the Climb API has all the necessary
#' columns
#'
#' If fields have no data, they're not returned by the Climb API, which can lead
#' to missing columns if all the animals returned by a query have missing values
#' in that field. `complete_job_columns()` ensures that all expected columns are
#' present (and populated with `NA` if there is no data).
#'
#' @param data Output of [make_animals_df()]
#' @return A data frame containing all columns returned by the Climb Get Animals
#'   By Job API
#' @export
#'
#' @examples
#' \dontrun{
#' r <- get_animals()
#' dat <- make_animals_df(r)
#' complete_job_columns(dat)
#' }
#'
complete_job_columns <- function(data) {
  data[, setdiff(pkgenv$animals_by_job_headers, names(data))] <- NA
  # Reorder columns to ensure the required ones are first, followed by any extras
  data[, c(pkgenv$animals_by_job_headers, setdiff(names(data), pkgenv$animals_by_job_headers))]
}

list_to_animal_df <- function(x) {
  x <- roomba::replace_null(x) # replace NULLs with NAs so they aren't dropped by unlist
  tibble::as_tibble(as.list(unlist(x)), .name_repair = "unique")
}

# Column names that should be present in Get Animals By Job
pkgenv <- new.env()
pkgenv$animals_by_job_headers <- c(
  "Identifier",
  "AnimalName",
  "ExternalIdentifier",
  "CommonName",
  "LineName",
  "StockNumber",
  "CurrentLocationPath",
  "MaterialOrigin",
  "Sex",
  "AnimalStatus",
  "DateBorn",
  "DateExit",
  "ExitReason",
  "PhysicalMarker",
  "Generation",
  "AnimalMatingStatus",
  "MatingID",
  "BirthID",
  "Comments",
  "jobNumber"
)
