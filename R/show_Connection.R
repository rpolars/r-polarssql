#' @rdname DBI
#' @inheritParams methods::show
#' @usage NULL
show_polarssql_connection <- function(object) {
  cat("<polarssql_connection>\n")
  cat("  tables: ", object@context$tables(), "\n")

  invisible(NULL)
}
#' @rdname DBI
#' @export
setMethod("show", "polarssql_connection", show_polarssql_connection)
