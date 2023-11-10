#' @rdname DBI
#' @inheritParams methods::show
#' @usage NULL
show_polars_sql_result <- function(object) {
  cat("<polars_sql_result>\n")
  cat("  statement:    ", object@statement, "\n")
  cat("  rows fetched: ", object@env$rows_fetched, "\n")

  invisible(NULL)
}

#' @rdname DBI
#' @export
setMethod("show", "polars_sql_result", show_polars_sql_result)
