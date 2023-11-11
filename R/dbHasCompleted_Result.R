#' @rdname DBI
#' @inheritParams DBI::dbHasCompleted
#' @usage NULL
dbHasCompleted_polarssql_result <- function(res, ...) {
  nrow(res@env$resultset) <= res@env$rows_fetched
}


#' @rdname DBI
#' @export
setMethod("dbHasCompleted", "polarssql_result", dbHasCompleted_polarssql_result)
