#' @rdname DBI
#' @inheritParams DBI::dbSendQuery
#' @usage NULL
dbSendQuery_polars_sql_connection_character <- function(conn, statement, ...) {
  polars_sql_result(connection = conn, statement = statement)
}


#' @rdname DBI
#' @export
setMethod("dbSendQuery", c("polars_sql_connection", "character"), dbSendQuery_polars_sql_connection_character)
