#' @rdname DBI
#' @inheritParams DBI::dbHasCompleted
#' @usage NULL
dbHasCompleted_polars_sql_result <- function(res, ...) {
  res@env$rows_want_to_fetch > res@env$rows_fetched
}


#' @rdname DBI
#' @export
setMethod("dbHasCompleted", "polars_sql_result", dbHasCompleted_polars_sql_result)
