#' @rdname DBI
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_polars_sql_result <- function(res, ...) {
  res@env$rows_fetched <- 0
  res@env$rows_want_to_fetch <- 0
  res@env$rows_affected <- 0

  res@statement <- NA_character_
  res@query_plan <- pl$LazyFrame()

  invisible(TRUE)
}

#' @rdname DBI
#' @export
setMethod("dbClearResult", "polars_sql_result", dbClearResult_polars_sql_result)
