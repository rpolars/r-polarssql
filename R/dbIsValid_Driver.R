#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_polarssql_driver <- function(dbObj, ...) {
  valid <- FALSE

  tryCatch(
    {
      con <- dbConnect(dbObj)
      valid <- dbIsValid(con)
    },
    error = function(c) {
    }
  )

  valid
}

#' @rdname DBI
#' @export
setMethod("dbIsValid", "polarssql_driver", dbIsValid_polarssql_driver)
