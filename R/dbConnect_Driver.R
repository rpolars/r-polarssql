#' @rdname DBI
#' @inheritParams DBI::dbConnect
#' @usage NULL
dbConnect_polars_sql_driver <- function(drv, ...) {
  polars_sql_connection()
}

#' @rdname DBI
#' @export
setMethod("dbConnect", "polars_sql_driver", dbConnect_polars_sql_driver)
