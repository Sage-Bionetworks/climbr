# climbr

 <!-- badges: start -->
[![Travis build status](https://travis-ci.org/Sage-Bionetworks/climbr.svg?branch=master)](https://travis-ci.org/Sage-Bionetworks/climbr)
[![Lifecycle: dormant](https://img.shields.io/badge/lifecycle-dormant-blue.svg)](https://www.tidyverse.org/lifecycle/#dormant)
<!-- badges: end -->

Access mouse metadata from the Climb API.

## Installation

``` r
devtools::install_github("Sage-Bionetworks/climbr")
```

More information about the Climb API can be found on the
[developer portal](https://climb.portal.azure-api.net/) 
(you'll need to sign up for an account to access documentation on the various
API endpoints).

## Usage

### Authentication

First, register for an account with [Climb](https://climb.bio/). Note: this is
different than the Climb developer portal. You'll use your Climb credentials,
_not_ your developer portal credentials, to access data via the API.

To access the API, you need an access token:

``` r
token <- get_climb_token("<username>", "<password>")
```

Access tokens are returned as a character string with an attribute containing
expiration date.

### Accessing data

Get animals:

``` r
# Using the token generated above
get_animals(token)
```

Get animals by job:

``` r
get_animals_by_job(job = "6655", token = token)
```

Get animals by cohort:

```r
get_animals_by_cohort(cohort = "5xFAD 6mo Tissue", token)
```

The above functions return a `response` object. To turn this into a data frame,
use the `make_animals_df()` function.

``` r
r <- get_animals_by_job(job = "6655", token = token)
make_animals_df(r)
```

`tidy_animals_by_job()` does a little extra work to ensure some expected fields
in the `get_animals_by_job()` response are included (and populated with `NA` if
there was no data from these fields in the response).

### Authentication: advanced

Access tokens are good for one day, after which you'll need to generate a new
one. To avoid having to repeatedly type your password to authenticate, you can
use the [secret](https://github.com/gaborcsardi/secret) package to store your
credentials in a vault. Here's an example of how this could run (you'll need to
supply your own paths, keys, and credentials):

```r
library("secret")

## Create a vault
vault <- "/path/to/your/vault.vault"
create_vault(vault)

## Add yourself as a user to the vault
my_public_key <- "/path/to/your/ssh/public/key.pub" # e.g. "~/.ssh/id_rsa.pub"
add_user("your@email.address", my_public_key, vault)

## Save Climb login object to your vault
climb_login <- c(username = "yourusername", password = "yourpassword")

add_secret(
  "climb_login",
  climb_login,
  users = "your@email.address",
  vault = vault
)
```


You can retrieve the object with `get_secret()`:

```r
climb_login <- get_secret(
  "climb_login",
  key = "~/.ssh/id_rsa", # your private key here
  vault = vault
)
```

And then use it in authentication:

```r
token <- get_climb_token(climb_login["username"], climb_login["password"])
```

## Troubleshooting

If you belong to multiple Climb workgroups, when you generate a token your API
requests will be directed to whichever workgroup you most recently logged into
on the web. Therefore if workgroup `A` has a job `my_job`, but you most recently
logged in to workgroup `B`, then `get_animals_by_job(job = "my_job", token = token)`
will not return any data. To get around this, either log in to the appropriate
workgroup before making a request, or create separate accounts for each
workgroup you want to access.

---

Please note that the `climbr` project is released with a [Contributor Code of Conduct](.github/CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.
