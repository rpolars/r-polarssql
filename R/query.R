#' Execute SQL query
#'
#' @param result_type The type of result to return.
#' `nanoarrow_array_stream` requires [the nanoarrow package][nanoarrow::nanoarrow-package].
#' @param sql A SQL string.
#' @inheritParams polarssql_register
#' @return One of the following depending on `result_type`:
#' - [polars LazyFrame][polars::LazyFrame_class] (when `result_type = "polars_lf"`, default)
#' - [polars DataFrame][polars::DataFrame_class] (when `result_type = "polars_df"`)
#' - [data.frame] (when `result_type = "data_frame"`)
#' - [nanoarrow_array_stream][nanoarrow::as_nanoarrow_array_stream()]
#' @export
#' @examples
#' con <- dbConnect(polarssql())
#' polarssql_register(con, mtcars = mtcars)
#'
#' query <- "SELECT * FROM mtcars LIMIT 5"
#'
#' # Returns a polars LazyFrame
#' polarssql_query(query, con)
#'
#' # Returns a data.frame
#' polarssql_query(query, con, result_type = "data_frame")
#'
#' # Returns a polars DataFrame
#' polarssql_query(query, con, result_type = "polars_df")
#'
#' # Returns a nanoarrow_array_stream
#' if (requireNamespace("nanoarrow", quietly = TRUE)) {
#'   polarssql_query(query, con, result_type = "nanoarrow_array_stream")
#' }
polarssql_query <- function(
    sql,
    conn = polarssql_default_connection(),
    result_type = c("polars_lf", "polars_df", "data_frame", "nanoarrow_array_stream")) {
  stopifnot(dbIsValid(conn))

  result_type <- match.arg(result_type)

  if (result_type == "nanoarrow_array_stream" && !requireNamespace("nanoarrow", quietly = TRUE)) {
    stop("Please install the `nanoarrow` package to convert to `nanoarrow_array_stream`.")
  }

  lf <- conn@context$execute(sql, eager = FALSE)

  if (result_type == "data_frame") {
    out <- lf |> as.data.frame()
  } else if (result_type == "polars_df") {
    out <- lf$collect()
  } else if (result_type == "nanoarrow_array_stream") {
    out <- lf$collect() |> nanoarrow::as_nanoarrow_array_stream()
  } else {
    out <- lf
  }

  out
}


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
