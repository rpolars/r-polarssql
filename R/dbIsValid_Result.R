#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_polarssql_result <- function(dbObj, ...) {
  inherits(dbObj@query_plan, "LazyFrame")
}

#' @rdname DBI
#' @export
setMethod("dbIsValid", "polarssql_result", dbIsValid_polarssql_result)
