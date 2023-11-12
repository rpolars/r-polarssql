#' @rdname DBI
#' @inheritParams DBI::dbListTables
#' @usage NULL
dbListTables_polarssql_connection <- function(conn, ...) {
  stopifnot(dbIsValid(conn))

  conn@context$tables()
}


#' @rdname DBI
#' @export
setMethod("dbListTables", "polarssql_connection", dbListTables_polarssql_connection)
