#' @rdname DBI
#' @inheritParams DBI::dbDisconnect
#' @usage NULL
dbDisconnect_polars_sql_connection <- function(conn, ...) {
  if (!dbIsValid(conn)) {
    warning("Connection already closed.", call. = FALSE)
  }

  # TODO: Free resources
  invisible(TRUE)
}


#' @rdname DBI
#' @export
setMethod("dbDisconnect", "polars_sql_connection", dbDisconnect_polars_sql_connection)
