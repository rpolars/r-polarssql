#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_polars_sql_connection <- function(dbObj, ...) {
  valid <- FALSE

  tryCatch(
    {
      dbObj@context$execute("show tables")
      valid <- TRUE
    },
    error = function(c) {}
  )

  valid
}

#' @rdname DBI
#' @export
setMethod("dbIsValid", "polars_sql_connection", dbIsValid_polars_sql_connection)
