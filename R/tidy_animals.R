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


list_to_animal_df <- function(x) {
  x <- roomba::replace_null(x) # replace NULLs with NAs so they aren't dropped by unlist
  tibble::as_tibble(as.list(unlist(x)))
}
