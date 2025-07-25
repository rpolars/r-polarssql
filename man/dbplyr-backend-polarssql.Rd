% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pkg-dbplyr.R
\name{dbplyr-backend-polarssql}
\alias{simulate_polarssql}
\alias{tbl_polarssql}
\title{polarssql backend for dbplyr}
\usage{
simulate_polarssql()

tbl_polarssql(df, name = deparse(substitute(df)), ..., overwrite = FALSE)
}
\arguments{
\item{df}{Data frame to copy}

\item{name}{Name of table in database: defaults to a random name that's
unlikely to conflict with an existing table.}

\item{...}{Ignored.}

\item{overwrite}{If \code{TRUE}, overwrite the existing table which has the same name.
If not \code{TRUE} (default), skip writing a table if it already exists.}
}
\description{
Use \code{\link[=simulate_polarssql]{simulate_polarssql()}} with \code{\link[dbplyr:tbl_lazy]{dbplyr::tbl_lazy()}} or
\code{\link[dbplyr:tbl_lazy]{dbplyr::lazy_frame()}} to see simulated SQL without
converting to live access.
\code{\link[=tbl_polarssql]{tbl_polarssql()}} is similar to \code{\link[dbplyr:memdb_frame]{dbplyr::tbl_memdb()}}, but the backend is
Polars instead of SQLite.
It uses \code{\link[=polarssql_default_connection]{polarssql_default_connection()}} as the DBI connection.
}
\examples{
\dontshow{if (rlang::is_installed("dbplyr")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
library(dplyr, warn.conflicts = FALSE)

# Test connection shows the SQL query.
dbplyr::tbl_lazy(mtcars, simulate_polarssql(), name = "mtcars") |>
  filter(cyl == 4) |>
  arrange(desc(mpg)) |>
  select(contains("c")) |>
  head(n = 3)

# Actual polarssql connection shows the Polars naive plan (LazyFrame).
tbl_polarssql(mtcars) |>
  filter(cyl == 4) |>
  arrange(desc(mpg)) |>
  select(contains("c")) |>
  head(n = 3)

# Unlike other dbplyr backends, `compute` has a special behavior.
# It returns a polars DataFrame.
tbl_polarssql(mtcars) |>
  filter(cyl == 4) |>
  arrange(desc(mpg)) |>
  select(contains("c")) |>
  head(n = 3) |>
  compute()
\dontshow{\}) # examplesIf}
}
