#' Execute SQL query
#'
#' @param sql A SQL string.
#' @inheritParams polarssql_register
#' @return [polars LazyFrame][polars0::LazyFrame_class]
#' @export
#' @examplesIf polars0::polars_info()$features$sql
#' polarssql_register(mtcars = mtcars)
#'
#' query <- "SELECT * FROM mtcars LIMIT 5"
#'
#' # Returns a polars LazyFrame
#' polarssql_query(query)
#'
#' # Clean up
#' polarssql_unregister("mtcars")
polarssql_query <- function(
    sql,
    conn = polarssql_default_connection()) {
  stopifnot(dbIsValid(conn))

  conn@env$context$execute(sql)
}
