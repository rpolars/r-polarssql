#' @rdname DBI
#' @inheritParams methods::show
#' @usage NULL
show_polars_sql_driver <- function(object) {
  cat("<polars_sql_driver>\n")
  # TODO: Print more details

  invisible(NULL)
}
#' @rdname DBI
#' @export
setMethod("show", "polars_sql_driver", show_polars_sql_driver)
