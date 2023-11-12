builtin_connection <- new.env(parent = emptyenv())


#' Get the default connection
#'
#' Get the default built-in connection.
#' @return A polarssql connection object
#' @export
#' @examplesIf polars::pl$polars_info()$features$sql
#' polarssql_default_connection()
#'
#' # Register a Table
#' polarssql_register(mtcars = mtcars)
#'
#' polarssql_default_connection()
#'
#' # Clean up
#' polarssql_unregister("mtcars")
#'
#' polarssql_default_connection()
polarssql_default_connection <- function() {
  if (!exists("con", builtin_connection) || !dbIsValid(builtin_connection$con)) {
    builtin_connection$con <- dbConnect(polarssql())
  }

  builtin_connection$con
}
