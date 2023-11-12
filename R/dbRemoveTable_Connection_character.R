#' @rdname DBI
#' @param fail_if_missing If `FALSE`, `dbRemoveTable()` succeeds if the
#'   table doesn't exist.
#' @inheritParams DBI::dbRemoveTable
#' @usage NULL
dbRemoveTable_polarssql_connection_character <- function(conn, name, ...,
                                                         fail_if_missing = TRUE) {
  if (length(name) != 1L) {
    stop("Can only have a single name argument")
  }

  if (fail_if_missing && !dbExistsTable(conn, name)) {
    stop("Table '", name, "' doesn't exist")
  }

  suppressMessages(polarssql_unregister(conn, name))
  invisible(TRUE)
}


#' @rdname DBI
#' @export
setMethod("dbRemoveTable", c("polarssql_connection", "character"), dbRemoveTable_polarssql_connection_character)
