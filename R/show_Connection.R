#' @rdname DBI
#' @inheritParams methods::show
#' @usage NULL
show_polarssql_connection <- function(object) {
  cat("<polarssql_connection>\n")

  if (dbIsValid(object)) {
    cat("  tables: ", object@env$context$tables(), "\n")
  } else {
    cat("  Disconnected\n")
  }

  invisible(NULL)
}
#' @rdname DBI
#' @export
setMethod("show", "polarssql_connection", show_polarssql_connection)
