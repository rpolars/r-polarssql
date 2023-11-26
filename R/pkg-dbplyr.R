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
#' # Test connection shows the SQL query.
#' dbplyr::tbl_lazy(mtcars, simulate_polarssql(), name = "mtcars") |>
#'   filter(cyl == 4) |>
#'   arrange(desc(mpg)) |>
#'   select(contains("c")) |>
#'   head(n = 3)
#'
#' # Actual polarssql connection shows the Polars naive plan.
#' tbl_polarssql(mtcars) |>
#'   filter(cyl == 4) |>
#'   arrange(desc(mpg)) |>
#'   select(contains("c")) |>
#'   head(n = 3)
#'
#' # Unlike other dbplyr backends, `compute` has a special behavior.
#' # It returns a polars DataFrame or LazyFrame.
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


# exported in zzz.R
dbplyr_edition.polarssql_connection <- function(con) 2L


# copied from the dbplyr package
# https://github.com/tidyverse/dbplyr/blob/388a6eef0e634efa693d809061ceac91d3b69a77/R/data-cache.R#L1-L6
cache <- function() {
  if (!is_attached("polarssql_cache")) {
    get("attach")(new_environment(), name = "polarssql_cache", pos = length(search()) - 1)
  }
  search_env("polarssql_cache")
}


# copied from the dbplyr package
# https://github.com/tidyverse/dbplyr/blob/388a6eef0e634efa693d809061ceac91d3b69a77/R/data-cache.R#L8-L18
cache_computation <- function(name, computation) {
  cache <- cache()

  if (env_has(cache, name)) {
    env_get(cache, name)
  } else {
    res <- force(computation)
    env_poke(cache, name, res)
    res
  }
}


#' @rdname dbplyr-backend-polarssql
#' @inheritParams dbplyr::tbl_memdb
#' @export
tbl_polarssql <- function(df, name = deparse(substitute(df))) {
  if (!is_installed("dbplyr")) {
    abort("`polarssql::tbl_polarssql` requires the dbplyr package to be installed")
  }

  con <- polarssql_default_connection()
  dbWriteTable(con, name, df, overwrite = TRUE)

  cache_computation("tbl_polarssql", {
    dplyr::tbl(con, name)
  })
}


#' Compute results of a query
#'
#' @rdname compute.tbl_polarssql_connection
#' @param x A [tbl_polarssql_connection][dbplyr-backend-polarssql] object.
#' @param ... Other arguments passed to [`as_polars_df(<LazyFrame>)`][as_polars_df].
#' @inheritParams dbplyr::compute.tbl_sql
#' @seealso [dbplyr-backend-polarssql]
#' @export
#' @examplesIf polars::pl$polars_info()$features$sql && rlang::is_installed("dbplyr")
#' library(dplyr, warn.conflicts = FALSE)
#'
#' t <- tbl_polarssql(mtcars) |>
#'   filter(cyl == 4)
#'
#' as_polars_lf(t)
#'
#' as_polars_df(t,  n_rows = 1)
#'
#' compute(t, n = 1) # Equivalent to `as_polars_df(t, n_rows = 1)`
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

#' @rdname dbplyr-backend-polarssql
#' @param ... Ignored.
#' @inheritParams compute.tbl_polarssql_connection
# exported in zzz.R
print.tbl_polarssql_connection <- function(x, ...) {
  if (inherits(x$src$con, "TestConnection")) {
    NextMethod("print")
  } else {
    print(compute.tbl_polarssql_connection(x, eager = FALSE))
    invisible(x)
  }
}
