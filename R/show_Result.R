#' @rdname DBI
#' @inheritParams methods::show
#' @usage NULL
show_polarssql_result <- function(object) {
  cat("<polarssql_result>\n")

  if (dbIsValid(object)) {
    cat("  statement:    ", object@statement, "\n")
    cat("  rows fetched: ", object@env$rows_fetched, "\n")
  } else {
    cat("  Disconnected\n")
  }

  invisible(NULL)
}

#' @rdname DBI
#' @export
setMethod("show", "polarssql_result", show_polarssql_result)
