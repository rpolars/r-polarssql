#' polarssql backend for dbplyr
#'
#' Use [simulate_polarssql()] with [dbplyr::tbl_lazy()] or
#' [dbplyr::lazy_frame()] to see simulated SQL without
#' converting to live access.
#' @name dbplyr-backend-polarssql
#' @aliases NULL
#' @examplesIf polars::pl$polars_info()$features$sql && rlang::is_installed("dbplyr")
#' library(dplyr, warn.conflicts = FALSE)
#' con <- DBI::dbConnect(polarssql())
#' DBI::dbWriteTable(con, "mtcars", mtcars)
#'
#' tbl(con, "mtcars") |>
#'   filter(cyl == 4) |>
#'   arrange(desc(mpg)) |>
#'   head(n = 3) |>
#'   collect()
#'
#' dbplyr::tbl_lazy(mtcars, simulate_polarssql(), name = "mtcars") |>
#'   filter(cyl == 4) |>
#'   arrange(desc(mpg)) |>
#'   head(n = 3)
#'
#' # Unlike other dbplyr backends, `compute` has a special behavior.
#' # It returns a polars DataFrame or LazyFrame.
#' tbl(con, "mtcars") |>
#'   filter(cyl == 4) |>
#'   arrange(desc(mpg)) |>
#'   head(n = 3) |>
#'   compute()
NULL


#' @param ... Any parameters to be forwarded
#' @rdname dbplyr-backend-polarssql
#' @export
simulate_polarssql <- function(...) {
  structure(list(), ..., class = c("polarssql_connection", "TestConnection", "DBIConnection"))
}


#' @export
dbplyr_edition.polarssql_connection <- function(con) 2L


#' @rdname dbplyr-backend-polarssql
#' @inheritParams dbplyr::collapse.tbl_sql
#' @param eager if `TRUE` (default), return a polars DataFrame,
#' otherwise return a polars LazyFrame.
#' @export
compute.tbl_polarssql_connection <- function(
    x,
    eager = TRUE) {
  con <- x$src$con

  vars <- dbplyr::op_vars(x)
  x_aliased <- dplyr::select(x, !!!syms(vars))
  sql <- dbplyr::db_sql_render(con, x_aliased$lazy_query, cte = TRUE)

  if (eager) {
    result_type <- "polars_df"
  } else {
    result_type <- "polars_lf"
  }

  polarssql_query(sql, con, result_type = result_type)
}
