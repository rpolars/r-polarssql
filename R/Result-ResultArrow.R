#' @include Connection.R
NULL

#' @rdname DBI
#' @export
setClass(
  "polarssql_result",
  contains = "DBIResult",
  slots = list(
    connection = "polarssql_connection",
    statement = "character",
    env = "environment"
  )
)


#' @rdname DBI
#' @export
setClass(
  "polarssql_result_arrow",
  contains = "DBIResultArrow",
  slots = list(
    connection = "polarssql_connection",
    statement = "character",
    env = "environment"
  )
)


polarssql_result_inner <- function(
    connection,
    statement,
    ...,
    class_name) {
  stopifnot(dbIsValid(connection))

  env <- new.env(parent = emptyenv())
  env$rows_fetched <- 0
  env$rows_affected <- 0

  if (is.null(statement)) {
    return(
      new(class_name,
        connection = connection,
        env = env
      )
    )
  }

  env$query_plan <- connection@env$context$execute(statement, eager = FALSE)
  env$resultset <- env$query_plan$collect() # polars DataFrame
  env$closed <- FALSE

  new(class_name,
    connection = connection,
    statement = statement,
    env = env
  )
}


polarssql_result <- function(
    connection,
    statement) {
  polarssql_result_inner(connection, statement, class_name = "polarssql_result")
}


polarssql_result_arrow <- function(
    connection,
    statement) {
  polarssql_result_inner(connection, statement, class_name = "polarssql_result_arrow")
}
