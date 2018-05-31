#' Get an access token for the CLIMB API
#'
#' @inheritParams climb_auth
#' @return An access token
#'
#' @export
get_climb_token <- function(username, password) {
  r <- climb_auth(username, password)
  httr::content(r)$access_token
}

#' Authenticate to the CLIMB API
#'
#' @param username CLIMB username
#' @param password CLIMB password
#' @return POST response object
#'
#' @export
climb_auth <- function(username, password) {
  body <- list(
    client_id = "Climb.Services",
    grant_type = "password",
    username = username,
    password = password
  )
  url <- "https://climb-admin.azurewebsites.net/token"
  r <- httr::POST(url, body = body, encode = "form", httr::verbose())
  r
}
