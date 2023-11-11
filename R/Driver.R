#' @include polarssql-package.R
NULL

#' DBI methods
#'
#' Implementations of pure virtual functions defined in the `DBI` package.
#' @name DBI
NULL

#' polars driver
#'
#' TBD.
#'
#' @export
#' @examples
#' \dontrun{
#' library(DBI)
#' polarssql::polarssql()
#' }
polarssql <- function() {
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
