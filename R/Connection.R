#' @include Driver.R
NULL

setOldClass(
  c("RPolarsSQLContext", "externalptr")
)

polars_sql_connection <- function() {
  new(
    "polars_sql_connection",
    context = pl$SQLContext()
  )
}

#' @rdname DBI
#' @export
setClass(
  "polars_sql_connection",
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
