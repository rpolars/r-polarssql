#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_polarssql_connection <- function(dbObj, ...) {
  valid <- FALSE

  tryCatch(
    {
      valid <- !is_null_external_pointer(dbObj@context)
    },
    error = function(c) {}
  )

  valid
}

#' @rdname DBI
#' @export
setMethod("dbIsValid", "polarssql_connection", dbIsValid_polarssql_connection)
