#' @include Driver.R
NULL

setOldClass(
  c("RPolarsSQLContext", "externalptr")
)

polarssql_connection <- function() {
  new(
    "polarssql_connection",
    context = pl$SQLContext()
  )
}

#' @rdname DBI
#' @export
setClass(
  "polarssql_connection",
  contains = "DBIConnection",
  slots = list(
    context = "RPolarsSQLContext"
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
