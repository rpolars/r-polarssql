#' @include polarssql-package.R
NULL

#' DBI methods
#'
#' Implementations of pure virtual functions defined in the `DBI` package.
#' @name DBI
NULL

#' polarssql driver
#'
#' [polarssql()] creates a DBI driver instance.
#'
#' @export
#' @examplesIf polars::polars_info()$features$sql
#' polarssql()
polarssql <- function() {
  if (!isTRUE(polars::polars_info()$features$sql)) {
    stop("Please install the `polars` package with the sql feature.")
  }

  new("polarssql_driver")
}

#' @rdname DBI
#' @export
setClass(
  "polarssql_driver",
  contains = "DBIDriver",
  slots = list()
)

#' @export
DBI::dbCanConnect

#' @export
DBI::Id
