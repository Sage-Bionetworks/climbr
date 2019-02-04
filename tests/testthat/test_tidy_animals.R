context("tidy_animals")

dat <- list(
  odata.metadata = "",
  odata.count = "110",
  value = list(
    list(
      cv_AnimalStatus = list(
        AnimalStatus = "Dead"
      ),
      Birth = list(
        Mating = list(MatingID = "something"),
        BirthID = "X-XXX-XXX"
      ),
      AnimalName = "ABC",
      Comments = NULL
    ),
    list(
      cv_AnimalStatus = list(
        AnimalStatus = "Alive"
      ),
      Birth = list(
        Mating = list(MatingID = "something"),
        BirthID = "X-XXX-XXX"
      ),
      AnimalName = "DEF",
      Comments = NULL
    )
  )
)

dat_json <- jsonlite::toJSON(dat, auto_unbox = TRUE)

## test_that("make_animals_df creates a data frame from response", {

##   webmockr::httr_mock(on = TRUE)

##   stub <- webmockr::stub_request(
##     "get",
##     "https://climb.azure-api.net/animals/get-by-job-number?jobNumber=whatever"
##   ) %>%
##     webmockr::wi_th(
##       headers = list(
##         "Accept" = "application/json, text/xml, application/xml, */*",
##         "Authorization" = "Bearer fake_token"
##       )
##     ) %>%
##   webmockr::to_return(
##     body = dat_json,
##     status = 200,
##     headers = list('Content-Type' = 'application/json; charset=utf-8')
##   )
##   ## Job and token don't matter because this is being mocked
##   r <- get_animals_by_job(job = "whatever", token = "fake_token")

##   animals <- make_animals_df(r)
##   webmockr::httr_mock(on = FALSE)

##   expect_true(is.data.frame(animals))
## })

test_that("list_to_animal_df converts to tibble without losing columns", {
  dat_tbl <- list_to_animal_df(dat[["value"]][[1]])
  expect_true(inherits(dat_tbl, "tbl_df"))
  expect_equal(nrow(dat_tbl), 1)
  expect_true(
    all(
      c(
        "cv_AnimalStatus.AnimalStatus",
        "Comments"
      ) %in% names(dat_tbl)
    )
  )
})

test_that("complete_job_columns returns correct columns", {
  dat <- data.frame(CommonName = "moomin", jobNumber = 5, AnimalName = "betty")
  dat_complete <- complete_job_columns(dat)
  comparison <- setdiff(pkgenv$animals_by_job_headers, names(dat_complete))
  expect_equal(comparison, character(0))
})

test_that("complete_job_columns doesn't drop additional columns", {
  dat <- data.frame(CommonName = "moomin", jobNumber = 5, extraCol = 1)
  dat_complete <- complete_job_columns(dat)
  comparison <- setdiff(names(dat_complete), pkgenv$animals_by_job_headers)
  expect_equal(comparison, "extraCol")
})
