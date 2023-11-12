#' @rdname DBI
#' @inheritParams DBI::dbWriteTable
#' @param overwrite Allow overwriting the destination table. Cannot be
#'   `TRUE` if `append` is also `TRUE`.
#' @usage NULL
dbWriteTable_polarssql_connection_character_data.frame <- function(
    conn, name, value, overwrite = FALSE, ...) {
  polarssql_register("{name}" := value, conn = conn, overwrite = overwrite) # nolint: object_name_linter.
}

#' @rdname DBI
#' @export
setMethod(
  "dbWriteTable",
  c("polarssql_connection", "character", "data.frame"),
  dbWriteTable_polarssql_connection_character_data.frame
)
