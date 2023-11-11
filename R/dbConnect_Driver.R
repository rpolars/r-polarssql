#' @rdname DBI
#' @inheritParams DBI::dbConnect
#' @usage NULL
dbConnect_polarssql_driver <- function(drv, ...) {
  polarssql_connection()
}

#' @rdname DBI
#' @export
setMethod("dbConnect", "polarssql_driver", dbConnect_polarssql_driver)
