#' @rdname DBI
#' @inheritParams DBI::dbFetch
#' @usage NULL
dbFetch_polars_sql_result <- function(res, n = -1, ...) {
  if (length(n) != 1) {
    stop("need exactly one value in n")
  }
  if (is.infinite(n)) {
    n <- -1
  }
  if (n < -1) {
    stop("cannot fetch negative n other than -1")
  }
  if (n == -1) {
    n <- NULL
  }

  env <- res@env
  lf <- res@query_plan

  out <- lf$slice(offset = env$rows_fetched, length = n) |>
    as.data.frame()

  res@env$rows_want_to_fetch <- res@env$rows_want_to_fetch + (n %||% Inf)
  res@env$rows_fetched <- env$rows_fetched + nrow(out)

  out
}


#' @rdname DBI
#' @export
setMethod("dbFetch", "polars_sql_result", dbFetch_polars_sql_result)
