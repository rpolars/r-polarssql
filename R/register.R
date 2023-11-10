#' Register data frames as tables
#'
#' @param conn A polars sql connection, created by [polarssql()].
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Name-value pairs of [data.frame] like objects to register.
#' @param names Names of the tables to unregister.
#' @param overwrite Should an existing registration be overwritten?
#' @return These functions are called for their side effect.
#' @export
#' @examples
#' con <- dbConnect(polarssql())
#'
#' polarssql_register(con, df1 = mtcars, df2 = mtcars)
#' con
#'
#' polarssql_unregister(con, c("df1", "df2"))
#' con
polarssql_register <- function(conn, ..., overwrite = FALSE) {
  stopifnot(dbIsValid(conn))

  context <- conn@context
  dots <- list2(...)

  if (!isTRUE(overwrite)) {
    existing_tables <- context$tables()
    new_tables <- names(dots)
    if (any(new_tables %in% existing_tables)) {
      stop(
        "Some tables '",
        intersect(new_tables, existing_tables) |> paste0(collapse = "', '"),
        "' already exist.\n",
        "Set `overwrite = TRUE` if you want to remove the existing table."
      )
    }
  }

  exec(context$register_many, !!!dots)

  invisible(TRUE)
}


#' @rdname polarssql_register
#' @export
polarssql_unregister <- function(conn, names) {
  stopifnot(dbIsValid(conn))

  context <- conn@context
  existing_tables <- context$tables()

  if (!all(names %in% existing_tables)) {
    message(
      "Some tables '",
      setdiff(names, existing_tables) |> paste0(collapse = "', '"),
      "' do not exist."
    )
  }

  context$unregister(names)
  invisible(TRUE)
}
