#' @rdname DBI
#' @inheritParams methods::show
#' @usage NULL
show_polars_sql_connection <- function(object) {
  cat("<polars_sql_connection>\n")
  cat("  tables: ", object@context$tables(), "\n")

  invisible(NULL)
}
#' @rdname DBI
#' @export
setMethod("show", "polars_sql_connection", show_polars_sql_connection)
