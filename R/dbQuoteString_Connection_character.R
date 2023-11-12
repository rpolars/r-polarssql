#' @rdname DBI
#' @inheritParams DBI::dbQuoteString
#' @usage NULL
dbQuoteString_polarssql_connection_character <- function(conn, x, ...) {
  # Optional
  getMethod("dbQuoteString", c("DBIConnection", "character"), asNamespace("DBI"))(conn, x, ...)
}


#' @rdname DBI
#' @export
setMethod(
  "dbQuoteString",
  c("polarssql_connection", "character"),
  dbQuoteString_polarssql_connection_character
)
