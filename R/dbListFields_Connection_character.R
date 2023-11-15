#' @rdname DBI
#' @inheritParams DBI::dbListFields
#' @usage NULL
dbListFields_polarssql_connection_character <- function(conn, name, ...) {
  if (length(name) != 1L) {
    stop("Can only have a single name argument")
  }

  stopifnot(dbIsValid(conn))

  query <- paste0("SELECT * FROM ", dbQuoteIdentifier(conn, name))

  conn@env$context$execute(query, eager = FALSE)$columns
}


#' @rdname DBI
#' @export
setMethod("dbListFields", c("polarssql_connection", "character"), dbListFields_polarssql_connection_character)
