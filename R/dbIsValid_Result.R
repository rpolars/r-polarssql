#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_polarssql_result <- function(dbObj, ...) {
  valid <- FALSE

  if (!isFALSE(dbObj@env$closed)) {
    return(valid)
  }

  tryCatch(
    {
      valid <- !is_null_external_pointer(dbObj@env$query_plan)
    },
    error = function(c) {}
  )

  valid
}

#' @rdname DBI
#' @export
setMethod("dbIsValid", "polarssql_result", dbIsValid_polarssql_result)
