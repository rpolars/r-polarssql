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
  check_installed("dbplyr")

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
tbl_polarssql <- function(
  df,
  name = deparse(substitute(df)),
  ...,
  overwrite = FALSE
) {
  check_installed("dbplyr")

  con <- polarssql_default_connection()
  if (isTRUE(overwrite) || !(name %in% dbListTables(con))) {
    dbWriteTable(con, name, df, overwrite = TRUE)
  }
  dplyr::tbl(con, name)
}


#' Compute results of a dbplyr query
#'
#' @inheritParams dbplyr::compute.tbl_sql
#' @param x A [tbl_polarssql_connection][tbl_polarssql()] object.
#' @param ...
#' - For [`as_polars_lf(<tbl_polarssql_connection>)`][as_polars_lf]: Ignored.
#' - For `as.data.frame(<tbl_polarssql_connection>)`: Other arguments passed to
#'   [`as.data.frame(<polars_lazy_frame>)`][polars::as.data.frame.polars_data_frame].
#' - For [`as_tibble(<tbl_polarssql_connection>)`][tibble::as_tibble] or
#'   [`collect(<tbl_polarssql_connection>)`][dplyr::collect]: Other arguments passed to
#'   [`as_tibble(<polars_lazy_frame>)`][polars::as_tibble.polars_data_frame].
#' - For Other functions: Other arguments passed to [`as_polars_df(<polars_lazy_frame>)`][as_polars_df].
#' @inheritParams dbplyr::compute.tbl_sql
#' @export
#' @examplesIf rlang::is_installed("dbplyr")
#' library(dplyr, warn.conflicts = FALSE)
#' library(polars)
#'
#' t <- tbl_polarssql(mtcars) |>
#'   filter(cyl == 4) |>
#'   mutate(cyl = sql("CAST (cyl AS Int64)"))
#'
#' as_polars_lf(t)
#'
#' as_polars_df(t, n = 1)
#'
#' compute(t, n = Inf, engine = "streaming")
#'
#' collect(t, n = 5, int64 = "character")
#'
#' # Clean up
#' DBI::dbDisconnect(polarssql_default_connection())
#' @export
as_polars_lf.tbl_polarssql_connection <- function(x, ..., cte = TRUE) {
  con <- x$src$con

  vars <- dbplyr::op_vars(x)
  x_aliased <- dplyr::select(x, !!!syms(vars))
  sql <- dbplyr::db_sql_render(con, x_aliased$lazy_query, cte = cte)

  con@env$context$execute(sql)
}


#' @rdname as_polars_lf.tbl_polarssql_connection
#' @export
as_polars_df.tbl_polarssql_connection <- function(x, ..., n = Inf, cte = TRUE) {
  lf <- if (identical(n, Inf)) {
    as_polars_lf(x, cte = cte)
  } else {
    as_polars_lf(x, cte = cte)$head(n)
  }

  as_polars_df(lf, ...)
}


#' @rdname as_polars_lf.tbl_polarssql_connection
# exported in zzz.R
compute.tbl_polarssql_connection <- as_polars_df.tbl_polarssql_connection


#' @rdname as_polars_lf.tbl_polarssql_connection
#' @export
as.data.frame.tbl_polarssql_connection <- function(
  x,
  ...,
  n = Inf,
  cte = TRUE
) {
  lf <- if (identical(n, Inf)) {
    as_polars_lf(x, cte = cte)
  } else {
    as_polars_lf(x, cte = cte)$head(n)
  }

  as.data.frame(lf, ...)
}


#' @rdname as_polars_lf.tbl_polarssql_connection
# exported in zzz.R
as_tibble.tbl_polarssql_connection <- function(x, ..., n = Inf, cte = TRUE) {
  lf <- if (identical(n, Inf)) {
    as_polars_lf(x, cte = cte)
  } else {
    as_polars_lf(x, cte = cte)$head(n)
  }

  tibble::as_tibble(lf, ...)
}


#' @rdname as_polars_lf.tbl_polarssql_connection
# exported in zzz.R
collect.tbl_polarssql_connection <- as_tibble.tbl_polarssql_connection
