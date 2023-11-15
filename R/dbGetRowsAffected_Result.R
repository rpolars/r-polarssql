#' @rdname DBI
#' @inheritParams DBI::dbGetRowsAffected
#' @usage NULL
dbGetRowsAffected_polarssql_result <- function(res, ...) {
  stopifnot(dbIsValid(res))

  res@env$rows_affected
}


#' @rdname DBI
#' @export
setMethod("dbGetRowsAffected", "polarssql_result", dbGetRowsAffected_polarssql_result)
