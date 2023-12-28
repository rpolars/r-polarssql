#' @rdname DBI
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_polarssql_result <- function(res, ...) {
  res@env$rows_fetched <- 0
  res@env$rows_affected <- 0
  res@env$closed <- TRUE
  res@env$query_plan <- pl$LazyFrame()

  # Release the polars DataFrame
  .pr$DataFrame$drop_all_in_place(res@env$resultset)

  invisible(TRUE)
}


#' @rdname DBI
#' @export
setMethod("dbClearResult", "polarssql_result", dbClearResult_polarssql_result)


#' @rdname DBI
#' @export
setMethod("dbClearResult", "polarssql_result_arrow", dbClearResult_polarssql_result)
