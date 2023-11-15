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
#'  filter(cyl == 4) |>
#'  arrange(desc(mpg)) |>
#'  head(n = 3)
NULL


#' @param ... Any parameters to be forwarded
#' @export
#' @rdname dbplyr-backend-polarssql
simulate_polarssql <- function(...) {
  structure(list(), ..., class = c("polarssql_connection", "TestConnection", "DBIConnection"))
}


#' @export
dbplyr_edition.polarssql_connection <- function(con) 2L
