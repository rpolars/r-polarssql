#' @include Connection.R
NULL

setOldClass(
  c("LazyFrame", "externalptr")
)

#' @rdname DBI
#' @export
setClass(
  "polars_sql_result",
  contains = "DBIResult",
  slots = list(
    connection = "polars_sql_connection",
    statement = "character",
    env = "environment",
    query_plan = "LazyFrame"
  )
)

polars_sql_result <- function(
    connection,
    statement) {
  env <- new.env(parent = emptyenv())
  env$rows_fetched <- 0
  env$rows_want_to_fetch <- 0
  env$rows_affected <- 0

  if (is.null(statement)) {
    return(
      new("polars_sql_result",
        connection = connection,
        env = env
      )
    )
  }

  query_plan <- connection@context$execute(statement, eager = FALSE)

  new("polars_sql_result",
    connection = connection,
    statement = statement,
    env = env,
    query_plan = query_plan
  )
}
