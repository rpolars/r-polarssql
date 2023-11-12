#' @rdname DBI
#' @inheritParams DBI::dbQuoteIdentifier
#' @usage NULL
dbQuoteIdentifier_polarssql_connection_character <- function(conn, x, ...) {
  # Optional
  getMethod("dbQuoteIdentifier", c("DBIConnection", "character"), asNamespace("DBI"))(conn, x, ...)
}


#' @rdname DBI
#' @export
setMethod(
  "dbQuoteIdentifier",
  c("polarssql_connection", "character"),
  dbQuoteIdentifier_polarssql_connection_character
)
