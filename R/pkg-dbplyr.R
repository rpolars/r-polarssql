#' polarssql backend for dbplyr
#'
#' Use [simulate_polarssql()] with [dbplyr::tbl_lazy()] or
#' [dbplyr::lazy_frame()] to see simulated SQL without
#' converting to live access.
#' [tbl_polarssql()] is similar to [dbplyr::tbl_memdb()], but the backend is
#' Polars instead of SQLite.
#' It uses [polarssql_default_connection()] as the DBI connection.
#' @name dbplyr-backend-polarssql
#' @aliases NULL
#' @examplesIf rlang::is_installed("dbplyr")
#' library(dplyr, warn.conflicts = FALSE)
#'
#' # Test connection shows the SQL query.
#' dbplyr::tbl_lazy(mtcars, simulate_polarssql(), name = "mtcars") |>
#'   filter(cyl == 4) |>
#'   arrange(desc(mpg)) |>
#'   select(contains("c")) |>
#'   head(n = 3)
#'
#' # Actual polarssql connection shows the Polars naive plan (LazyFrame).
#' tbl_polarssql(mtcars) |>
#'   filter(cyl == 4) |>
#'   arrange(desc(mpg)) |>
#'   select(contains("c")) |>
#'   head(n = 3)
#'
#' # Unlike other dbplyr backends, `compute` has a special behavior.
#' # It returns a polars DataFrame.
#' tbl_polarssql(mtcars) |>
#'   filter(cyl == 4) |>
#'   arrange(desc(mpg)) |>
#'   select(contains("c")) |>
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


#' @noRd
# exported in zzz.R
dbplyr_edition.polarssql_connection <- function(con) 2L


#' @rdname dbplyr-backend-polarssql
#' @inheritParams dbplyr::tbl_memdb
#' @param ... Ignored.
#' @param overwrite If `TRUE`, overwrite the existing table which has the same name.
#' If not `TRUE` (default), skip writing a table if it already exists.
#' @export
tbl_polarssql <- function(df, name = deparse(substitute(df)), ..., overwrite = FALSE) {
  if (!is_installed("dbplyr")) {
    abort("`polarssql::tbl_polarssql` requires the dbplyr package to be installed")
  }

  con <- polarssql_default_connection()
  if (isTRUE(overwrite) || !(name %in% dbListTables(con))) {
    dbWriteTable(con, name, df, overwrite = TRUE)
  }
  dplyr::tbl(con, name)
}


#' Compute results of a dbplyr query
#'
#' @rdname compute.tbl_polarssql_connection
#' @param x A [tbl_polarssql_connection][tbl_polarssql()] object.
#' @param ...
#' - For [`as_polars_lf(<tbl_polarssql_connection>)`]: Ignored.
#' - For Other functions: Other arguments passed to [`as_polars_df(<RPolarsLazyFrame>)`][as_polars_df].
#' @inheritParams dbplyr::compute.tbl_sql
#' @export
#' @examplesIf rlang::is_installed("dbplyr")
#' library(dplyr, warn.conflicts = FALSE)
#' library(polars)
#'
#' t <- tbl_polarssql(mtcars) |>
#'   filter(cyl == 4)
#'
#' as_polars_lf(t)
#'
#' as_polars_df(t, n_rows = 1)
#'
#' compute(t, n = 1) # Equivalent to `as_polars_df(t, n_rows = 1)`
#'
#' as.data.frame(t, n_rows = 1)
#'
#' # Clean up
#' DBI::dbDisconnect(polarssql_default_connection())
as_polars_lf.tbl_polarssql_connection <- function(x, ..., cte = TRUE) {
  con <- x$src$con

  vars <- dbplyr::op_vars(x)
  x_aliased <- dplyr::select(x, !!!syms(vars))
  sql <- dbplyr::db_sql_render(con, x_aliased$lazy_query, cte = cte)

  con@env$context$execute(sql)
}


#' @rdname compute.tbl_polarssql_connection
#' @inheritParams as_polars_lf.tbl_polarssql_connection
#' @export
as_polars_df.tbl_polarssql_connection <- function(x, ..., cte = TRUE) {
  as_polars_lf(x, cte = cte) |>
    as_polars_df(...)
}


#' @rdname compute.tbl_polarssql_connection
#' @inheritParams as_polars_lf.tbl_polarssql_connection
#' @inheritParams dbplyr::compute.tbl_sql
# exported in zzz.R
compute.tbl_polarssql_connection <- function(
    x,
    ...,
    n = Inf,
    cte = TRUE) {
  as_polars_df(x, n_rows = n, cte = cte, ...)
}


#' @rdname compute.tbl_polarssql_connection
#' @inheritParams as_polars_df.tbl_polarssql_connection
#' @export
as.data.frame.tbl_polarssql_connection <- function(x, ..., cte = TRUE) {
  as_polars_df(x, ..., cte = cte) |>
    as.data.frame()
}


#' @noRd
#' @param ... Ignored.
#' @inheritParams compute.tbl_polarssql_connection
#' @exportS3Method
print.tbl_polarssql_connection <- function(x, ...) {
  if (inherits(x$src$con, "TestConnection")) {
    NextMethod("print")
  } else {
    print(as_polars_lf(x))
    invisible(x)
  }
}
