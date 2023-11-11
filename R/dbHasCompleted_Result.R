#' @rdname DBI
#' @inheritParams DBI::dbHasCompleted
#' @usage NULL
dbHasCompleted_polarssql_result <- function(res, ...) {
  res@env$rows_want_to_fetch > res@env$rows_fetched
}


#' @rdname DBI
#' @export
setMethod("dbHasCompleted", "polarssql_result", dbHasCompleted_polarssql_result)
