#' @include Connection.R
NULL

setOldClass(
  c("LazyFrame", "externalptr")
)

#' @rdname DBI
#' @export
setClass(
  "polarssql_result",
  contains = "DBIResult",
  slots = list(
    connection = "polarssql_connection",
    statement = "character",
    env = "environment",
    query_plan = "LazyFrame"
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

  query_plan <- connection@env$context$execute(statement, eager = FALSE)
  env$resultset <- query_plan$collect() # polars DataFrame

  new("polarssql_result",
    connection = connection,
    statement = statement,
    env = env,
    query_plan = query_plan
  )
}
