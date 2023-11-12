builtin_connection <- new.env(parent = emptyenv())


#' Get the default connection
#'
#' Get the default built-in connection.
#' @return A polarssql connection object
#' @export
#' @examples
#' \dontshow{
#' .old_wd <- setwd(tempdir())
#' }
#' polars::pl$LazyFrame(mtcars)$sink_parquet("mtcars.parquet")
#'
#' query <- "SELECT * FROM read_parquet('mtcars.parquet') LIMIT 5"
#' con <- polarssql_default_connection()
#'
#' polarssql_query(query, conn = con, result_type = "polars_df")
#' \dontshow{
#' setwd(.old_wd)
#' }
polarssql_default_connection <- function() {
  if (!exists("con", builtin_connection)) {
    con <- dbConnect(polarssql())
    builtin_connection$con <- con
  }

  builtin_connection$con
}
