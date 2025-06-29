#' @rdname DBI
#' @inheritParams methods::show
#' @usage NULL
show_polarssql_driver <- function(object) {
  cat("<polarssql_driver>\n")
  show(polars0::polars_info())

  invisible(NULL)
}


#' @rdname DBI
#' @export
setMethod("show", "polarssql_driver", show_polarssql_driver)
