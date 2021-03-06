#' Get an access token for the Climb API
#'
#' @inheritParams climb_auth
#' @return An access token, with an attribute `expires` that lists the
#'   expiration date of the token.
#'
#' @export
get_climb_token <- function(username, password) {
  r <- climb_auth(username, password)
  token <- httr::content(r)$access_token
  attr(token, "expires") <- httr::content(r)$.expires
  token
}

#' Authenticate to the Climb API
#'
#' @param username Climb username
#' @param password Climb password
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
  r <- httr::POST(url, body = body, encode = "form")
  r
}
