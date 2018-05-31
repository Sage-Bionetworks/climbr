# climbr

Access mouse metadata from the CLIMB API.

## Installation

``` r
devtools::install_github("Sage-Bionetworks/climbr")
```

More information about the CLIMB API can be found on the
[developer portal](https://climb.portal.azure-api.net/) 
(you'll need to sign up for an account to access documentation on the various
API endpoints).

## Usage

### Authentication

First, register for an account with [CLIMB](https://climb.bio/). Note: this is
different than the CLIMB developer portal. You'll use your CLIMB credentials,
_not_ your developer portal credentials, to access data via the API.

To access the API, you need an access token:

``` r
token <- get_climb_token("<username>", "<password>")
```

### Accessing data

Get animals:

``` r
# Using the token generated above
get_animals(token)
```

Get animals by job:

``` r
get_animals_by_job(token, job = "6655")
```

Both of the above functions return a `response` object. To turn this
into a tidy frame, us the `tidy_animals()` function.

``` r
r <- get_animals_by_job(token, job = "6655")
tidy_animals(r)
```
