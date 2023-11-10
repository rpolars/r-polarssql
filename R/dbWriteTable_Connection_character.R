#' @rdname DBI
#' @inheritParams DBI::dbWriteTable
#' @param overwrite Allow overwriting the destination table. Cannot be
#'   `TRUE` if `append` is also `TRUE`.
#' @usage NULL
dbWriteTable_polars_sql_connection_character_data.frame <- function(
    conn, name, value, overwrite = FALSE, ...) {
  polarssql_register(conn, "{name}" := value, overwrite = overwrite) # nolint: object_name_linter.
}

#' @rdname DBI
#' @export
setMethod(
  "dbWriteTable",
  c("polars_sql_connection", "character", "data.frame"),
  dbWriteTable_polars_sql_connection_character_data.frame
)
