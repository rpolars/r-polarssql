#' Execute SQL query
#'
#' @param sql A SQL string.
#' @inherit polars::as_polars_lf return
#' @inheritParams polarssql_register
#' @export
#' @examples
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
