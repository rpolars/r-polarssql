#' @rdname DBI
#' @inheritParams DBI::dbFetch
#' @usage NULL
dbFetch_polarssql_result <- function(res, n = -1, ...) {
  dbFetch_polarssql_result_inner(res, n, ..., res_func = as.data.frame)
}


#' @rdname DBI
#' @inheritParams DBI::dbFetchArrow
#' @usage NULL
dbFetchArrow_polarssql_result_arrow <- function(res, n = -1, ...) {
  dbFetch_polarssql_result_inner(
    res, n, ...,
    res_func = nanoarrow::as_nanoarrow_array_stream
  )
}


dbFetch_polarssql_result_inner <- function(res, n = -1, ..., res_func) {
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
    res_func()

  res@env$rows_fetched <- res@env$rows_fetched + nrow(out)

  out
}


#' @rdname DBI
#' @export
setMethod("dbFetch", "polarssql_result", dbFetch_polarssql_result)
