#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_polars_sql_result <- function(dbObj, ...) {
  inherits(dbObj@query_plan, "LazyFrame")
}

#' @rdname DBI
#' @export
setMethod("dbIsValid", "polars_sql_result", dbIsValid_polars_sql_result)
