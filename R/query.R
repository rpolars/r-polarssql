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
#' @examplesIf polars::pl$polars_info()$features$sql
#' polarssql_register(mtcars = mtcars)
#'
#' query <- "SELECT * FROM mtcars LIMIT 5"
#'
#' # Returns a polars LazyFrame
#' polarssql_query(query)
#'
#' # Returns a data.frame
#' polarssql_query(query, result_type = "data_frame")
#'
#' # Returns a polars DataFrame
#' polarssql_query(query, result_type = "polars_df")
#'
#' # Returns a nanoarrow_array_stream
#' if (requireNamespace("nanoarrow", quietly = TRUE)) {
#'   polarssql_query(query, result_type = "nanoarrow_array_stream")
#' }
#'
#' # Clean up
#' polarssql_unregister("mtcars")
polarssql_query <- function(
    sql,
    conn = polarssql_default_connection(),
    result_type = c("polars_lf", "polars_df", "data_frame", "nanoarrow_array_stream")) {
  stopifnot(dbIsValid(conn))

  result_type <- match.arg(result_type)

  if (result_type == "nanoarrow_array_stream" && !requireNamespace("nanoarrow", quietly = TRUE)) {
    stop("Please install the `nanoarrow` package to convert to `nanoarrow_array_stream`.")
  }

  lf <- conn@env$context$execute(sql, eager = FALSE)

  switch(result_type,
    "polars_lf" = lf,
    "polars_df" = lf$collect(),
    "data_frame" = lf |> as.data.frame(),
    "nanoarrow_array_stream" = lf$collect() |>
      nanoarrow::as_nanoarrow_array_stream()
  )
}
