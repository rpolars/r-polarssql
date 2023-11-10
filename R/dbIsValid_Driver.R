#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_polars_sql_driver <- function(dbObj, ...) {
  valid <- FALSE

  tryCatch(
    {
      con <- dbConnect(dbObj)
      con@context$execute("show tables")
      valid <- TRUE
    },
    error = function(c) {
    }
  )

  valid
}

#' @rdname DBI
#' @export
setMethod("dbIsValid", "polars_sql_driver", dbIsValid_polars_sql_driver)
