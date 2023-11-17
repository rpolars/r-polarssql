#' polarssql backend for dbplyr
#'
#' Use [simulate_polarssql()] with [dbplyr::tbl_lazy()] or
#' [dbplyr::lazy_frame()] to see simulated SQL without
#' converting to live access.
#' [tbl_polarssql()] is same as [dbplyr::tbl_memdb()], but the backend is
#' Polars instead of SQLite.
#' @name dbplyr-backend-polarssql
#' @aliases NULL
#' @examplesIf polars::pl$polars_info()$features$sql && rlang::is_installed("dbplyr")
#' library(dplyr, warn.conflicts = FALSE)
#'
#' dbplyr::tbl_lazy(mtcars, simulate_polarssql(), name = "mtcars") |>
#'   filter(cyl == 4) |>
#'   arrange(desc(mpg)) |>
#'   head(n = 3)
#'
#' tbl_polarssql(mtcars) |>
#'   filter(cyl == 4) |>
#'   arrange(desc(mpg)) |>
#'   head(n = 3) |>
#'   collect()
#'
#' # Unlike other dbplyr backends, `compute` has a special behavior.
#' # It returns a polars DataFrame or LazyFrame.
#' tbl_polarssql(mtcars) |>
#'   filter(cyl == 4) |>
#'   arrange(desc(mpg)) |>
#'   head(n = 3) |>
#'   compute()
NULL


#' @rdname dbplyr-backend-polarssql
#' @export
simulate_polarssql <- function() {
  if (!is_installed("dbplyr")) {
    abort("dbplyr is not installed")
  }

  dbplyr::simulate_dbi("polarssql_connection")
}


# exported in zzz.R
dbplyr_edition.polarssql_connection <- function(con) 2L


#' @rdname dbplyr-backend-polarssql
#' @inheritParams dbplyr::tbl_memdb
#' @export
tbl_polarssql <- function(df, name = deparse(substitute(df))) {
  if (!is_installed("dbplyr")) {
    abort("dbplyr is not installed")
  }

  con <- polarssql_connection()
  dbWriteTable(con, name, df, overwrite = TRUE)

  dplyr::tbl(con, name)
}


#' @rdname dbplyr-backend-polarssql
#' @inheritParams dbplyr::compute.tbl_sql
#' @param ... Ignored.
#' @param eager if `TRUE` (default), return a polars DataFrame,
#' otherwise return a polars LazyFrame.
# exported in zzz.R
compute.tbl_polarssql_connection <- function(
    x,
    ...,
    eager = TRUE,
    cte = TRUE) {
  con <- x$src$con

  vars <- dbplyr::op_vars(x)
  x_aliased <- dplyr::select(x, !!!syms(vars))
  sql <- dbplyr::db_sql_render(con, x_aliased$lazy_query, cte = cte)

  if (eager) {
    result_type <- "polars_df"
  } else {
    result_type <- "polars_lf"
  }

  polarssql_query(sql, con, result_type = result_type)
}
