#' @rdname DBI
#' @inheritParams DBI::dbFetch
#' @usage NULL
dbFetch_polarssql_result <- function(res, n = -1, ...) {
  stopifnot(dbIsValid(res))

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

  out <- res@env$resultset$slice(offset = res@env$rows_fetched, length = n) |>
    as.data.frame()

  res@env$rows_fetched <- res@env$rows_fetched + nrow(out)

  out
}


#' @rdname DBI
#' @export
setMethod("dbFetch", "polarssql_result", dbFetch_polarssql_result)
