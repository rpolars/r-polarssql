#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_polarssql_connection <- function(dbObj, ...) {
  valid <- FALSE

  tryCatch(
    {
      dbObj@context$execute("show tables") # TODO: this may cause segfault
      valid <- TRUE
    },
    error = function(c) {}
  )

  valid
}

#' @rdname DBI
#' @export
setMethod("dbIsValid", "polarssql_connection", dbIsValid_polarssql_connection)
