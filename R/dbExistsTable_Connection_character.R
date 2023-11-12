#' @rdname DBI
#' @inheritParams DBI::dbExistsTable
#' @usage NULL
dbExistsTable_polarssql_connection_character <- function(conn, name, ...) {
  if (length(name) != 1L) {
    stop("Can only have a single name argument")
  }

  name %in% dbListTables(conn)
}


#' @rdname DBI
#' @export
setMethod("dbExistsTable", c("polarssql_connection", "character"), dbExistsTable_polarssql_connection_character)
