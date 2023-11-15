#' @include Driver.R
NULL


polarssql_connection <- function() {
  env <- new.env(parent = emptyenv())
  env$context <- pl$SQLContext()
  env$closed <- FALSE

  new(
    "polarssql_connection",
    env = env
  )
}

#' @rdname DBI
#' @export
setClass(
  "polarssql_connection",
  contains = "DBIConnection",
  slots = list(
    env = "environment"
  )
)

#' @export
DBI::dbIsReadOnly

#' @export
DBI::dbQuoteLiteral

#' @export
DBI::dbUnquoteIdentifier

#' @export
DBI::dbGetQuery

#' @export
DBI::dbExecute

#' @export
DBI::dbReadTable

#' @export
DBI::dbCreateTable

#' @export
DBI::dbAppendTable

#' @export
DBI::dbListObjects

#' @export
DBI::dbWithTransaction
