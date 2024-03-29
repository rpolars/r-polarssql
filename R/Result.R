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

polarssql_result <- function(
    connection,
    statement) {
  stopifnot(dbIsValid(connection))

  env <- new.env(parent = emptyenv())
  env$rows_fetched <- 0
  env$rows_affected <- 0

  if (is.null(statement)) {
    return(
      new("polarssql_result",
        connection = connection,
        env = env
      )
    )
  }

  env$query_plan <- connection@env$context$execute(statement)
  env$resultset <- env$query_plan$collect() # polars DataFrame
  env$closed <- FALSE

  new("polarssql_result",
    connection = connection,
    statement = statement,
    env = env
  )
}
