#' @rdname DBI
#' @inheritParams DBI::dbSendQuery
#' @usage NULL
dbSendQuery_polarssql_connection_character <- function(conn, statement, ...) {
  polarssql_result(connection = conn, statement = statement)
}


#' @rdname DBI
#' @export
setMethod("dbSendQuery", c("polarssql_connection", "character"), dbSendQuery_polarssql_connection_character)
