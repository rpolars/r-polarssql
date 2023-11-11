#' @rdname DBI
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_polarssql_result <- function(res, ...) {
  res@env$rows_fetched <- 0
  res@env$rows_affected <- 0

  res@statement <- NA_character_
  res@query_plan <- pl$LazyFrame()

  res@env$resultset <- res@query_plan$collect()

  invisible(TRUE)
}

#' @rdname DBI
#' @export
setMethod("dbClearResult", "polarssql_result", dbClearResult_polarssql_result)
