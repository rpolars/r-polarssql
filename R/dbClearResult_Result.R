#' @rdname DBI
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_polarssql_result <- function(res, ...) {
  res@env$rows_fetched <- 0
  res@env$rows_affected <- 0
  res@env$query_plan <- pl$LazyFrame()
  # TODO: Remove resultset by https://github.com/pola-rs/r-polars/pull/504
  res@env$resultset <- res@env$query_plan$collect()

  invisible(TRUE)
}

#' @rdname DBI
#' @export
setMethod("dbClearResult", "polarssql_result", dbClearResult_polarssql_result)
