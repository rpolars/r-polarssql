#' @rdname DBI
#' @inheritParams DBI::dbDisconnect
#' @usage NULL
dbDisconnect_polarssql_connection <- function(conn, ...) {
  if (!dbIsValid(conn)) {
    warning("Connection already closed.", call. = FALSE)
  }

  conn@env$context <- pl$SQLContext()
  conn@env$closed <- TRUE

  invisible(TRUE)
}


#' @rdname DBI
#' @export
setMethod("dbDisconnect", "polarssql_connection", dbDisconnect_polarssql_connection)
