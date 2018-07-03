context("tidy_animals")

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
